variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "client_id" {
  description = "client_id for the xero app"
  type        = string
}

variable "client_secret" {
  description = "client_secret for the xero app"
  type        = string
}

variable "sa_id" {
  description = "Service Account ID"
  type        = string
}

variable "sa_email" {
  description = "The email of the service account"
  type        = string
}