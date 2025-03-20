terraform {
  backend "gcs" {
    bucket = "multi-microsvc-terraform-state-bucket"
    prefix = "terraform/state"
  }
}
