# Auto-Tier via Lifecycle Transitions

GCS bucket that automatically transitions objects through STANDARD → NEARLINE (30d) → COLDLINE (90d) before deleting at 365 days.

## Usage

```bash
terraform init -backend=false
terraform validate
```
