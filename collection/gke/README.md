
# Darkbit Terraform GKE/K8s API Resource Collection Module

## Support

This repository is maintained by [Darkbit.io](https://darkbit.io), a cloud-native security assessment consulting firm based in the US that helps organizations understand the risks in their cloud and Kubernetes resource configurations.  If you have found an issue, please file it using a GitHub [issue](https://github.com/darkbitio/db-gcp-collection-module/issues/new/choose).

## Contents

This module (**collection/gke**) implements the service accounts and IAM permissions in each project where GKE clusters are deployed. Intended to be included in your existing Terraform codebase that creates and manages the GKE Clusters.

## Usage

Basic usage of this module is as follows:

```hcl
module "gke-prod-cluster" {
  source  = "github.com/darkbitio/db-gcp-collection-module.git//collection/gke?ref=0.1.0"

  # Required 
  cluster_project_id = "<GKE Cluster Project ID>"

  # Optional, but must align with the gke-manifest/cronjob.yaml.sh values
  gke_namespace                    = "darkbit"
  gke_sa_name                      = "darkbit"
  darkbit_exporter_sa_display_name = "Darkbit GKE Exporter"
  darkbit_exporter_sa_description  = "Darkbit GKE Resource Exporter SA using Workload Identity"
}
```

## Features

1. Creates a dedicated GCP ServiceAccount in the current project where the GKE cluster resides.
1. Creates an IAM binding between the Kubernetes ServiceAccount and GCP Service Account.
1. Outputs the generated GCP service account email.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_project_id | The project id where the GKE cluster lives  | `string` | n/a | yes |
| gke_namespace | The namespace where the Darkbit gke-exporter cronjob runs | `string` | `darkbit` | no |
| gke_sa_name | The name of the Kubernetes ServiceAccount used by the Darkbit cronjob pod| `string` | `darkbit` | no |
| darkbit_exporter_sa_display_name | The display name of the SA used to write to the collection bucket | `string` | `Darkbit GKE Exporter` | yes |
| darkbit_exporter_sa_description | The description of the SA used to write to the collection bucket | `string` | `Darkbit GKE Resource Exporter SA using Workload Identity` | yes |

## Outputs

| Name | Description |
|------|-------------|
| darkbit_exporter_sa_id | The id of the GCP service account used for exporting |
| darkbit_exporter_sa_email | The email of the GCP service account used for exporting |

## Requirements

### Software

-   [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
-   [terraform-provider-google] plugin 3.50.x

### Permissions

- `iam.serviceAccounts.create` in the current GKE project
- `iam.serviceAccounts.setIamPolicy` in the current GKE project

### APIs

The project requires the following APIs to be enabled for this module.

- Google Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`
- Google Cloud IAM API: `iam.googleapis.com`
