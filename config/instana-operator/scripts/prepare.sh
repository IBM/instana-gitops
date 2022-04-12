#/bin/bash


# create ns instana-operator to create other stuff: secret/kubeconfig
oc create ns instana-operator

# prepare license from instana
kubectl instana license download --sales-key $INSTANA_SALES_KEY
cat license.json | tr -d '[]"' > license
oc create configmap instana-license -n default --from-file=lic=license

# kubeconfig
oc create secret generic kubeconfig --from-file=credentials=$HOME/.kube/config -n instana-operator


# cert-manager
# ?? if not apply in advance, ??
oc apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml

# optional ??
# if cm/instana-sppem, then create 
# create key.pem, cert.pem
#mycertpem.sh $portalPassword  $base
#cat key.pem cert.pem > sp.pem
#kubectl create configmap instana-sppem -n default --from-file=sppem=sp.pem



