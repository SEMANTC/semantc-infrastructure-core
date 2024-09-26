output "master_service_account_email" {
  description = "email of the Master Service Account"
  value       = module.master_service_account.service_account_email
}
