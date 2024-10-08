#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

#----------------------------------------
# Variables to Set - Replace with your values
#----------------------------------------

# Replace with your desired GCP Project ID and Name
PROJECT_ID="semantc-sandbox"
PROJECT_NAME="semantc-sandbox"

# GCP Region
REGION="us-central1"

# Service Account details
SERVICE_ACCOUNT_NAME="terraform-sa"
SERVICE_ACCOUNT_DISPLAY_NAME="Terraform Service Account"

# Buckets for Terraform state
BUCKET_NAME_CORE="terraform-state-semantc-sandbox"
BUCKET_NAME_CLIENT="terraform-state-client"

#----------------------------------------
# Set the default project for gcloud
#----------------------------------------

echo "Setting the default project for gcloud"

gcloud config set project "${PROJECT_ID}"

#----------------------------------------
# Enable Required APIs
#----------------------------------------

APIS=(
  run.googleapis.com
  bigquery.googleapis.com
  storage.googleapis.com
  secretmanager.googleapis.com
  cloudbuild.googleapis.com
  logging.googleapis.com
  monitoring.googleapis.com
  cloudscheduler.googleapis.com
  iam.googleapis.com
  cloudresourcemanager.googleapis.com
)

echo "Enabling required APIs"

for api in "${APIS[@]}"; do
  echo "Enabling API: $api"
  gcloud services enable "$api"
done

#----------------------------------------
# Create the Terraform Service Account
#----------------------------------------

echo "Creating Terraform service account: ${SERVICE_ACCOUNT_NAME}"

gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}" \
  --display-name="${SERVICE_ACCOUNT_DISPLAY_NAME}"

SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

#----------------------------------------
# Grant Permissions to the Service Account
#----------------------------------------

ROLES=(
  roles/compute.admin
  roles/iam.serviceAccountUser
  roles/iam.serviceAccountAdmin
  roles/resourcemanager.projectIamAdmin
  roles/storage.admin
  roles/bigquery.admin
  roles/secretmanager.admin
  roles/cloudbuild.builds.editor
  roles/cloudscheduler.admin
  roles/run.admin
  roles/serviceusage.serviceUsageAdmin
)

echo "Assigning IAM roles to the service account"

for role in "${ROLES[@]}"; do
  echo "Assigning role: $role"
  gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="${role}"
done

#----------------------------------------
# Generate a Key for the Service Account
#----------------------------------------

echo "Generating service account key file"

gcloud iam service-accounts keys create terraform-sa-key.json \
  --iam-account="${SERVICE_ACCOUNT_EMAIL}"

echo "Service account key saved to terraform-sa-key.json"

#----------------------------------------
# Create GCS Buckets for Terraform State
#----------------------------------------

echo "Creating GCS bucket for core Terraform state: gs://${BUCKET_NAME_CORE}"

gsutil mb -p "${PROJECT_ID}" -l "${REGION}" "gs://${BUCKET_NAME_CORE}"

echo "Creating GCS bucket for client Terraform state: gs://${BUCKET_NAME_CLIENT}"

gsutil mb -p "${PROJECT_ID}" -l "${REGION}" "gs://${BUCKET_NAME_CLIENT}"

echo "Enabling versioning on the buckets"

gsutil versioning set on "gs://${BUCKET_NAME_CORE}"
gsutil versioning set on "gs://${BUCKET_NAME_CLIENT}"

#----------------------------------------
# Set Bucket Permissions
#----------------------------------------

echo "Granting the service account access to the core bucket"

gsutil iam ch "serviceAccount:${SERVICE_ACCOUNT_EMAIL}:objectAdmin" "gs://${BUCKET_NAME_CORE}"

echo "Granting the service account access to the client bucket"

gsutil iam ch "serviceAccount:${SERVICE_ACCOUNT_EMAIL}:objectAdmin" "gs://${BUCKET_NAME_CLIENT}"

#----------------------------------------
# Verification Steps
#----------------------------------------

echo "Verifying enabled services"

gcloud services list --enabled

echo "Verifying IAM policy bindings for the service account"

gcloud projects get-iam-policy "${PROJECT_ID}" \
  --flatten="bindings[].members" \
  --format='table(bindings.role)' \
  --filter="bindings.members:serviceAccount:${SERVICE_ACCOUNT_EMAIL}"

echo "Listing buckets in the project"

gsutil ls -p "${PROJECT_ID}"

echo "Setup complete!"