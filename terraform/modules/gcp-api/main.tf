resource "google_project_service" "secret_manager" {
  service = "secretmanager.googleapis.com"
  project = var.project_id
}

resource "google_project_service" "cloud_run" {
  service = "run.googleapis.com"
  project = var.project_id
}