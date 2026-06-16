# ADR 001: Terraform State Management Strategy

## Status
Accepted

## Context

The Terraform root module models two lab environments, `dev` and `qa`, from one configuration. The repository needs shared state behavior documented in a way that matches the tracked backend block and the validation workflow.

## Decision

Use an S3 backend with the fields currently tracked in `main.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "infrastructure-automatization-with-terraform"
    key            = "infrastructure-automatization/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}
```

This repository configures S3 backend encryption with `encrypt = true` and Terraform S3 native state locking with `use_lockfile = true`. No DynamoDB locking table is declared because the tracked backend uses native lockfile locking instead.

### Workspace Strategy

- The current root module always instantiates both `module.nginx_server_dev` and `module.nginx_server_qa` from the same configuration.
- Terraform workspaces can isolate separate state snapshots for separate runs of this root module.
- In this repository, workspaces do not select which module instances are active and do not provide clean per-environment isolation by themselves.

### State Layout

- The tracked backend config stores state in the S3 bucket `infrastructure-automatization-with-terraform` using the configured key `infrastructure-automatization/terraform.tfstate`.
- If non-default Terraform workspaces are used, Terraform stores workspace-specific state objects using the backend's workspace-aware S3 layout rather than the default workspace object.
- This ADR does not hardcode literal object paths such as `env:/dev/` or `env:/qa/` because the exact object name is resolved by the backend implementation.
- No DynamoDB locking table is declared in the tracked backend configuration.
- The tracked backend enables S3 server-side encryption and native lockfile-based state locking.

## Consequences

- State is stored remotely in the configured S3 bucket
- State encryption is requested through the backend with `encrypt = true`
- State locking uses Terraform S3 native lockfile support via `use_lockfile = true`
- The current root module manages both environment module instances together in one configuration
- Workspace usage changes which state snapshot Terraform reads and writes for a run, not which environment modules exist in this root module
- The S3 bucket must exist before backend initialization

## Implementation

- Backend initialized with `terraform init`
- Workspaces, if used, are managed via `terraform workspace` commands
- CI validates with `terraform init -backend=false`, `terraform validate`, TFLint, and Checkov
- Pull request plans are attempted only when repository AWS credentials are available to the workflow

## References
- AWS S3 backend documentation
- Terraform workspace documentation
