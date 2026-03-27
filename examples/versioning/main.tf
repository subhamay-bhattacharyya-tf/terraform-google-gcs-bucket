# ============================================================================
# Example: GCS Bucket - Object Versioning
# ============================================================================

module "gcs_bucket" {
  source = "../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  gcs_config = {
    base_name     = "versioned"
    location      = "US"
    storage_class = "STANDARD"
    force_destroy = true
    versioning    = { enabled = true }
    labels = {
      managed-by = "terraform"
      use-case   = "versioning"
    }
  }
}
