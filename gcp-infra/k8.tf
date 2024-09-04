# # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
# resource "kubernetes_namespace" "production" {
#   metadata {
#     name = "production"
#   }
# }

# resource "kubernetes_deployment" "nginx_deployment" {
#   metadata {
#     name = "nginx-demo"
#     labels = {
#       app = "nginx"
#     }
#   }

# spec {
#     replicas = 3
#     selector {
#       match_labels = {
#         app = "nginx"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "nginx"
#         }
#       }
#       spec {
#         container {
#           image = "nginx:latest"
#           name  = "nginx"
#           port {
#             container_port = 80
#           }
#         }
#       }
#     }
#   }
# }
# resource "kubernetes_service" "nginx_service" {
#   metadata {
#     name = "nginx-service"
#   }
#   spec {
#     selector = {
#       app = "nginx"
#     }
#     port {
#       protocol = "TCP"
#       port     = 80
#       target_port = 80
#     }
#     type = "LoadBalancer"
#   }
# }

# Kubernetes Provider
# provider "kubernetes" {
#   config_path = "~/.kube/config"  # Path to your kubeconfig file
# }

# Define the Deployment
resource "kubernetes_deployment" "flask_time_api" {
  metadata {
    name = "flask-time-api"
    labels = {
      app = "flask-time-api"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "flask-time-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask-time-api"
        }
      }

      spec {
        container {
          name  = "flask-time-api"
          image = "opemipo/shortlet-app:time-api"  # Your Docker Hub image

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

# Define the Service
resource "kubernetes_service" "flask_time_api_service" {
  metadata {
    name = "flask-time-api-service"
  }

  spec {
    selector = {
      app = "flask-time-api"
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 5000
    }
  }
}
