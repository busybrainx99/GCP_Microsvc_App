output "cluster_name" {
  value       = google_container_cluster.gke_cluster.name
  description = "The name of the GKE cluster"
}

output "cluster_endpoint" {
  value       = google_container_cluster.gke_cluster.endpoint
  description = "The endpoint of the GKE cluster"
}

output "cluster_master_version" {
  value       = google_container_cluster.gke_cluster.master_version
  description = "The Kubernetes version used by the GKE cluster"
}

output "vpc_network_name" {
  value       = google_compute_network.gke_network.name
  description = "The name of the VPC network"
}

output "subnetwork_cidr" {
  value       = google_compute_subnetwork.gke_subnet.ip_cidr_range
  description = "The primary CIDR range of the subnetwork"
}

output "pod_secondary_range" {
  value       = google_compute_subnetwork.gke_subnet.secondary_ip_range[0].ip_cidr_range
  description = "The secondary IP range for Pods"
}

output "svc_secondary_range" {
  value       = google_compute_subnetwork.gke_subnet.secondary_ip_range[1].ip_cidr_range
  description = "The secondary IP range for Services"
}

output "node_pool_name" {
  value       = google_container_node_pool.primary_nodes.name
  description = "The name of the node pool"
}

output "node_machine_type" {
  value       = google_container_node_pool.primary_nodes.node_config[0].machine_type
  description = "The machine type of the nodes in the node pool"
}

output "service_account_email" {
  value       = google_service_account.gke_sa.email
  description = "The email of the service account used by the node pool"
}



