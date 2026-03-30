# Versioning Explicitly Disabled

GCS bucket with object versioning explicitly set to false, suitable for ephemeral or cost-sensitive workloads.

## Usage

```bash
terraform init -backend=false
terraform validate
```
