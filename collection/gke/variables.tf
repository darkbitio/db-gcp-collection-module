# Required 

variable "cluster_project_id" {
  description = "The project id where the GKE cluster lives"
  type        = string
}

# Defaults that can be overridden

variable "gke_namespace" {
  description = "The namespace where the Darkbit gke-exporter cronjob runs"
  type        = string
  default     = "darkbit"
}

variable "gke_sa_name" {
  description = "The name of the Kubernetes ServiceAccount used by the Darkbit cronjob pod"
  type        = string
  default     = "darkbit"
}

variable "darkbit_exporter_sa_display_name" {
  description = "The display name of the SA used to write to the collection bucket"
  type        = string
  default     = "Darkbit GKE Exporter"
}

variable "darkbit_exporter_sa_description" {
  description = "The description of the SA used to write to the collection bucket"
  type        = string
  default     = "Darkbit GKE Resource Exporter SA using Workload Identity"
}
