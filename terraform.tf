terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 1.19.0"
    }
  }
  required_version = ">= 1.7.0"
}