provider "google" {
  
    project = var.GCP.id
    region  = var.GCP.region

    batching {
        enable_batching = false
    }

}
