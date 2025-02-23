terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Define the Longhorn Persistent Volume Claim
resource "kubernetes_persistent_volume_claim" "dotnet_pvc" {
  metadata {
    name = "dotnet-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    storage_class_name = "longhorn"
  }
}

# Define the .NET Deployment
resource "kubernetes_deployment" "dotnet_app" {
  metadata {
    name = "dotnet-app"
    labels = {
      app = "dotnet-app"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "dotnet-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "dotnet-app"
        }
      }
      spec {
        container {
          name  = "dotnet-app"
          image = "your-dockerhub-username/your-app-name:latest"
          ports {
            container_port = 80
          }
          volume_mount {
            mount_path = "/data"
            name       = "longhorn-storage"
          }
        }
        volume {
          name = "longhorn-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.dotnet_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

# Define the LoadBalancer Service
resource "kubernetes_service" "dotnet_service" {
  metadata {
    name = "dotnet-app-service"
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "dotnet-app"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

output "load_balancer_ip" {
  value = kubernetes_service.dotnet_service.status[0].load_balancer[0].ingress[0].ip
}

