#! /bin/sh

# precondition: env var, later be helm chart valuse 
# $dbhost
# $portalPassword 
# $storageClassName
# $imagetag=215-4

if [ "$INSTANA_DOWNLOAD_KEY" = "" -o "$INSTANA_SALES_KEY" = "" -o "$INSTANA_AGENT_KEY" = ""   ] ; then
  echo "var INSTANA_DOWNLOAD_KEY, INSTANA_SALES_KEY, INSTANA_AGENT_KEY not set yet and  exit."
  exit 1
fi
if [ "$dbhost" = "" ] ; then
  echo "var dbhost not set yet and  exit."
  exit 1
fi
if [ "$portalPassword" = "" ] ; then
  echo "var portalPassword not set yet and  exit."
  exit 1
fi
if [ "$storageClassName" = "" ] ; then
  echo "var storageClassName not set yet and  exit."
  exit 1
fi
if [ "$imagetag" = "" ] ; then
  echo "var imagetag not set yet and  exit."
  exit 1
fi

base=`oc get ingresses.config/cluster -o jsonpath={.spec.domain}`



# ------------ operator ------------
# all before helm install be pre-install hook
kubectl create ns instana-operator

oc adm policy add-scc-to-user anyuid -z default -n instana-operator
oc adm policy add-scc-to-user anyuid -z instana-operator -n instana-operator

kubectl create secret docker-registry instana-registry --namespace instana-operator \
    --docker-username=_ \
    --docker-password=$INSTANA_DOWNLOAD_KEY \
    --docker-server=containers.instana.io

kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml

# Install the operator in the specified namespace (e.g. instana-operator)
#kubectl instana operator apply --namespace=instana-operator
helm template instana-operator --set image.tag=$imagetag  --namespace=instana-operator   instana-operator/
helm install  instana-operator --set image.tag=$imagetag  --namespace=instana-operator   instana-operator/


# ------------ cr core , unit ------------
# ns
cat << EOF | oc apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: instana-core
  labels:
    app.kubernetes.io/name: instana-core
---
apiVersion: v1
kind: Namespace
metadata:
  name: instana-units
  labels:
    app.kubernetes.io/name: instana-units
EOF

# ocp scc
oc adm policy add-scc-to-user anyuid -z instana-core -n instana-core
oc adm policy add-scc-to-user anyuid -z default -n instana-core

oc adm policy add-scc-to-user privileged -z default      -n instana-core
oc adm policy add-scc-to-user privileged -z instana-core -n instana-core
oc adm policy add-scc-to-group anyuid     system:serviceaccounts:instana-core
oc adm policy add-scc-to-group privileged system:serviceaccounts:instana-core


oc adm policy add-scc-to-user anyuid -z instana-prod -n instana-units
oc adm policy add-scc-to-user anyuid -z default -n instana-units

oc adm policy add-scc-to-group anyuid     system:serviceaccounts:instana-units
oc adm policy add-scc-to-group privileged system:serviceaccounts:instana-units
oc adm policy add-scc-to-user privileged -z default      -n instana-units
oc adm policy add-scc-to-user privileged -z instana-prod -n instana-units



# instana license and cert stuff
kubectl instana license download --sales-key $INSTANA_SALES_KEY
cat license.json | tr -d '[]"' > license

#TODO: diff k3s without interact input , and if ok, then no expect needed , instana-service-provider can absent??
# create key.pem, cert.pem
mycertpem.sh $portalPassword  $base
cat key.pem cert.pem > sp.pem
# instana-service-provider : not need in 217 per k3s stan.sh??
kubectl create secret generic instana-service-provider  --namespace instana-core --from-literal=sp.key.pass=$portalPassword --from-file=sp.pem=sp.pem
kubectl label secret instana-service-provider   app.kubernetes.io/name=instana -n instana-core


openssl dhparam -out dhparams.pem 2048
openssl req -x509 -newkey rsa:2048 -keyout tls.key -out tls.crt -days 365 -nodes -subj "/CN=instana.$base"
# ls -ltr  
# license.json
# license

# key.pem
# cert.pem
# sp.pem
# dhparams.pem
# tls.key
# tls.crt


# secrets from stuff
# docker-registry instana-registry 
kubectl create secret docker-registry instana-registry --namespace instana-core \
    --docker-username=_ \
    --docker-password=$INSTANA_DOWNLOAD_KEY \
    --docker-server=containers.instana.io
kubectl label secret instana-registry app.kubernetes.io/name=instana --namespace instana-core

# instana-base
kubectl create secret generic instana-base --namespace instana-core \
    --from-literal=downloadKey=$INSTANA_DOWNLOAD_KEY \
    --from-literal=salesKey=$INSTANA_SALES_KEY \
    --from-literal=adminPassword=$portalPassword  \
    --from-file=license=license \
    --from-file=dhparams.pem=dhparams.pem \
    --from-literal=token.secret=uQOkH+Y4wU_0
kubectl label secret instana-base app.kubernetes.io/name=instana --namespace instana-core


# instana-tls
kubectl create secret tls instana-tls --namespace instana-core --cert=tls.crt --key=tls.key
kubectl label secret instana-tls   app.kubernetes.io/name=instana -n instana-core


# cr
echo "creating core ..." 
cat << EOF | oc apply -f -
apiVersion: instana.io/v1beta1
kind: Core
metadata:
  namespace: instana-core
  name: instana-core
spec:
  baseDomain: instana.${base}
  agentAcceptorConfig:
    host: agent.instana.${base}
    port: 443
  resourceProfile: small
  # Datastore configs with default ports for each db
  datastoreConfigs:
    - type: cassandra
      addresses:
        - $dbhost
    - type: cockroachdb
      addresses:
        - $dbhost
    - type: clickhouse
      addresses:
        - $dbhost
    - type: elasticsearch
      addresses:
        - $dbhost
    - type: kafka
      addresses:
        - $dbhost
  rawSpansStorageConfig:
    pvcConfig:
      accessModes:
        - ReadWriteMany
      resources:
        requests:
          storage: 2Gi
      storageClassName: $storageClassName
EOF

echo "creating unit ..." 
cat << EOF | oc apply -f -
apiVersion: instana.io/v1beta1
kind: Unit
metadata:
  namespace: instana-units
  name: instana-prod
spec:
  coreName: instana-core
  coreNamespace: instana-core
  tenantName: instana
  unitName: prod
  initialAgentKey: $INSTANA_DOWNLOAD_KEY
  resourceProfile: small
EOF
 

# routes 
cat << EOF | oc apply -f -
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: acceptor
  namespace: instana-core
spec:
  host: agent.instana.${base}
  port:
    targetPort: 8600
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: passthrough
  to:
    kind: Service
    name: acceptor
EOF

cat << EOF | oc apply -f -
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: gateway-core
  namespace: instana-core
spec:
  host: instana.${base}
  port:
    targetPort: 8443
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: passthrough
  to:
    kind: Service
    name: gateway
EOF

cat << EOF | oc apply -f -
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: gateway-unit
  namespace: instana-core
spec:
  host: prod-instana.instana.${base}
  port:
    targetPort: 8443
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: passthrough
  to:
    kind: Service
    name: gateway
EOF

# wait all pods running and goto ocp route to navigate to instana portal

