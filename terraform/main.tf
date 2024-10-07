terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  backend "gcs" {
    bucket = "terraform-state-semantic-dev-437910"
    prefix = "terraform/master_sa_state"
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.terraform_sa_key_path)
}

# enable required APIs
resource "google_project_service" "enabled_services" {
  for_each = toset(var.required_services)

  service = each.key
  project = var.project_id

  disable_on_destroy = false
}

# create master service account module
module "master_service_account" {
  source               = "./modules/service_account"
  project_id           = var.project_id
  sa_id                = var.master_sa_id
  sa_display_name      = var.master_sa_display_name
  additional_roles     = var.master_sa_roles
}

# create core resources module
module "core_resources" {
  source               = "./modules/core_resources"
  sa_email             = module.master_service_account.service_account_email 
  project_id           = var.project_id
  region               = var.region
  sa_id                = var.master_sa_id
  client_id            = var.client_id
  client_secret        = var.client_secret
}