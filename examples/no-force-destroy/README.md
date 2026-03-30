# Deletion Protection

GCS bucket with `force_destroy = false` to prevent accidental deletion of non-empty buckets. Use this pattern in production environments.

## Usage

```bash
terraform init -backend=false
terraform validate
```
