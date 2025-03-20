
#Cluster
resource "google_container_cluster" "gke_cluster" {
  name               = var.name
  location           = var.zone
  initial_node_count = 1
  network            = google_compute_network.gke_network.id
  subnetwork         = google_compute_subnetwork.gke_subnet.id


  deletion_protection = false



}

# Network/VPC
resource "google_compute_network" "gke_network" {
  name                    = "${var.name}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke_subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.gke_network.id

  secondary_ip_range {
    range_name    = "${var.name}-service-ranges"
    ip_cidr_range = "192.168.1.0/24"
  }

  secondary_ip_range {
    range_name    = "${var.name}-pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }

  lifecycle {
    ignore_changes = [
      secondary_ip_range,
      ip_cidr_range
    ]
  }
}


#  Create a Custom IAM Service Account for GKE
resource "google_service_account" "gke_sa" {
  account_id   = "gke-secret-access"
  display_name = "GKE Secret Access"
}

#  Grant Secret Manager Access to the IAM Service Account
resource "google_project_iam_binding" "gke_sa_secret_access" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.gke_sa.email}"
  ]
}

#Nodepool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.name}-node-pool"
  cluster    = google_container_cluster.gke_cluster.id
  node_count = 1

  #Limit node locations to specific zones 
  # node_locations = ["us-central1-b", "us-central1-c"]

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    preemptible     = false
    machine_type    = "e2-medium"
    disk_size_gb    = 50
    disk_type       = "pd-standard"
    service_account = google_service_account.gke_sa.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = {
      environment = "development"
      owner       = "goodness"
    }

    shielded_instance_config {
      enable_secure_boot = true
    }


  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

}

#update kubeconfig 
# resource "null_resource" "update_kubeconfig" {
#   provisioner "local-exec" {
#     command = <<EOT
#       gcloud container clusters get-credentials ${var.name} \
#         --zone ${var.zone} \
#         --project ${var.project_id}
#     EOT
#   }

#   depends_on = [google_container_node_pool.primary_nodes]
# }



