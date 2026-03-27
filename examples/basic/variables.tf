# ============================================================================
# Example: Basic GCS Bucket - Variables
# ============================================================================

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
  default     = "portfolio-site"
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}
