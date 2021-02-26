# Get GitOps K8s

###### NOTE (Feb 2021): This is undergoing massive updates in all the stacks. Most of the setup works as is, but please expect some installation hiccups with some of the apps.

This repository gets you [GitOps](https://www.weave.works/technologies/gitops/) based Kubernetes environment.

**Make use of template**

This repository is set up as a [template repository](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-template-repository). Because GitOps uses the remote Git repo to sync Kubernetes setup, a direct clone of this repository won't be fit for modifications (it would only install the default set).

In order to benefit from GitOps, [use this template](https://github.com/rytswd/get-gitops-k8s/generate) to create a new repository which you have full control over.

## Contents

- [Examples](#-Examples)
- [Background](#-Background)
- [Details](#-Details)

## 🧪 Examples

### Deploy to KinD (Kubernetes in Docker) with Default

```bash
# Create a local cluster using kind
$ kind create cluster
Creating cluster "kind" ...

# If you want to have more customised cluster, you can run the following instead
$ kind create cluster --config ./tools/kind-config/config-with-2-nodes.yaml --name gitops-k8s
...

# Connect to the local cluster
$ export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"

$ pwd
~/get-gitops-k8s/

# Replace the repository reference with your repo
$ tools/replace-repo-ref.sh

# Start interactive setup
$ make
```

This goes into a very simple interactive mode. You will need to input your [GitHub access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line).

```
Starting K8s Installation

You need the following tools installed on your machine:
	- kubectl (Homebrew: kubernetes-cli)

The following steps will be taken:
	1. Apply prerequisite namespace definition
	2. Set up access token for git repo
	3. Install ArgoCD
	4. Set up ArgoCD with \`stack\` directory
...
```

### Deploy to production

You can mostly use the same set of files to manage PROD, Staging, and Dev clusters.

_To be added_

## 🌗 Background

### Single Source of Truth, Even in Dev

GitOps is gaining popularity thanks to [Flux](https://github.com/fluxcd/flux) by Weaveworks, [Argo CD](https://argoproj.github.io/argo-cd/) by Intuit, and other Open Source projects. There is also a joint "Argo Flux" project, which has been recently announced as of Nov 2019 ([blog](https://www.weave.works/blog/argo-flux-join-forces) from Weaveworks, [blog](https://www.intuit.com/blog/technology/introducing-argo-flux/) from Intuit, [blog](https://aws.amazon.com/blogs/containers/help-us-write-a-new-chapter-for-gitops-kubernetes-and-open-source-collaboration/) from Amazon EKS team). GitOps concept is simple - Git repo as the single source of truth for Kubernetes environment. All changes will be based on Git commits, and no commands should be run manually.

When getting started with Kubernetes, you often see documents like following:

```bash
# 1. Imperative approach
# -- Example from Argo CD
$ kubectl create namespace argocd
```

```bash
# 2. Declarative approach
# -- Example from Argo CD
$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

```bash
# 3. Declarative approach, with Helm (and Tiller)
# -- Example from Falco
$ helm install --name falco stable/falco
```

```bash
# 4. Declarative approach, with shell
# -- Example from Istio
$ curl -sSL https://git.io/getLatestIstio | ISTIO_VERSION=1.3.3 sh -
$ cd istio-1.3.3
$ for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done
```

All of the above works, provided you have followed the correct order. Imperative approach is more prone to issues with ordering, but declarative can still cause a trouble. I have been bitten by Helm's Tiller for a number of times, such as [Error: could not find tiller](https://github.com/helm/helm/issues/4685), [Error: could not find a ready tiller pod](https://github.com/helm/helm/issues/2064), [Error: Unauthorized](https://github.com/helm/helm/issues/6315) to name a few. The above steps may work in the beginning, but as you add more stuff into the cluster, or when you need to frequently set up and shut down a cluster for testing, what has been deployed and applied would be difficult to visualise.

GitOps solution provides a very easily understandable model - whatever is in Git is what Kubernetes has.

After using GitOps for production, I needed the same development experience even for local development with [kind](https://kind.sigs.k8s.io/), and that's how I decided to set this up.

## 📝 Details

### Predefined Application Stacks

This repo holds some popular application YAML / Helm / Kustomize definitions.  
It is only meant for quick testing rather than production grade stability.

| Name                 |   Type    | Version | Default | Verified? |
| -------------------- | :-------: | :-----: | :-----: | :-------: |
| [argo-cd]            | K8s YAML  |  1.4.2  |  true   |    Yes    |
| [argo-workflows]     | Kustomize |  2.7.0  |  false  |    Yes    |
| [etcd-operator]      |   Helm    | 0.10.0  |  false  |    No     |
| [falco]              |   Helm    |  1.0.9  |  false  |    No     |
| [istio]              | Kustomize |  1.5.1  |  true   |  Yes/No   |
| [networkservicemesh] |  Helm v3  |  0.2.0  |  false  |    No     |
| [nats-jetstream]     | K8s YAML  |   NA    |  false  |    Yes    |
| playground           | K8s YAML  |   NA    |  true   |    NA     |
| [sealed-secrets]     |   Helm    |  1.4.3  |  false  |    Yes    |
| [tekton-pipeline]    | K8s YAML  | 0.11.0  |  false  |    Yes    |
| [tekton-dashboard]   | K8s YAML  |  0.6.0  |  false  |    Yes    |
| [tekton-triggers]    | K8s YAML  |  0.4.0  |  false  |    Yes    |
| [vault]              |   Helm    |   NA    |  false  |    No     |
| [vitess]             |   Helm    |         |  false  |    No     |

[argo-cd]: https://github.com/argoproj/argo-cd
[argo-workflows]: https://github.com/argoproj/argo
[etcd-operator]: https://github.com/coreos/etcd-operator
[falco]: https://github.com/falcosecurity/falco
[istio]: https://github.com/istio/istio
[networkservicemesh]: https://github.com/networkservicemesh/networkservicemesh
[nats-jetstream]: https://github.com/nats-io/nats-server
[sealed-secrets]: https://github.com/bitnami-labs/sealed-secrets
[tekton-pipeline]: https://github.com/tektoncd/pipeline
[tekton-dashboard]: https://github.com/tektoncd/pipeline
[tekton-triggers]: https://github.com/tektoncd/pipeline
[vault]: https://github.com/hashicorp/vault-helm
[vitess]: https://github.com/vitessio/vitess

### Directory Setup and Orchestration

There are 4 directories in this repository, and each has very clear responsibility.

#### `init`: Initial GitOps setup with Argo CD

This repository uses [Argo CD](https://argoproj.github.io/argo-cd/) to support GitOps workflow. `init` directory contains only a few files that are used by the initial setup, and these are _not part of GitOps itself_. That means, any commit touching files under this directory will have no effect. Argo CD documentation covers [App of Apps](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#app-of-apps) support, and also [Managing Argo CD using Argo CD](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#manage-argo-cd-using-argo-cd). This repository uses both techniques to provide full control of cluster with clarity, auditability, and simplicity.

I chose Argo CD over other GitOps solutions for several reasons including some usage mentioned above, but one of the biggest reasons was the great UI support to visualise GitOps in action.

#### `orchestration`: Orchestrate Dependencies

Argo CD has a notion of "Application", which is a bundle of K8s resources, defined under a Git repository. `orchestration` directory is used as a parent Application, which defines Applications underneath it. Applications allow multiple formats, and `orchestration` uses Helm Chart format. This allows enabling and disabling Application by defining a flag in `values.yaml` file, provided that a dependency directory is ready for integration.

As you can see in `orchestration/templates/` directory, it checks against `apps:` stanza you see in `values.yaml`. ArgoCD will then pick up whichever dependency that's set with `enabled: true`, and assumes that the matching directory name exists under `stack` directory.

#### `stack`: Resource Definitions for Each Application

Each Application can contain as many resources as it needs, and it allows a few formats:

- Single directory with K8s YAMLs
- Kustomize
- Helm chart

In this repo, I have added some dependencies to showcase this in `orchestration/values.yaml`. You can find the full list in [this table](#Predefined-Application-Stacks).

You can add more as you like. For most common scenarios, you can simply add an element in `orchestration/values.yaml`, and create a directory inside `stack/` containing the resources with the above format.

#### `tools`: Tools for Frequently Used Setup

This repository also comes with simplistic scripts to help set up the cluster.

- `tools/replace-repo-ref.sh`  
  Replaces all `github.com/rytswd/get-gitops-k8s` with your repo.  
  You can set both username and repository name with this.

# Other Notes

Argo CD is not designed to write back to Git. It cannot listen to Docker registry changes, as that falls outside of their GitOps design. If any additional features outside of Git control such as Docker registry is needed, those should be a separate setup utilising systems such as [Argo Events](https://argoproj.github.io/argo-events/), making Argo CD a purely dependent on Git as single source of truth. This [issue](https://github.com/argoproj/argo-cd/issues/1648) also has some clear mention of the Argo CD intention.
