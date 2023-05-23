# Deploy instana on K8S/OCP using helm

## Instana backend requriements
 - https://www.ibm.com/docs/en/instana-observability/current?topic=requirements-instana-backend#supported-kubernetes-and-red-hat-openshift-versions
 - The Kubernetes Operator runs on any vanilla Kubernetes distribution and Red Hat OpenShift.
     ```
     Minimum supported version:
      Kubernetes	        1.22
      Red Hat OpenShift 	4.9
      ```
## Get Helm
 - Download from https://github.com/helm/helm/releases/
 - Using scripts  
    ```Shell
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    ```
## Setting up datastore using kubernetes operator

## Setting up instana-core

## Setting up instana-units

## Prepare DNS resolve
