# ============================================================================
# GCS Bucket Module - Variables
# ============================================================================

variable "environment" {
  description = "Deployment environment (dev, test, prod)."
  type        = string

  validation {
    condition     = contains(["devl", "test", "prod"], var.environment)
    error_message = "environment must be one of: devl, test, prod."
  }
}

variable "project_code" {
  description = "Short identifier used for resource naming standardization."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID in which the bucket will be created."
  type        = string
}

variable "region" {
  description = "GCP region for the provider."
  type        = string
  default     = "us-central1"
}

variable "gcs_config" {
  description = "Configuration object for the GCS bucket."
  type = object({
    base_name     = string
    location      = optional(string, "US")
    force_destroy = optional(bool, true)
    storage_class = optional(string, "STANDARD")
    kms_key_name  = optional(string)
    labels        = optional(map(string), {})

    website = optional(object({
      main_page_suffix = optional(string)
      not_found_page   = optional(string)
    }))

    cors = optional(map(object({
      origin          = list(string)
      method          = list(string)
      response_header = optional(list(string), [])
      max_age_seconds = optional(number, 3600)
    })), {})

    lifecycle_rule = optional(list(object({
      action = object({
        type          = string
        storage_class = optional(string)
      })
      condition = object({
        age                        = optional(number)
        created_before             = optional(string)
        with_state                 = optional(string)
        matches_storage_class      = optional(list(string))
        num_newer_versions         = optional(number)
        days_since_noncurrent_time = optional(number)
      })
    })), [])

    autoclass = optional(object({
      enabled                = bool
      terminal_storage_class = optional(string)
    }))

    versioning = optional(object({
      enabled = bool
    }), { enabled = false })
  })

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,29}$", var.gcs_config.base_name))
    error_message = "base_name must be lowercase alphanumeric or dashes, max 30 characters, starting with alphanumeric."
  }

  validation {
    condition     = contains(["US", "US-CENTRAL1", "US-EAST1", "US-EAST4", "NAM4"], var.gcs_config.location)
    error_message = "location must be one of: US, US-CENTRAL1, US-EAST1, US-EAST4, NAM4."
  }

  validation {
    condition     = contains(["STANDARD", "MULTI_REGIONAL", "REGIONAL", "NEARLINE", "COLDLINE", "ARCHIVE"], var.gcs_config.storage_class)
    error_message = "storage_class must be one of: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
  }
}
