# ============================================================================
# Example: GCS Bucket - Coldline Archival
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
    storage_class = "COLDLINE"
    force_destroy = true
    versioning    = { enabled = false }

    lifecycle_rule = [
      {
        action    = { type = "Delete" }
        condition = { age = 365 }
      }
    ]

    labels = {
      managed-by = "terraform"
      use-case   = "coldline-archival"
    }
  }
}
