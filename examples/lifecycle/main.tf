# ============================================================================
# Example: GCS Bucket - Lifecycle Rules
# ============================================================================

module "gcs_bucket" {
  source = "../.."

  environment  = var.environment
  project_code = var.project_code
  project_id   = var.project_id
  region       = var.region

  gcs_config = {
    base_name     = "archive"
    location      = "US"
    storage_class = "STANDARD"
    force_destroy = true
    versioning    = { enabled = true }
    labels = {
      managed-by = "terraform"
      use-case   = "lifecycle-archiving"
    }

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
      },
      {
        action    = { type = "Delete" }
        condition = { num_newer_versions = 3, with_state = "ARCHIVED" }
      }
    ]
  }
}
