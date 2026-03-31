# GCS Bucket - Lifecycle Rules Example

Creates a Google Cloud Storage bucket with automatic lifecycle rules that transition objects to cheaper storage classes and delete them after a retention period.

## Source

```hcl
module "gcs_bucket" {
  source = "../.."

  environment  = "devl"
  project_code = "portfolio"

  gcs_config = {
    base_name  = "archive"
    location   = "US"
    versioning = { enabled = true }

    lifecycle_rule = [
      {
        action    = { type = "SetStorageClass", storage_class = "NEARLINE" }
        condition = { age = 30 }
      },
      {
        action    = { type = "SetStorageClass", storage_class = "COLDLINE" }
        condition = { age = 90 }
      },
      {
        action    = { type = "Delete" }
        condition = { age = 365 }
      }
    ]
  }
}
```

Bucket name follows the pattern `<project_code>-<base_name>-<location>-<environment>`, e.g. `portfolio-archive-us-devl`.

## Lifecycle Rules

| Rule | Action                   | Condition                      |
| ---- | ------------------------ | ------------------------------ |
| 1    | Move to NEARLINE         | Object age >= 30 days          |
| 2    | Move to COLDLINE         | Object age >= 90 days          |
| 3    | Delete object            | Object age >= 365 days         |
| 4    | Delete non-current vers. | 3 or more newer versions exist |

## Usage

```bash
terraform init

terraform plan \
  -var='environment=devl' \
  -var='project_code=myapp' \
  -var='project_id=my-gcp-project'

terraform apply \
  -var='environment=devl' \
  -var='project_code=myapp' \
  -var='project_id=my-gcp-project'
```

## Inputs

| Name         | Description                              | Type   | Default        |
| ------------ | ---------------------------------------- | ------ | -------------- |
| environment  | Deployment environment (devl, test, prod) | string | devl            |
| project_code | Short identifier for resource naming     | string | portfolio      |
| project_id   | GCP project ID                           | string | portfolio-site |
| region       | GCP region                               | string | us-central1    |

## Outputs

| Name                 | Description                                |
| -------------------- | ------------------------------------------ |
| bucket_id            | The ID of the bucket                       |
| bucket_name          | The name of the bucket                     |
| bucket_project       | The project ID where the bucket is created |
| bucket_location      | The location of the bucket                 |
| bucket_url           | The URL of the bucket                      |
| bucket_self_link     | The self link of the bucket                |
| bucket_storage_class | The storage class of the bucket            |
| bucket_force_destroy | Whether force_destroy is enabled           |

## Requirements

- Terraform >= 1.3.0
- Google provider >= 7.23.0
