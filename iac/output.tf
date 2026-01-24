output "cloud_run_service_name" {
  value = google_cloud_run_v2_service.service.name
}

output "artifact_registry_repo" {
  value = google_artifact_registry_repository.docker_repo.repository_id
}

output "service_account_email" {
  value = google_service_account.cloudrun_sa.email
}

output "cloudrun_service_url" {
  value       = google_cloud_run_v2_service.service.uri
  description = "The public endpoint URL of the Cloud Run service"
}