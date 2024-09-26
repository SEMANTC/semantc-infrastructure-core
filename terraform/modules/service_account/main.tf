resource "google_service_account" "sa" {
  account_id   = var.sa_id
  display_name = var.sa_display_name
  project      = var.project_id
}

resource "google_project_iam_member" "sa_roles" {
  for_each = toset(var.additional_roles)

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.sa.email}"
}
