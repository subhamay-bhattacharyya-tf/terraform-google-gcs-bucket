# ============================================================================
# Example: GCS Bucket - All Features Enabled
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
    kms_key_name  = var.kms_key_name

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

    lifecycle_rule = [
      {
        action    = { type = "Delete" }
        condition = { age = 365 }
      },
      {
        action    = { type = "Delete" }
        condition = { num_newer_versions = 5, with_state = "ARCHIVED" }
      }
    ]

    labels = {
      managed-by  = "terraform"
      environment = "prod"
      team        = "platform"
      cost-centre = "engineering"
    }
  }
}
