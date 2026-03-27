# ============================================================================
# Example: GCS Bucket - Static Website Hosting
# ============================================================================

module "gcs_bucket" {
  source = "../.."

  environment  = var.environment
  project_code = var.project_code
  region       = var.region

  gcs_config = {
    base_name     = "website"
    location      = "US"
    storage_class = "STANDARD"
    force_destroy = true
    versioning    = { enabled = false }
    labels = {
      managed-by = "terraform"
      use-case   = "static-website"
    }

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
  }
}
