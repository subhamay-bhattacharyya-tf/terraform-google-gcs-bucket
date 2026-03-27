# ============================================================================
# Example: GCS Bucket - Autoclass Storage Management
# ============================================================================

module "gcs_bucket" {
  source = "../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  gcs_config = {
    base_name     = "autoclass"
    location      = "US"
    storage_class = "STANDARD"
    force_destroy = true
    versioning    = { enabled = false }
    labels = {
      managed-by = "terraform"
      use-case   = "autoclass"
    }

    autoclass = {
      enabled                = true
      terminal_storage_class = "ARCHIVE"
    }
  }
}
