variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "sa_id" {
  description = "Service Account ID"
  type        = string
}

variable "sa_display_name" {
  description = "Service Account Display Name"
  type        = string
}

variable "additional_roles" {
  description = "List of IAM roles to assign to the Service Account"
  type        = list(string)
  default     = []
}
