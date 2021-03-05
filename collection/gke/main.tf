// Create the Darkbit Google SA in the GKE project
resource "google_service_account" "darkbit-exporter-sa" {
  project      = var.cluster_project_id
  account_id   = "darkbit-gke-exporter"
  display_name = var.darkbit_exporter_sa_display_name
  description  = var.darkbit_exporter_sa_description
}

// Make an IAM policy that allows the GKE/K8s SA to use workload identity to become the GCP SA
data "google_iam_policy" "darkbit-exporter-workload-identity" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      format("serviceAccount:%s.svc.id.goog[%s/%s]", var.cluster_project_id, var.gke_namespace, var.gke_sa_name)
    ]
  }
}

// Bind the workload identity IAM policy to the GSA
resource "google_service_account_iam_policy" "darkbit-exporter" {
  service_account_id = google_service_account.darkbit-exporter-sa.name
  policy_data        = data.google_iam_policy.darkbit-exporter-workload-identity.policy_data
}
