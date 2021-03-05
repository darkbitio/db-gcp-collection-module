output "darkbit_exporter_sa_id" {
  description = "The id of the GCP service account used for exporting"
  value       = google_service_account.darkbit-exporter-sa.id
}

// GCP SA Email
output "darkbit_exporter_sa_email" {
  description = "The email of the GCP service account used for exporting"
  value       = google_service_account.darkbit-exporter-sa.email
}
