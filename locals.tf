# ============================================================================
# GCS Bucket Module - Locals
# ============================================================================

locals {
  bucket_name = "${var.project_code}-${var.gcs_config.base_name}-${lower(var.gcs_config.location)}-${var.environment}"
}
