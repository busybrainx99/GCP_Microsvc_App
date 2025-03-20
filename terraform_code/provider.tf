provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone # Optional if you're using regional clusters
}

#kubeconfig context setter
provider "kubernetes" {
  config_path    = var.config_path
  config_context = "gke_${var.project_id}_${var.zone}_${var.name}"
}

#helm provider 
provider "helm" {
  kubernetes {
    config_path = var.config_path
  }
}
