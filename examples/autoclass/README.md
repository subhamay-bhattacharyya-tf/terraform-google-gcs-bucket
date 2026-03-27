# GCS Bucket - Autoclass Example

Creates a Google Cloud Storage bucket with Autoclass enabled. Autoclass automatically transitions objects to the most cost-effective storage class based on access patterns.

## Source

```hcl
module "gcs_bucket" {
  source = "../.."

  environment  = "dev"
  project_code = "portfolio"

  gcs_config = {
    base_name = "autoclass"
    location  = "US"

    autoclass = {
      enabled                = true
      terminal_storage_class = "ARCHIVE"
    }
  }
}
```

Bucket name follows the pattern `<project_code>-<base_name>-<location>-<environment>`, e.g. `portfolio-autoclass-us-dev`.

## Usage

```bash
terraform init

terraform plan \
  -var='environment=dev' \
  -var='project_code=myapp' \
  -var='project_id=my-gcp-project'

terraform apply \
  -var='environment=dev' \
  -var='project_code=myapp' \
  -var='project_id=my-gcp-project'
```

## Inputs

| Name         | Description                              | Type   | Default        |
| ------------ | ---------------------------------------- | ------ | -------------- |
| environment  | Deployment environment (dev, test, prod) | string | dev            |
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
