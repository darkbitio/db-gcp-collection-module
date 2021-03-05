variable "organization_id" {
  description = "The current GCP Organization Id"
  type        = string
}

variable "collection_sa_email" {
  description = "The provided GCP Service Account email used for GCP CAI Exports"
  type        = string
}
