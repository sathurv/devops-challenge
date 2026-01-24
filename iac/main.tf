#### Docker registry #####
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "${var.service_name}-repo"
  format        = "DOCKER"
}

#### Service account #####
resource "google_service_account" "cloudrun_sa" {
  account_id   = "${var.service_name}-sa"
  display_name = "Service Account for Cloud Run service"
}


resource "google_artifact_registry_repository_iam_member" "cloudrun_pull" {
  repository = google_artifact_registry_repository.docker_repo.name
  location   = var.region
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}


#### Cloud Run Service ###
resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.cloudrun_sa.email

    containers {
      image = var.image_url
      ports {
        container_port = var.container_port
      }
    }

    scaling {
      min_instance_count = var.min_instance_count
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  depends_on = [
    google_artifact_registry_repository_iam_member.cloudrun_pull
  ]
}


resource "google_cloud_run_v2_service_iam_member" "public" {
  name     = google_cloud_run_v2_service.service.name
  location = google_cloud_run_v2_service.service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
