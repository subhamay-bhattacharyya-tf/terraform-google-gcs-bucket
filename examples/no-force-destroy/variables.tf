variable "environment" {
  description = "Deployment environment (dev, test, prod)."
  type        = string
  default     = "dev"
}

variable "project_code" {
  description = "Short identifier used for resource naming standardization."
  type        = string
  default     = "portfolio"
}

variable "project_id" {
  description = "GCP project ID."
  type        = string
  default     = "my-gcp-project"
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}

variable "base_name" {
  description = "Base name for the GCS bucket."
  type        = string
  default     = "protected-bucket"
}
