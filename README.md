# Get Declarative K8s

This repository aims to provide all you need to get started with K8s setup, that's truly "declarative".

## WHAT: No Command, Just Declare

There are 3 pieces in this repository.

### `init`: Get Argo CD Installed

This repository uses the power of [GitOps](https://www.weave.works/technologies/gitops/), and thus once everything is set up, all updates will be done via Git.

Although [Flux](https://github.com/fluxcd/flux) by Weaveworks is most commonly known for a GitOps solution, I have chosen [Argo CD](https://argoproj.github.io/argo-cd/) by Intuit over it, because of its simplicity and clean architecture. With Argo CD, everything happens only from Git, no magic around Docker repository - if any additional features outside of Git control is needed, those should be a separate setup such as [Argo Events](https://argoproj.github.io/argo-events/), making Argo CD a purely dependent on Git as single source of truth. This [issue](https://github.com/argoproj/argo-cd/issues/1648) also has some clear mention of the Argo CD intention.

Also, Argo CD has a great UI to visualise GitOps in action, which is great for starter, and also for long term management.

### `orchestration`: Orchestrate Dependencies

Argo CD has a notion of "application", which is a bundle of K8s resources. `orchestration` directory is used as a parent application, which has multiple applications underneath it.

As you can see in `get-declarative-k8s/orchestration/templates/` directory, you simply need to add a new application definition here for Argo CD to pick up the new application setup.

### `stack`: Any Tech Stack In Here

Based on the definitions in `orchestration`, the resources in `stack` directory will be deployed to Kubernetes.

You can see that, in this repo, I have added the following dependencies:

- `argocd` (based on Helm)
- `falco` (based on Helm)
- `nats` (based on Helm)
- `playground` (single directory structure)
- `sealed-secrets` (based on Helm)

These are just a few examples to get started with, and you can add more as you like.

Argo CD supports 3 types of K8s resource bundle:

- single directory with K8s yamls
- Helm Chart
- Kustomize

## HOW: Fork -> Replace -> Ready!

This repository is meant to be **fork**ed, so that you can deploy your own Kubernetes stack with GitOps way.

There is a simple script `replace-for-fork.sh` to replace all the existing setup. You can simply run without any argument, and it will interactively replace the setup so that it works with forks.

Once the replacement is completed, push that to your fork, and you can simply run the following, it will go into the interactive mode:

```bash
$ make
Starting K8s Installation

You need the following tools installed on your machine:
	- kubectl (Homebrew: kubernetes-cli)
	- helm (Homebrew: kubernetes-helm)

...
```

If you want to test on your local machine, the easiest way would be to use [`kind`](https://kind.sigs.k8s.io/) to start a local Kubernetes, and run the setup command, such that:

```bash
$ kind create cluster
...
$ export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
$ make
```

## WHY: What's the State of World?

When getting started with Kubernetes, you often see documents like following:

```bash
# 1. Imperative approach
# -- Example from Argo CD
$ kubectl create namespace argocd

# 2. Declarative approach
# -- Example from Argo CD
$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 3. Declarative approach, with Helm (and Tiller)
# -- Example from Falco
$ helm install --name falco stable/falco

# 4. Declarative approach, with shell
# -- Example from Istio
$ curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.3.3 sh -
$ cd istio-1.3.3
$ for i in install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done
```

All of the above works, provided you have followed everything in correct order.

I have been bitten by Helm's Tiller for a number of times, such as [Error: could not find tiller](https://github.com/helm/helm/issues/4685), [Error: could not find a ready tiller pod](https://github.com/helm/helm/issues/2064), [Error: Unauthorized](https://github.com/helm/helm/issues/6315) to name a few.
