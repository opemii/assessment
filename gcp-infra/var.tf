variable "project_id" {
  description = "Project ID"
  type = string
  default = "central-bulwark-434606-u9"
}

variable "cluster_name" {
  description = "k8s Cluster Name"
  type = string
  default = "my-cluster"
}

variable "node_pool_name" {
  description = "k8s Node Pool Name"
  type = string
  default = "my-node-pool"
}

variable "state_bucket_name" {
  description = "bucket name"
  type = string
  default = "assessment-bucket-shortlet"
}

variable "project_number" {
  description = "bucket name"
  type = string
  default = "1091131360319"
}
variable "region" {
  type    = string
  default = "us-central1"
}

# variable "zone" {
#   type    = string
#   default = "northamerica-northeast1-a"
# }

variable "release_channel" {
  type    = string
  default = "RAPID"
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = "172.16.0.0/28"
}

variable "node_size" {
  type    = string
  default = "n2d-standard-4"
}

variable "gh_repo" {
  type = string
  description = "The GitHub repo in the format username/repo_name"
  default = "opemii/assessment"
}

variable "gh_branch" {
  type = string
  description = "The Branch on which the Workflow execution will be authorised in the format refs/heads/<BRANCH_NAME>"
  default = "refs/heads/main"
}

