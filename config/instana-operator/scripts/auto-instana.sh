#/bin/bash


# check var set


# run prepare.sh


# install instana using sh, helm or gitops application yaml
# 1. install-instana-ocp.sh
install-instana-ocp.sh

# 2. helm 
helm install instana-operator --set image.tag=215-4  --namespace=instana-operator --set INSTANA_DOWNLOAD_KEY=$INSTANA_DOWNLOAD_KEY --set INSTANA_SALES_KEY=$INSTANA_SALES_KEY --set INSTANA_AGENT_KEY=$INSTANA_AGENT_KEY      instana-operator/

# 3. gitops argocd app
kubeapi=$(kubectl config current-context | cut -f2 -d/ | sed "s/-/./g")
kube_master="https://"$kubeapi

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cp4waiops
  namespace: openshift-gitops
spec:
  syncPolicy:
    automated: {}
  project: default
  source:
    repoURL: https://github.com/lihongbj/instana-gitops
    path: config/instana-operator
    targetRevision: dev
    helm:
      parameters:
        - name: spec.dockerPassword
          value: $ibm_entitlement_key
  destination:
    server: $kube_master
    namespace: cp4waiops

