<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Prerequisites](#prerequisites)
- [Install Crossplane Instana Provider on Kubernetes](#install-crossplane-instana-provider-on-kubernetes)
  - [Create Application to Install Crossplane Instana Provider](#create-application-to-install-crossplane-instana-provider)
  - [Verify Crossplane Provider](#verify-crossplane-provider)
- [Deploy Instana](#deploy-instana)
  - [Create secret for target k8s kubeconfig](#create-secret-for-target-k8s-kubeconfig)
  - [Create configmap for Instana settings](#create-configmap-for-instana-settings)
  - [Create Argo CD application for installing Instana](#create-argo-cd-application-for-installing-instana)
- [Verify Instana Installation](#verify-instana-installation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


This is a tutorial for how to deploy Instana with Kubernetes GitOps.

## Prerequisites

- Kubernetes Cluster
- [Argo CD](https://argo-cd.readthedocs.io/en/stable/getting_started/#6-create-an-application-from-a-git-repository) was deployed in the Kubernetes Cluster
- [Crossplane](https://crossplane.io/docs/v1.4/getting-started/install-configure.html) was deployed in the Kubernetes Cluster

**NOTE:** If you do not have such Kubernetes Cluster, please refer to [GitOps Quick Start with Kubernetes KIND Cluster](https://github.com/cloud-pak-gitops/community/blob/main/gitops-quick-start-with-kind.md#gitops-quick-start-with-kubernetes-kind-cluster) for settting up Argo CD with a Kubernetes KIND Cluster.

In this tutorial, Argo CD was deployed in `argocd` namespace and Crossplane was deployed in `crossplane-system` namespace.

```console
root@gyliu-dev21:~# kubectl get po -n argocd
NAME                                 READY   STATUS    RESTARTS   AGE
argocd-application-controller-0      1/1     Running   0          5d20h
argocd-dex-server-5fc596bcdd-l6prz   1/1     Running   0          5d20h
argocd-redis-5b6967fdfc-l4r4k        1/1     Running   0          5d20h
argocd-repo-server-98598b6c7-v6rmj   1/1     Running   0          5d20h
argocd-server-5b4b7b868b-sxkgl       1/1     Running   0          5d20h
```
```console
root@gyliu-dev21:~# kubectl get po -n crossplane-system
NAME                                           READY   STATUS      RESTARTS   AGE
crossplane-6584bb9489-7lf7x                    1/1     Running     0          4m19s
crossplane-provider-instana-6c578cd958-6fqlq   1/1     Running     0          2m24s
```

## Install Crossplane Instana Provider on Kubernetes

### Create Application to Install Crossplane Instana Provider

- Create application
- Choose `New App` in `Applications`
- Input parameters as follows, then `create`
  - GENERAL
    - Application Name: crossplane
    - Project: default
    - SYNC POLICY: Automatic
  - SOURCE
    - REPO URL : https://github.com/cloud-pak-gitops/instana-gitops
    - Target version: HEAD
    - path: instana-automatic/crossplane
  - DESTINATION
    - Cluster URL: https://kubernetes.default.svc
    - Namespace: crossplane-system
  - DIRECTORY
    - DIRECTORY RECURSE: check it

### Verify Crossplane Provider

After instana provider was deployed, you can run the command as follows to check:

```
kubectl get po -n crossplane-system
```

In this tutorial, the output of the above command is as follows:

```console
root@gyliu-dev21:~# kubectl get po -n crossplane-system
NAME                                           READY   STATUS      RESTARTS   AGE
crossplane-6584bb9489-7lf7x                    1/1     Running     0          5m23s
crossplane-provider-instana-6c578cd958-6fqlq   1/1     Running     0          3m28s
crossplane-rbac-manager-856c9bb5df-vp95m       1/1     Running     0          5m23s
scc-instana-job-fm42r                          0/1     Completed   0          3m24s
```

You can see Instana provider was running, and there is also a job pod named as `scc-instana-job-fm42r` which was used to detect if Instana was going to be deployed in Kubernetes or OpenShift Cluster.

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

Input parameters as follows when creating application:
- GENERAL
  - Application Name: instana
  - Project: default
  - SYNC POLICY: Automatic
- SOURCE
  - REPO URL : https://github.com/cloud-pak-gitops/instana-gitops
  - Target version: HEAD
  - path: instana-automatic/instana
- DESTINATION
  - Cluster URL: https://kubernetes.default.svc
  - Namespace: crossplane-system
- DIRECTORY
  - DIRECTORY RECURSE: check it

## Verify Instana Installation

TODO