# Terraform Template Specification

Generate these files in the `/` directory:

**main.tf:**

- GCS bucket using the `terraform-google-module-template` module (source: `github.com/subhamay-bhattacharyya-tf/terraform-google-module-template`)

**locals.tf:**

A map type variable must be created from the input variable and the bucket name must be in the following format:

```text
<project_code>-<base_name>-<location>-<environment>
```

**variables.tf:**

## 1. `environment` _(string)_

Represents the deployment environment (e.g., `dev`, `test`, `prod`).

## 2. `project_code` _(string)_

Short identifier used for naming standardization.

## 3. `gcs_config` _(object)_

Represents the bucket attribute attribute map.

The object type variable with the GCS Bucket arguments

| Attribute | Type | Required | Default | Validation |
| --- | --- | --- | --- | --- |
| `base_name` | `string` | Yes | — | Alphanumeric or dashes, max length ≤ 30 |
| `location` | `string` | No | `US` | One of: `US`, `US-CENTRAL1`, `US-EAST1`, `US-EAST4`, `NAM4` |
| `force_destroy` | `boolean` | No | `true` | — |
| `website` | `object` | No | `null` | Should include `main_page_suffix` and `not_found_page` |
| `cors` | `map(object)` | No | `{}` | Must follow GCS CORS structure |
| `lifecycle_rule` | `list(map(object))` | No | `[]` | Must follow GCS lifecycle rule schema |
| `storage_class` | `string` | No | `STANDARD` | One of: `STANDARD`, `MULTI_REGIONAL`, `REGIONAL`, `NEARLINE`, `COLDLINE`, `ARCHIVE` |
| `autoclass` | `map(object)` | No | `{}` | Enable/disable Autoclass configuration |
| `versioning` | `map(object)` | No | `{ enabled = true }` | `{ enabled = true/false }` |
| `kms_key_name` | `string` | No | `null` | Must be a valid KMS key resource path |
| `labels` | `map(string)` | No | `{}` | Key-value pairs for governance |

- Variables for: GCS Configuration (gcs_config) which is an object type variable

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

**examples/:**

- `examples/basic/` - with a main.tf that references the root module and passes example values for all variables without website and lifecycle policy. This should be a working example that can be validated separately from the root module.

- `examples/lifecycle/` - with a main.tf that references the root module and passes example values for all variables with lifecycle policy. This should be a working example that can be validated separately from the root module.

- `examples/website/` - with a main.tf that references the root module and passes example values for all variables with website configuration and without lifecycle policy. This should be a working example that can be validated separately from the root module.

- `examples/autoclass/` - with a main.tf that references the root module and passes example values for all variables autoclass. This should be a working example that can be validated separately from the root module.

- `examples/versioning/` - with a main.tf that references the root module and passes example values for all variables with vensioning enabled and without lifecycle policy. This should be a working example that can be validated separately from the root module.

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

**README.md:**

- All the badges should always point to the correct repository and the custom endpoint badge shold point to So, least on the financial side, they are creating this finance one finance data product. In the medallion architecture, they have bronze going on iceberg, so that is okay; one cue for you to include icebergs somewhere. This shows that we have some understanding of what Farmer's vision is. `current repository`.json.

- The README.md should address the warning - `MD060/table-column-style: Table column style [Table pipe is missing space to the left for style "compact"] markdownlint(MD060)`
