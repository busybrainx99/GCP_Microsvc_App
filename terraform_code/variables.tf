variable "project_id" {
  description = "The ID of the GCP project where resources will be created"
  type        = string
}

variable "name" {
  description = "The name of the cluster to be created"
  type        = string
}

variable "zone" {
  description = "The zone the cluster would be created in"
  type        = string
}
variable "region" {
  description = "The region the cluster network would be created in"
  type        = string
}

variable "account_id" {
  description = "The account id the cluster would be craeted with"
  type        = string
}

variable "config_path" {
  description = "The config path to validate the cluster"
  type        = string
}
