# ============================================================================
# Example: GCS Bucket - Deletion Protection
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
    force_destroy = false
    versioning    = { enabled = true }

    labels = {
      managed-by = "terraform"
      use-case   = "deletion-protection"
    }
  }
}
