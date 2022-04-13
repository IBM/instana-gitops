#/bin/bash

# create ns instana-operator to create other stuff: secret/kubeconfig
oc create ns instana-operator

# kubeconfig
oc create secret generic kubeconfig --from-file=credentials=$HOME/.kube/config -n instana-operator

# cert-manager
oc apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml

