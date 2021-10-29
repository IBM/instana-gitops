<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Prerequisites](#prerequisites)
- [Install Crossplane Instana Provider on Kubernetes](#install-crossplane-instana-provider-on-kubernetes)
  - [Create Application to Install Crossplane Instana Provider](#create-application-to-install-crossplane-instana-provider)
  - [Verify Crossplane Provider](#verify-crossplane-provider)
    - [CLI Verify](#cli-verify)
    - [UI Verify](#ui-verify)
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
    - Application Name: crossplane-provider-parent-app
    - Project: default
    - SYNC POLICY: Automatic
  - SOURCE
    - REPO URL: https://github.com/cloud-pak-gitops/instana-gitops
    - Revision: HEAD
    - Path: config/argocd-apps/crossplane-provider
  - DESTINATION
    - Cluster URL: https://kubernetes.default.svc
    - Namespace: argocd
  - HELM
    - metadata.argocd_app_namespace: argocd
    - metadata.instana_provider_namespace: crossplane-system
    - repoURL: https://github.com/cloud-pak-gitops/instana-gitops

### Verify Crossplane Provider

#### CLI Verify

After instana provider was deployed, you can run the command as follows to check:

```
kubectl get po -n crossplane-system
kubectl get application -A
argocd app list
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
```console
root@gyliu-dev21:~# kubectl get application -A
NAMESPACE   NAME                             SYNC STATUS   HEALTH STATUS
argocd      crossplane-provider-app          Synced        Healthy
argocd      crossplane-provider-parent-app   Synced        Healthy
```
```console
root@gyliu-dev21:~# argocd app list
NAME                            CLUSTER                         NAMESPACE          PROJECT  STATUS  HEALTH   SYNCPOLICY  CONDITIONS  REPO                                                PATH                           TARGET
crossplane-provider-app         https://kubernetes.default.svc  crossplane-system  default  Synced  Healthy  Auto-Prune  <none>      https://github.com/cloud-pak-gitops/instana-gitops  config/crossplane
crossplane-provider-parent-app  https://kubernetes.default.svc  argocd             default  Synced  Healthy  Auto        <none>      https://github.com/cloud-pak-gitops/instana-gitops  config/argocd-apps/crossplane  HEAD
```

You can see Instana provider was running, and there is also a job pod named as `scc-instana-job-fm42r` which was used to detect if Instana was going to be deployed in Kubernetes or OpenShift Cluster.

#### UI Verify

From Argo CD UI, you will be able to see there are two applications as follows:

- There are two applications, one is `crossplane-provider-parent-app` and another is `crossplane-provider-app`. The `crossplane-provider-parent-app` bring up the `crossplane-provider-app` via the [app-of-apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern).

![all apps](images/argo-overall-app.png)

- This is the deatail of app `crossplane-provider-parent-app`, and the following picture describes the [app-of-apps pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern).

![app of apps](images/app-of-apps.png)

- The following picture is the detail of the `crossplane-provider-app`, you can see all of the resources for this app.
![instana provider](images/instana-propvider-app.png)

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
  - Application Name: instana-parent-app
  - Project: default
  - SYNC POLICY: Automatic
- SOURCE
  - REPO URL : https://github.com/cloud-pak-gitops/instana-gitops
  - Target version: HEAD
  - path: config/argocd-apps/instana
- DESTINATION
  - Cluster URL: https://kubernetes.default.svc
  - Namespace: argocd
  - HELM
    - metadata.argocd_app_namespace: argocd
    - metadata.instana_namespace: crossplane-system
    - repoURL: https://github.com/cloud-pak-gitops/instana-gitops

## Verify Instana Installation

TODO
