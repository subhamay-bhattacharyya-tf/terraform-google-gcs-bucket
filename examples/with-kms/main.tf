# ============================================================================
# Example: GCS Bucket - CMEK Encryption
# ============================================================================

module "gcs_bucket" {
  source = "../../"

  environment  = var.environment
  project_code = var.project_code
  project_id   = var.project_id
  region       = var.region

  gcs_config = {
    base_name     = var.base_name
    location      = "US"
    storage_class = "STANDARD"
    force_destroy = true
    versioning    = { enabled = true }
    kms_key_name  = var.kms_key_name

    labels = {
      managed-by = "terraform"
      use-case   = "cmek-encryption"
    }
  }
}
