variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "terraform_sa_key_path" {
  description = "path to the Terraform service account JSON key file"
  type        = string
}

variable "master_sa_display_name" {
  description = "display name for the Master Service Account"
  type        = string
  default     = "Master Service Account for Pipelines"
}

variable "master_sa_id" {
  description = "ID for the Master Service Account"
  type        = string
  default     = "master-sa"
}

variable "required_services" {
  description = "list of GCP services to enable"
  type        = list(string)
  default = [
    "run.googleapis.com",
    "bigquery.googleapis.com",
    "storage.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]
}

variable "master_sa_roles" {
  description = "list of IAM roles to assign to the Master Service Account"
  type        = list(string)
  default = [
    "roles/run.admin",
    "roles/bigquery.admin",
    "roles/storage.admin",
  ]
}

variable "client_id" {
  description = "client_id for the xero app"
  type        = string
}

variable "client_secret" {
  description = "client_secret for the xero app"
  type        = string
}