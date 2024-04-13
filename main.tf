terraform {
  required_providers {
    null = {
      version = "3.2.2"
      source  = "hashicorp/null"
    }
  }
}

resource "null_resource" "example" {}
