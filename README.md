# stackpath-tf
Deploy StackPath Edge Computing Resources (VMs and Containers) using Terraform

The Terraform version for this project is `0.12.24`.
You can get your StackPath API details by following this [guide](https://stackpath.dev/docs/getting-started).

```
variable "stackpath_stack_id" {}
variable "stackpath_client_id" {}
variable "stackpath_client_secret" {}

provider "stackpath" {
  stack_id      = var.stackpath_stack_id
  client_id     = var.stackpath_client_id
  client_secret = var.stackpath_client_secret
}
```

`virtual_machine` and `container` are not [modules](https://www.terraform.io/docs/configuration/modules.html) but independent Terraform configuration files.

A module scenario will look like this:

```
virtual_machine
  |-network_policy
  |  |-main.tf
  |  |-variables.tf
  |  |-outputs.tf
  |-main.tf
  |-variables.tf
  |-outputs.tf
```

### TODO 

- Better use of variables instead of hardcoding values.
- Edge Compute Containers
- Network Policies

