# resource "google_service_account" "runner_sa" {
#   project      = var.project_id
#   account_id   = "gh-runner"
#   display_name = "Service Account"
# }

data "google_project" "project" {
  project_id = var.project_id
}

# data "google_iam_policy" "wli_user_ghshr" {
#   binding {
#     role = "roles/iam.workloadIdentityUser"

#     members = [
#       "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/gh-pool/attribute.full/${var.gh_repo}${var.gh_branch}",
#     ]
#   }
# }

resource "google_service_account" "tf_plan" {
  account_id   = "tf-plan"
  display_name = "Terraform Planner"
  description   = "SA use to run Terraform Plan"
  project       = var.project_id
}

resource "google_service_account" "tf_apply" {
  account_id   = "tf-apply"
  display_name = "Terraform Applier"
  description   = "SA use to run Terraform Apply"
  project       = var.project_id
}

resource "google_storage_bucket_iam_member" "tf_plan_storage_object_admin" {
  bucket = var.state_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.tf_plan.email}"
}

resource "google_storage_bucket_iam_member" "tf_apply_storage_object_admin" {
  bucket = var.state_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.tf_apply.email}"
}

# resource "google_project_iam_member" "tf_apply_service_account_admin" {
#   project = var.project_id
#   role    = "roles/iam.serviceAccountAdmin"
#   member  = "serviceAccount:${google_service_account.tf_plan.email}"
# }

data "google_iam_policy" "tf_apply_policy1" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/gh-pool/attribute.full/${var.gh_repo}${var.gh_branch}",
    ]
  }
}

data "google_iam_policy" "tf_apply_policy2" {
  binding {
    role = "roles/iam.serviceAccountAdmin"

    members = [
      "serviceAccount:${google_service_account.tf_plan.email}",
    ]
  }
}

data "google_iam_policy" "tf_plan_policy" {
  binding {
    role = "roles/iam.workloadIdentityUser"

    members = [
      "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/github/attribute.event_name/pull_request",
    ]
  }
}

# resource "google_service_account_iam_member" "tf_plan_workload_identity_user" {
#   service_account_id = google_service_account.tf_plan.email
#   role               = "roles/iam.workloadIdentityUser"
#   member             = "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/github/attribute.event_name/pull_request"
# }

# resource "google_service_account_iam_member" "tf_apply_workload_identity_user" {
#   service_account_id = google_service_account.tf_apply.email
#   role               = "roles/iam.workloadIdentityUser"
#   member             = "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/github-pool/attribute.workflow_ref/opemmii/workload-identity-federation/.github/workflows/terraform.yaml@refs/heads/main"
# }



# resource "google_service_account_iam_policy" "admin-account-iam" {
#   service_account_id = google_service_account.runner_sa.name
#   policy_data        = data.google_iam_policy.wli_user_ghshr.policy_data
# }

resource "google_iam_workload_identity_pool" "github-pool" {
  project                   = var.project_id
  provider                  = google
  workload_identity_pool_id = "github-pool"
}

resource "google_iam_workload_identity_pool_provider" "github-provider" {
  provider                           = google
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  attribute_mapping                  = {
    "google.subject" = "assertion.sub"
    "attribute.actor"= "assertion.actor"
    "attribute.repository"= "assertion.repository"
    "attribute.repository_owner"= "assertion.repository_owner"
    "attribute.workflow_ref" = "assertion.job_workflow_ref"
    "attribute.event_name"= "assertion.event_name"
    "attribute.full" = "assertion.repository+assertion.ref"
  }
  oidc {
    allowed_audiences = ["google-wlif"]
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }
}