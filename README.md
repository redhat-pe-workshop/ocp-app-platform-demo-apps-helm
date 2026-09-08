# OpenShift App Platform — Reusable Helm Charts

This repository is a fork of [redhat-ads-tech/ocp-app-platform-demo-apps-helm](https://github.com/redhat-ads-tech/ocp-app-platform-demo-apps-helm) for the Red Hat Platform Engineering Workshop.

It contains two reusable Helm charts consumed as dependencies by RHDH-scaffolded application manifests repos.

## Charts

| Chart | Description |
|---|---|
| **app-deployer** | Generic runtime deployer — renders Namespace, Deployment, Service, Route, HPA, NetworkPolicy, ServiceMonitor, Waypoint, and ServiceAccount resources for OpenShift. |
| **build-deployer** | Generic secured build pipeline deployer — renders Tekton Pipelines, Tasks, Triggers, ExternalSecrets, and webhook setup for CI with built-in security scanning (ACS, SBOM, TPA). Includes a production promotion pipeline that retags images via `skopeo copy` and opens a GitLab MR as an approval gate. **Note:** ClusterRoleBinding removed in v0.2+ to allow deployment by developer-owned Applications. |

## Helm Repository

Charts are published to GitHub Pages via [chart-releaser-action](https://github.com/helm/chart-releaser-action).

- **Repository index:** https://redhat-pe-workshop.github.io/ocp-app-platform-demo-apps-helm/index.yaml
- **Releases:** https://github.com/redhat-pe-workshop/ocp-app-platform-demo-apps-helm/releases

### Usage

Add the repository:

```bash
helm repo add pe-workshop https://redhat-pe-workshop.github.io/ocp-app-platform-demo-apps-helm
helm repo update
```

Consume as a dependency in your `Chart.yaml`:

```yaml
dependencies:
  - name: app-deployer
    version: "~0.1"
    repository: "https://redhat-pe-workshop.github.io/ocp-app-platform-demo-apps-helm"
    alias: app

  - name: build-deployer
    version: "~0.2"  # Use 0.2+ for ClusterRoleBinding removal
    repository: "https://redhat-pe-workshop.github.io/ocp-app-platform-demo-apps-helm"
    alias: build
```
