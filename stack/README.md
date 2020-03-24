## HOW: Add a new Stack

### Example: Add a new Helm Chart for `cert-manager`

Let's walk through an example case to install Jetstack's `cert-manager`.

#### 1. Create a Helm Chart

Helm CLI provides a template for creating a custom chart. Simply run that to create `cert-manager` directory. You will be updating many of the auto-generated files later, so you can leave the files untouched for now.

```bash
$ helm create cert-manager
$ cd cert-manager
```

Note that the chart created will be a "parent" chart. If you want to pull some external dependency from Helm Chart Hub, etc., you still need to perform this step, in order to wire up that dependent chart under a chart you have control over.

#### 2. Add Helm Chart Repository (Optional for some)

If you need to pull down a Helm Chart from some custom location, you need to make that available on your local machine.

`cert-manager` is hosted in Jetstack's repository, so we will need to follow this step. The following command adds the repository to your machine,

```bash
$ helm repo add jetstack https://charts.jetstack.io
```

And then you can update to get the latest charts.

```bash
$ helm repo update
```

#### 3. Add a `requirements.yaml`

In order to specify a dependency, you need to add a new file to the directory. Create a file called `requirements.yaml`, and copy the following content:

```yaml
dependencies:
  - name: cert-manager
    version: 0.11.0
    repository: "alias:jetstack"
```

This assumes that you have added a `jetstack` Helm Chart repository by following the above step#2.

#### 4. Build Dependency

Helm uses this `requirements.yaml` to build out all the dependencies you have.

You can find more about Helm dependencies by running:

```bash
$ helm dep -h
```

For our case, we have all the setup in place, so let's go ahead with building the dependency.

```bash
$ helm dep build
```

After this is complete, you should see `requirements.lock` file created next to `requirements.yaml`, and `cert-manager-v0.11.0.tgz` file created under `charts` directory.

#### 5. Update Definition and Clean Up

You can update some definition information in `Chart.yaml`, and add `cert-manager` specific definitions in `values.yaml`.

For this example, I'm making `values.yaml` empty, and because we do not need to install other charts (which you could do), cleaning up some unused files:

```bash
$ : > values.yaml
$ rm -rf templates
```

#### 6. Update ArgoCD Orchestration

This new chart definition will not be picked up by ArgoCD until you tell it to.

In order to add a new "Application" CRD definition, head to `orchestration` directory, and add a line in `values.yaml` file, such that:

```yaml
apps:
  etcd-operator: false
  falco: false
  istio: true
  cert-manager: true // This is new
  // more apps ...
```

#### 7. Commit and Push

Make sure to commit all the files under `cert-manager` and the new Application CRD definition.

After your push goes through, you should see ArgoCD picking up the latest Helm Chart, and install cert-manager to the cluster.
