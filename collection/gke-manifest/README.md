
# Darkbit GKE Export CronJob Manifest

## Support

This repository is maintained by [Darkbit.io](https://darkbit.io), a cloud-native security assessment consulting firm based in the US that helps organizations understand the risks in their cloud and Kubernetes resource configurations.  If you have found an issue, please file it using a GitHub [issue](https://github.com/darkbitio/db-gcp-collection-module/issues/new/choose).

## Contents

This folder contains the shell script named `cronjob.yaml.sh` as a helper to generate a valid manifest.

1. Modify the following fields:

   * `EXPORTER_GCP_SA_EMAIL` - This is the service account email created in the same project as the GKE cluster.  The manual and terraform instructions create a service account in the following format: `"darkbit-gke-exporter@<my-project-id>.iam.gserviceaccount.com`.
   * `GCS_BUCKET_NAME` - This is the name of the dedicated, Darkbit-hosted GCS bucket that is provided to you as a part of onboarding.
   * `EXPORTER_GKE_SA_KEY` - This is the base64-encoded (not encrypted) string that contains the dedicated GKE Collection Service Account Key material.  Use only if provided with this content by Darkbit as a part of onboarding.
2. Run `./cronjob.yaml.sh > darkbit-exporter-cronjob.yaml` followed by `kubectl apply -f darkbit-exporter-cronjob.yaml`.
3. Optionally, leverage `./cronjob.yaml.sh > darkbit-exporter-cronjob.yaml` to generate the manifest and use it as the basis for a Helm chart or other installation tool.
