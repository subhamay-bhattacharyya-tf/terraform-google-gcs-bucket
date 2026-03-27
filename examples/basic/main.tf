# ============================================================================
# Example: Basic GCS Bucket
# ============================================================================

module "gcs_bucket" {
  source = "../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  gcs_config = {
    base_name     = "portfolio-bucket"
    location      = "US"
    storage_class = "STANDARD"
    force_destroy = true
    versioning    = { enabled = false }
    labels = {
      managed-by = "terraform"
    }
  }
}
