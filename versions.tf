terraform {
  required_version = ">= 1.4.2"
  required_providers {
    http = {
      source = "hashicorp/http"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
    shell = {
      source = "scottwinkler/shell"
    }
    remote = {
      source = "tenstad/remote"
    }
  }
}
