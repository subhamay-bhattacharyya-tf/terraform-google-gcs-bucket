# ============================================================================
# Example: GCS Bucket - Auto-Tier via Lifecycle Transitions
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

    lifecycle_rule = [
      {
        action    = { type = "SetStorageClass", storage_class = "NEARLINE" }
        condition = { age = 30 }
      },
      {
        action    = { type = "SetStorageClass", storage_class = "COLDLINE" }
        condition = { age = 90 }
      },
      {
        action    = { type = "Delete" }
        condition = { age = 365 }
      }
    ]

    labels = {
      managed-by = "terraform"
      use-case   = "lifecycle-transition"
    }
  }
}
