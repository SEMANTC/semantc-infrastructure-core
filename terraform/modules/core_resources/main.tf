# create Secret in Secret Manager for Xero App ID
resource "google_secret_manager_secret" "core_client_id_xero" {
  secret_id = "core-client-id-xero"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# stores Xero token to Secret
resource "google_secret_manager_secret_version" "core_client_id_xero_version" {
  secret      = google_secret_manager_secret.core_client_id_xero.name
  secret_data = var.client_id
}

# grant access to master Service Account to access Secrets
resource "google_secret_manager_secret_iam_member" "master_secret_access_client_id" {
  secret_id = google_secret_manager_secret.core_client_id_xero.id
  role      = "roles/secretmanager.secretAccessor"
  member    =  "serviceAccount:${var.sa_email}"
}

# create Secret in Secret Manager for Xero App ID
resource "google_secret_manager_secret" "core_client_secret_xero" {
  secret_id = "core-client-secret-xero"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# stores Xero token to Secret
resource "google_secret_manager_secret_version" "core_client_secret_xero_version" {
  secret      = google_secret_manager_secret.core_client_secret_xero.name
  secret_data = var.client_secret
}

# grant access to master Service Account to access Secrets
resource "google_secret_manager_secret_iam_member" "master_secret_access_client_secret" {
  secret_id = google_secret_manager_secret.core_client_secret_xero.id
  role      = "roles/secretmanager.secretAccessor"
  member    =  "serviceAccount:${var.sa_email}"
}