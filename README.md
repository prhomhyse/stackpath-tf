# stackpath-tf

Examples on how to use Terraform to deploy StackPath Edge Computing Resources (VMs, Containers and Network Policies).

The Terraform version for this project is `0.12.24`.
You can get your StackPath API details by following this [guide](https://stackpath.dev/docs/getting-started).

```tf
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
  - Review and Test resources
  - Add README with solid explanations 
- Network Policies

