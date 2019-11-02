# Get Declarative K8s

This repository aims to provide all you need to get started with K8s setup, that's fully "declarative".

## WHAT: No Command, Just Declare

There are 3 pieces in this repository.

### `init`: Get Argo CD Installed

This repository uses the power of [GitOps](https://www.weave.works/technologies/gitops/), and thus once everything is set up, all updates will be done via Git.

[Flux](https://github.com/fluxcd/flux) was born with such an idea, and has been a popular GitOps solution, thanks to Weaveworks.

I have chosen [Argo CD](https://argoproj.github.io/argo-cd/) by Intuit over Flux, because of its simplicity and clean architecture. With Argo CD, everything happens only from Git, no magic around Docker repository - if any fancy features like that is needed, those will be a separate setup such as [Argo Events](https://argoproj.github.io/argo-events/), for instance.

Also, Argo CD has a great UI to visualise GitOps in action, which is great for starter, and also long term management.

### `orchestration`: Orchestrate Dependencies

Kubernetes is a container orchestration solution. Why do I need another orchestration layer?

The term `orchestration` is only meant to wire up the dependencies in GitOps.

When you add a new dependency, GitOps should be able to pick it up in a meaningful way.

### `main`: All Goodies In Here

So, `init` and `orchestration` are more of Argo CD and GitOps specific setup. Now, here comes the meaty bits.

As long as you have the orchestration template in place, all your updates would happen in this `main` folder.

You can see that, in this repo, I have added the following dependencies:

- argocd
- falco
- nats
- sealed-secrets

These are just a few examples to get started with.

## HOW: Fork -> Replace -> Ready!

This repository is meant to be **fork**ed.

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
