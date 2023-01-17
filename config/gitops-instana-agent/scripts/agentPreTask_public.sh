#!/bin/bash
#set -x

export USER=kubeadmin
export PASSWORD=
export CLUSTER_LONG_NAME=https://api.apm2.cp.fyre.ibm.com:6443
export CLUSTER_SHORT_NAME=apm2
export InstanaNamespace=instana-agent

oc login -u $USER -p $PASSWORD $CLUSTER_LONG_NAME --insecure-skip-tls-verify=true

CLUSTER_CONTEXT_NAME=$(kubectl config view -o jsonpath='{.current-context}')
echo $CLUSTER_CONTEXT_NAME
oc config rename-context $CLUSTER_CONTEXT_NAME $CLUSTER_SHORT_NAME --insecure-skip-tls-verify=true

argocd cluster add $CLUSTER_SHORT_NAME -y
argocd cluster list|grep $CLUSTER_SHORT_NAME

oc new-project $InstanaNamespace

