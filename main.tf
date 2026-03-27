# ============================================================================
# GCS Bucket Module - Main
# Creates and manages a Google Cloud Storage bucket.
# ============================================================================

resource "google_storage_bucket" "this" {
  name                        = local.bucket_name
  location                    = var.gcs_config.location
  storage_class               = var.gcs_config.storage_class
  force_destroy               = var.gcs_config.force_destroy
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  labels = merge(var.gcs_config.labels, {
    environment  = var.environment
    project-code = var.project_code
  })

  dynamic "versioning" {
    for_each = var.gcs_config.versioning != null ? [var.gcs_config.versioning] : []
    content {
      enabled = versioning.value.enabled
    }
  }

  dynamic "website" {
    for_each = var.gcs_config.website != null ? [var.gcs_config.website] : []
    content {
      main_page_suffix = website.value.main_page_suffix
      not_found_page   = website.value.not_found_page
    }
  }

  dynamic "cors" {
    for_each = var.gcs_config.cors
    content {
      origin          = cors.value.origin
      method          = cors.value.method
      response_header = cors.value.response_header
      max_age_seconds = cors.value.max_age_seconds
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.gcs_config.lifecycle_rule
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lifecycle_rule.value.action.storage_class
      }
      condition {
        age                        = lifecycle_rule.value.condition.age
        created_before             = lifecycle_rule.value.condition.created_before
        with_state                 = lifecycle_rule.value.condition.with_state
        matches_storage_class      = lifecycle_rule.value.condition.matches_storage_class
        num_newer_versions         = lifecycle_rule.value.condition.num_newer_versions
        days_since_noncurrent_time = lifecycle_rule.value.condition.days_since_noncurrent_time
      }
    }
  }

  dynamic "autoclass" {
    for_each = var.gcs_config.autoclass != null ? [var.gcs_config.autoclass] : []
    content {
      enabled                = autoclass.value.enabled
      terminal_storage_class = autoclass.value.terminal_storage_class
    }
  }

  dynamic "encryption" {
    for_each = var.gcs_config.kms_key_name != null ? [var.gcs_config.kms_key_name] : []
    content {
      default_kms_key_name = encryption.value
    }
  }
}
