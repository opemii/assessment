locals {
  required_services = [
    "compute.googleapis.com",
    "container.googleapis.com"
  ]
}
resource "google_project_service" "enable_services" {
  for_each       = toset(local.required_services)
  project        = var.project_id
  service        = each.key
  disable_dependent_services = true
# This keeps the service enabled even if Terraform destroys the resource.
}
resource "null_resource" "prep_services" {
  depends_on = [google_project_service.enable_services]
}
