# GCS Bucket - Basic Example

Creates a Google Cloud Storage bucket with standard storage class, uniform bucket-level access, and public access prevention enforced.

## Source

```hcl
module "gcs_bucket" {
  source = "../.."

  environment  = "devl"
  project_code = "portfolio"

  gcs_config = {
    base_name     = "portfolio-bucket"
    location      = "US"
    storage_class = "STANDARD"
    force_destroy = true
  }
}
```

Bucket name follows the pattern `<project_code>-<base_name>-<location>-<environment>`, e.g. `portfolio-portfolio-bucket-us-devl`.

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
