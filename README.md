
# ![Darkbit Logo](img/darkbit-logo.png) Darkbit GCP/GKE Collection Onboarding Instructions and Terraform Module

## Table of Contents

<!-- TOC -->
* [Introduction](#introduction)
  * [Architecture](#architecture)
  * [Requirements](#requirements)
* [Getting Started](#getting-started)
   * [Manual Instructions](#manual-instructions)
   * [Terraform Instructions](#terraform-instructions)
   * [In-GKE Cluster Instructions](#in-gke-cluster-instructions)
* [Validation](#validation)
* [Support](#support)
<!-- TOC -->

## Introduction

This repository contains onboarding instructions for clients of the Darkbit Managed CSP Service.  The steps provided below enable the Darkbit team and/or managed service to collect the necessary data from your GCP environment and optionally, GKE clusters.

### Architecture

There are two main points of collection: the GCP Cloud Asset Inventory and the Kubernetes resources inside each GKE cluster.  To collect the Cloud Asset Inventory, Darkbit will provide you with a dedicated service account (email) that you can grant access at your organization level with a simple IAM binding.  Exporting resources from GKE clusters involves deployment of a `CronJob` deployment inside the cluster with the necessary permissions granted via Workload Identity to give it permission to export the resources to a pre-provisioned GCS Bucket provided by Darkbit.

### Requirements

1. `resourcemanager.organization.setIamPolicy` at the org level
2. `iam.serviceAccounts.create` and `iam.serviceAccounts.setIamPolicy` in each GKE project
3. Each GKE Cluster must be running [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity).
4. `roles/container.admin` or `cluster-admin` via RBAC in each GKE cluster

## Getting Started

To get started, choose whether you want to follow the [manual](#manual-instructions) or the [terraform](#terraform-instructions) approach.

### Manual Instructions

Skip these instructions if you plan to leverage the Terraform instructions below.

1. Manual GCP Cloud Asset Inventory

    Get your GCP Organization number:
    
    ```sh
    gcloud organizations list --format 'value(DISPLAY_NAME,ID)'
    ```

    Set the ORG_ID env variable:
    
    ```sh
    export ORG_ID="111122223333"
    ```
    
    Set the COLLECTION_SA env variable:
    
    ```sh
    export COLLECTION_SA="<collection SA email provided>"
    ```
    
    Add the provided GCP Service Account `Cloud Asset Viewer` at the Organization level.
    
    ```sh
    gcloud organizations add-iam-policy-binding "${ORG_ID}" \
      --member="serviceAccount:${COLLECTION_SA}" \
      --role="roles/cloudasset.viewer"
    ```

2. Manual GKE Project

    Set the PROJECT_ID env variable:
    
    ```sh
    export PROJECT_ID="my-project-id"
    ```

    Ensure you are configured in the correct GKE Project:
    
    ```sh
    gcloud config set project "${PROJECT_ID}"
    ```
    
    Create the GCP ServiceAccount:
    
    ```sh
    gcloud iam service-accounts create darkbit-gke-exporter \
      --description="Darkbit GKE Resource Exporter SA using Workload Identity" \
      --display-name="Darkbit GKE Exporter"
    ```
    
    Bind the GCP SA to this ServiceAccount for Workload Identity Integration:
    
    ```sh
    gcloud iam service-accounts add-iam-policy-binding \
      "darkbit-gke-exporter@${PROJECT_ID}.iam.gserviceaccount.com" \
      --member="serviceAccount:${PROJECT_ID}.svc.id.goog[darkbit/darkbit]" \
      --role="roles/iam.workloadIdentityUser"
    ```
    
    Print the GCP SA:
    
    ```sh
    echo "darkbit-gke-exporter@${PROJECT_ID}.iam.gserviceaccount.com"
    ```    

### Terraform Instructions

Skip these instructions if you have performed the steps above manually.

1. Terraform GCP Cloud Asset Inventory
  
   Follow the instructions [here](/collection/gcp/README.md) to implement collection of the GCP Cloud Asset Inventory at the Organization level.

2. Terraform GKE Project
   
   Follow the instructions [here](/collection/gke/README.md) in each GCP Project where GKE Clusters are present.

### In-GKE Cluster Instructions

If you followed either the manual or Terraform instructions above, you now need to perform these steps.

1. Ensure you are `cluster-admin` or have `roles/container.admin` (Kubernetes Engine Admin)
2. Ensure you have a valid kubeconfig/context pointing at the desired GKE cluster.
3. Follow the instructions [here](collection/gke-manifest/) for each GKE Cluster.

## Support

This repository is maintained by [Darkbit.io](https://darkbit.io), a cloud-native security assessment consulting firm based in the US that helps organizations understand the risks in their cloud and Kubernetes resource configurations.  If you have found an issue, please file it using a GitHub [issue](https://github.com/darkbitio/db-gcp-collection-module/issues/new/choose).
