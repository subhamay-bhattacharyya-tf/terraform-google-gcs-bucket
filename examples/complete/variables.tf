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

variable "region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}

variable "base_name" {
  description = "Base name for the GCS bucket."
  type        = string
  default     = "complete-bucket"
}

variable "kms_key_name" {
  description = "Fully-qualified KMS key resource path for CMEK encryption."
  type        = string
  default     = "projects/PROJECT_ID/locations/us/keyRings/KEY_RING/cryptoKeys/KEY_NAME"
}
