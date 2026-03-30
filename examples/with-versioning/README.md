# Object Versioning Enabled

GCS bucket with object versioning on, and a lifecycle rule to automatically delete archived versions once 3 newer copies exist.

## Usage

```bash
terraform init -backend=false
terraform validate
```
