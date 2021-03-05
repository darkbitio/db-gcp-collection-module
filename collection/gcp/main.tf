# Permits collection of CAI resources at the org level
resource "google_organization_iam_member" "collection-organization-iam" {
  org_id = var.organization_id
  role   = "roles/cloudasset.viewer"
  member = "serviceAccount:${var.collection_sa_email}"
}
