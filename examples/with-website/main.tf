# ============================================================================
# Example: GCS Bucket - Static Website Hosting
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
    versioning    = { enabled = false }

    website = {
      main_page_suffix = "index.html"
      not_found_page   = "404.html"
    }

    cors = {
      allow_get = {
        origin          = ["https://example.com", "https://www.example.com"]
        method          = ["GET", "HEAD", "OPTIONS"]
        response_header = ["Content-Type", "Authorization"]
        max_age_seconds = 7200
      }
      allow_post = {
        origin          = ["https://api.example.com"]
        method          = ["POST", "PUT"]
        response_header = ["Content-Type"]
        max_age_seconds = 3600
      }
    }

    labels = {
      managed-by = "terraform"
      use-case   = "static-website"
    }
  }
}
