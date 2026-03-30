# ============================================================================
# Example: GCS Bucket - Object Versioning Enabled
# ============================================================================

module "gcs_bucket" {
  source = "../../"

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  gcs_config = {
    base_name     = var.base_name
    location      = "US"
    storage_class = "STANDARD"
    force_destroy = true
    versioning    = { enabled = true }

    lifecycle_rule = [
      {
        action    = { type = "Delete" }
        condition = { num_newer_versions = 3, with_state = "ARCHIVED" }
      }
    ]

    labels = {
      managed-by = "terraform"
      use-case   = "versioning"
    }
  }
}
