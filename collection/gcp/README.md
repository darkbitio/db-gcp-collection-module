
# Darkbit Terraform GCP Cloud Asset Inventory Collection Module

## Support

This repository is maintained by [Darkbit.io](https://darkbit.io), a cloud-native security assessment consulting firm based in the US that helps organizations understand the risks in their cloud and Kubernetes resource configurations.  If you have found an issue, please file it using a GitHub [issue](https://github.com/darkbitio/db-gcp-collection-module/issues/new/choose).

## Contents

This module (**collection/gcp**) implements the IAM permissions necessary to permit the Darkbit collection service to obtain [GCP Cloud Asset Inventory](https://cloud.google.com/asset-inventory/docs/overview) Exports. Intended to be included in your existing Terraform codebase that creates and manages the GKE Clusters.

## Usage

Basic usage of this module is as follows:

```hcl
module "gcp-cai" {
  source  = "github.com/darkbitio/db-gcp-collection-module.git//collection/gcp?ref=0.1.0"

  # Required 
  organization_id = "<GCP Organization Id Number>"
  collection_sa_email = "<GCP Collection SA Email>"
}
```

## Features

1. Creates an IAM binding for the collection GCP SA to perform Cloud Asset Inventory exports at the organization level
1. Outputs the GCP Organization Id

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| organizaton_id | The current GCP Organization Id| `string` | n/a | yes |
| collection_sa_email | The provided GCP Service Account email used for GCP CAI Exports| `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| org_id | The GCP Organization Number/ID |

## Requirements

### Software

-   [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
-   [terraform-provider-google] plugin 3.50.x

### Permissions

- `resourcemanager.organization.setIamPolicy` at the organization node

### APIs

The project requires the following APIs to be enabled for this module.

- Google Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`
- Google Cloud IAM API: `iam.googleapis.com`
