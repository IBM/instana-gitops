<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Development Guidance](#development-guidance)
  - [Code Structure](#code-structure)
  - [Contributing](#contributing)
    - [Fork the repo](#fork-the-repo)
    - [Clone the Repo](#clone-the-repo)
    - [Cut Branch](#cut-branch)
    - [Update](#update)
    - [Commit](#commit)
    - [Create PR](#create-pr)
    - [Delete Dev Branch](#delete-dev-branch)
    - [Rebase](#rebase)
  - [Testing](#testing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

<!--
 Copyright 2021 guangyaliu
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
     http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

# Development Guidance

This is some guidance for how to contribute to Instana GitOps.

## Code Structure

- For the Instana GitOps Repo, we are using [App of Apps Pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern).
- Both the Argo CD Application and the Instances managed by Argo CD are wrapped in [Helm Charts](https://argo-cd.readthedocs.io/en/stable/user-guide/helm/).

```
.
├── config
    ├── argocd-apps
    │   ├── Chart.yaml
    │   ├── templates
    │   │   ├── crossplane-app.yaml
    │   │   ├── crossplane-provider-app.yaml
    │   │   └── instana-instance-app.yaml
    │   └── values.yaml
    ├── crossplane-provider
    │   ├── Chart.yaml
    │   ├── templates
    │   │   ├── clusterrolebinding.yaml
    │   │   ├── init
    │   │   │   ├── 00-crossplane-ns.yaml
    │   │   │   └── 99-postsync-job.yaml
    │   │   └── instana-provider
    │   │       ├── config.yaml
    │   │       ├── crds
    │   │       │   ├── instana.crossplane.io_instanas.yaml
    │   │       │   ├── instana.crossplane.io_providerconfigs.yaml
    │   │       │   └── instana.crossplane.io_providerconfigusages.yaml
    │   │       └── deployment.yaml
    │   └── values.yaml
    └── instana
        ├── Chart.yaml
        ├── templates
        │   ├── 99-postsync-job.yaml
        │   └── instana.yaml
        └── values.yaml
```

The application in `argocd-apps` folder will bring up the following instances in order as:
- Crossplane
- Crossplane Instana Provider
- Instana

## Contributing

### Fork the repo

Fork the repo to your own account, in this tutorial, we are using `gyiu513` as the personal account.

### Clone the Repo 

```
git clone git@github.com:gyliu513/instana-gitops.git
cd instana-gitops
git remote add upstream https://github.com/cloud-pak-gitops/instana-gitops
git fetch upstream
git rebase upstream/main
```

### Cut Branch

```
git checkout -b <Your Dev Branch>
```

### Update

Update the logic based on the [Code Structure](#code-structure).

### Commit

```
git add .
git commit -am "Your Commit Message"
git push origin <Your Dev Branch>
```

### Create PR

You can then create a PR from GitHub UI.

### Delete Dev Branch

After your PR got merged, you can delete your dev branch as follows:

```
git checkout main
git branch -D <Your Dev Branch>
```

### Rebase

You may want to rebase your local code to sync up with main branch.

```
git fetch upstream
git rebase upstream/main
```

## Testing

Follow the following guidnace for test with either Kubernetes or OpenShift Cluster, good luck!

- [Using Kubernetes GitOps](./docs/install-instana-with-k8s-gitops.md)
- [Using OpenShift GitOps](./docs/install-instana-with-ocp-gitops.md)
