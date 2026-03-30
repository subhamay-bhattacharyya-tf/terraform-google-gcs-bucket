# Terraform Template Specification

Generate these files in the `/` directory:

**main.tf:** _(delegate to `tf-mod-main` skill)_

- GCS bucket using the `terraform-google-module-template` module (source: `github.com/subhamay-bhattacharyya-tf/terraform-google-module-template`)
- Follow the GCP provider reference and core authoring patterns from the `tf-mod-main` skill

**locals.tf:**

A map type variable must be created from the input variable and the bucket name must be in the following format:

```text
<project_code>-<base_name>-<location>-<environment>
```

**variables.tf:** _(delegate to `tf-mod-vars` skill)_

Use the `tf-mod-vars` skill to author this file. Apply the GCP provider reference and validation patterns. The variable schema is:

| Variable | Type | Required | Notes |
| --- | --- | --- | --- |
| `environment` | `string` | Yes | One of: `dev`, `test`, `prod` |
| `project_code` | `string` | Yes | Short identifier for naming standardization |
| `region` | `string` | No | Default: `us-central1` |
| `gcs_config` | `object` | Yes | See attribute table below |

`gcs_config` attributes:

| Attribute | Type | Required | Default | Validation |
| --- | --- | --- | --- | --- |
| `base_name` | `string` | Yes | — | Alphanumeric or dashes, max length ≤ 30 |
| `location` | `string` | No | `US` | One of: `US`, `US-CENTRAL1`, `US-EAST1`, `US-EAST4`, `NAM4` |
| `force_destroy` | `boolean` | No | `true` | — |
| `website` | `object` | No | `null` | Should include `main_page_suffix` and `not_found_page` |
| `cors` | `map(object)` | No | `{}` | Must follow GCS CORS structure |
| `lifecycle_rule` | `list(object)` | No | `[]` | Must follow GCS lifecycle rule schema |
| `storage_class` | `string` | No | `STANDARD` | One of: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE` |
| `autoclass` | `object` | No | `null` | Enable/disable Autoclass configuration |
| `versioning` | `object` | No | `{ enabled = true }` | `{ enabled = true/false }` |
| `kms_key_name` | `string` | No | `null` | Must be a valid KMS key resource path |
| `labels` | `map(string)` | No | `{}` | Key-value pairs for governance |

**outputs.tf:**

- Outputs for all standard GCS bucket attributes:
  - `bucket_id`
  - `bucket_name`
  - `bucket_project`
  - `bucket_location`
  - `bucket_url`
  - `bucket_self_link`
  - `bucket_storage_class`
  - `bucket_force_destroy`

**versions.tf:**

- Versions.tf should be in the following format

```hcl

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.23.0"
    }
  }
}

provider "google" {
  region = var.region
}
```

**examples/:** _(delegate to `tf-mod-examples` skill)_

Use the `tf-mod-examples` skill to scaffold the full example matrix. Each example must be a self-contained, independently validatable Terraform configuration under `examples/<name>/` with its own `main.tf`, `variables.tf`, `terraform.tfvars`, and `README.md`.

**test/:**

- `test/gcs_bucket_basic_test.go`: This Terratest tests the basic gcs bucket configuration.
- `test/gcs_bucket_lifecycle._test_go`: This Terratest tests the gcs bucket with lifecycle configuration.
- `test/gcs_bucket_website_test.go`: This Terratest tests the gcs bucket with lifecycle configuration.
- `test/gcs_bucket_autoclass_test.go`: This Terratest tests the gcs bucket with autoclass configuration.
- `test/gcs_bucket_versioning_test.go`: This Terratest tests the gcs bucket with version enabled configuration.

**package.json:**

- `github/workflows/ci.yaml`: This is the CI Pipeline. Add all the tests in the terratest job.

Ensure the name is always the repository name.

**package-lock.json:**

Ensure the name is always the repository name.

**CONTRIBUTING.md:**

Ensure in the CONTRIBUTING.md, Reporting Issues must always links to the current repository.

**README.md:** _(delegate to `tf-mod-readme` skill)_

Use the `tf-mod-readme` skill to generate this file. The skill will:

- Auto-resolve the repository name from the current git root
- Check and create the gist badge file if missing
- Populate all badge URLs pointing to the current repository
- Produce terraform-docs-compatible inputs/outputs tables
- Follow markdownlint rules (MD060 table column style)
