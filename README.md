# Terraform Module for GCS Bucket

![Release](https://github.com/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket/actions/workflows/ci.yaml/badge.svg)&nbsp;![GCP](https://img.shields.io/badge/GCP-4285F4?logo=googlecloud&logoColor=white)&nbsp;![Commit Activity](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket)&nbsp;![Last Commit](https://img.shields.io/github/last-commit/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket)&nbsp;![Release Date](https://img.shields.io/github/release-date/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket)&nbsp;![Repo Size](https://img.shields.io/github/repo-size/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket)&nbsp;![File Count](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket)&nbsp;![Issues](https://img.shields.io/github/issues/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket)&nbsp;![Top Language](https://img.shields.io/github/languages/top/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket)&nbsp;![Built with Claude Code](https://img.shields.io/badge/Built%20with-Claude%20Code-623CE4?logo=anthropic&logoColor=white)&nbsp;![Custom Endpoint](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/c2598cfd52891007915dca7b5e3ecbf6/raw/terraform-google-gcs-bucket.json?)

A Terraform module for creating and managing a **Google Cloud Storage (GCS) bucket** on GCP.

## Overview

This module provisions a single `google_storage_bucket` resource. It accepts a structured `gcs_config` object along with `environment` and `project_code` identifiers, enforcing `uniform_bucket_level_access = true` and `public_access_prevention = "enforced"` by default. The bucket name is deterministically constructed as `<project_code>-<base_name>-<location>-<environment>`.

## Requirements

| Requirement | Version |
|---|---|
| Terraform | >= 1.3.0 |
| Google Provider | >= 7.23.0 |

## Usage

```hcl
module "gcs_bucket" {
  source = "github.com/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket"

  environment  = "prod"
  project_code = "myapp"

  gcs_config = {
    base_name     = "portfolio-bucket"
    location      = "US"
    storage_class = "STANDARD"
    force_destroy = false
    versioning    = { enabled = true }
    labels = {
      managed-by = "terraform"
    }
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| `environment` | Deployment environment (`dev`, `test`, `prod`) | `string` | — | yes |
| `project_code` | Short identifier for resource naming | `string` | — | yes |
| `region` | GCP region for the provider | `string` | `"us-central1"` | no |
| `gcs_config` | GCS bucket configuration object | `object` | — | yes |

### `gcs_config` Attributes

| Attribute | Type | Default | Required | Validation |
|---|---|---|---|---|
| `base_name` | `string` | — | yes | Lowercase alphanumeric/dashes, max 30 chars |
| `location` | `string` | `"US"` | no | `US`, `US-CENTRAL1`, `US-EAST1`, `US-EAST4`, `NAM4` |
| `force_destroy` | `bool` | `true` | no | — |
| `storage_class` | `string` | `"STANDARD"` | no | `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE` |
| `versioning` | `object({ enabled = bool })` | `{ enabled = true }` | no | — |
| `website` | `object` | `null` | no | `main_page_suffix`, `not_found_page` |
| `cors` | `map(object)` | `{}` | no | GCS CORS structure |
| `lifecycle_rule` | `list(object)` | `[]` | no | GCS lifecycle rule schema |
| `autoclass` | `object` | `null` | no | `enabled`, `terminal_storage_class` |
| `kms_key_name` | `string` | `null` | no | Valid KMS key resource path |
| `labels` | `map(string)` | `{}` | no | Key-value pairs for governance |

## Outputs

| Name | Description |
|---|---|
| `bucket_id` | The ID of the GCS bucket |
| `bucket_name` | The name of the GCS bucket |
| `bucket_project` | The project ID where the bucket is created |
| `bucket_location` | The location of the GCS bucket |
| `bucket_url` | The URL of the GCS bucket |
| `bucket_self_link` | The self link of the GCS bucket resource |
| `bucket_storage_class` | The storage class of the GCS bucket |
| `bucket_force_destroy` | Whether force_destroy is enabled |

## Examples

| Example | Description |
|---|---|
| [`examples/basic`](examples/basic/) | Standard bucket, no optional features |
| [`examples/website`](examples/website/) | Static website hosting with CORS |
| [`examples/lifecycle`](examples/lifecycle/) | Lifecycle archival rules |
| [`examples/autoclass`](examples/autoclass/) | Automatic storage class tiering |
| [`examples/versioning`](examples/versioning/) | Object versioning enabled |

## CI / Workload Identity Federation Setup

The Terratest job authenticates to GCP via [Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation) (service account impersonation). If the job fails with `Permission 'iam.serviceAccounts.getAccessToken' denied`, grant the WIF pool principal the required IAM binding:

```bash
gcloud iam service-accounts add-iam-policy-binding \
    "sa-17-cloud-storage@prj-17-cloud-storage-16748.iam.gserviceaccount.com" \
    --project="prj-17-cloud-storage-16748" \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/projects/578842011545/locations/global/workloadIdentityPools/github-actions/attribute.repository/subhamay-bhattacharyya-tf/terraform-google-gcs-bucket"
```

The three repository variables required by the CI workflow are:

| Variable | Description |
| --- | --- |
| `GCP_PROJECT_ID` | GCP project ID passed as `GOOGLE_CLOUD_PROJECT` to Terratest |
| `GCP_WORKLOAD_IDENTITY_PROVIDER` | Full WIF provider resource name |
| `GCP_SERVICE_ACCOUNT` | Service account email to impersonate |

## License

Apache 2.0 — see [LICENSE](LICENSE).
