provider "google" {
  project = var.project_id
  region = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = "assessment-bucket-shortlet"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.1"
    }
  }
}

data "google_client_config" "provider" {}

data "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = "us-central1-f"
  project  = var.project_id
  depends_on = [google_container_cluster.primary]
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}