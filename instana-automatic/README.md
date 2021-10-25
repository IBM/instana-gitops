<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Deploy Instana with OpenShift GitOps](#deploy-instana-with-openshift-gitops)
  - [Prerequisites](#prerequisites)
  - [Install Crossplane Instana Provider on OpenShift](#install-crossplane-instana-provider-on-openshift)
    - [Login to ArgoCD](#login-to-argocd)
    - [Install Crossplane Provider](#install-crossplane-provider)
  - [Login to OpenShift and grant Argo CD enough permissions](#login-to-openshift-and-grant-argo-cd-enough-permissions)
  - [Deploy Instana](#deploy-instana)
    - [Create secret for target k8s kubeconfig](#create-secret-for-target-k8s-kubeconfig)
    - [Create configmap for instana settings](#create-configmap-for-instana-settings)
    - [Create Argo CD application for installing Instana](#create-argo-cd-application-for-installing-instana)
  - [Verify Installation](#verify-installation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Deploy Instana with OpenShift GitOps
## Prerequisites

- OpenShift 4.6+
- Gitops Operator (Red Hat OpenShift GitOps) in OpenShift operator-hub
- Crossplane Operator (Upbound Universal Crossplane (UXP)) in OpenShift operator-hub

## Install Crossplane Instana Provider on OpenShift

### Login to ArgoCD

![Login entrance](images/ArgoCD-Interface.png)   

```
Username: admin  
Password: Please copy the Data value of secret "openshift-gitops-cluster" in namespace "openshift-gitops"
```
![Secret data](images/login-argocd-user-pass.png) 

### Install Crossplane Provider

- Create application
- Choose `New App` in `Applications`
- Input parameters as follows, then `create`

```
GENERAL
Application Name: crossplane
Project: default
SYNC POLICY: Automatic

SOURCE
REPO URL : https://github.com/cloud-pak-gitops/instana-gitops
Target version: HEAD
path: instana-automatic/crossplane

DESTINATION
Cluster URL: https://kubernetes.default.svc
Namespace: upbound-system
DIRECTORY
DIRECTORY RECURSE: check it
```

## Login to OpenShift and grant Argo CD enough permissions

```yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: argocd-admin
subjects:
  - kind: ServiceAccount
    name: openshift-gitops-argocd-application-controller
    namespace: openshift-gitops
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
```

## Deploy Instana

### Create secret for target k8s kubeconfig

Using the `kubeconfig` in this repo as example:

```shell
kubectl create secret generic k8s-kubeconfig --from-file=credentials=<kubeconfig> -n crossplane-system
```

**Note:** please replace the `kubeconfig` to your real file , default value: /root/.kube/config

### Create configmap for Instana settings

```shell
kubectl create configmap instana-settings --from-file=<settings.hcl> -n crossplane-system
```

**Note:** please replace the `settings.hcl` to your real file address

### Create Argo CD application for installing Instana

```
GENERAL
Application Name: instana
Project: default
SYNC POLICY: Automatic

SOURCE
REPO URL : https://github.com/cloud-pak-gitops/instana-gitops
Target version: HEAD
path: instana-automatic/instana

DESTINATION
Cluster URL: https://kubernetes.default.svc
Namespace: upbound-system
DIRECTORY
DIRECTORY RECURSE: check it
```

## Verify Installation

TODO
