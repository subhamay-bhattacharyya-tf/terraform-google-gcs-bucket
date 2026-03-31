# ============================================================================
# Example: GCS Bucket - CORS for Web Use
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
    versioning    = { enabled = false }

    website = {
      main_page_suffix = "index.html"
      not_found_page   = "404.html"
    }

    cors = {
      allow_get = {
        origin          = ["https://example.com"]
        method          = ["GET", "HEAD"]
        response_header = ["Content-Type"]
        max_age_seconds = 3600
      }
    }

    labels = {
      managed-by = "terraform"
      use-case   = "cors"
    }
  }
}
