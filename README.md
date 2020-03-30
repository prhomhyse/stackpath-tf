# stackpath-tf
Deploy StackPath Edge Computing Resources (VMs and Containers) using Terraform

Take note of the **old syntax** that may return errors when you `terraform plan` on Terraform version `0.12.24`:

```
variable "stackpath_stack" {}
variable "stackpath_client_id" {}
variable "stackpath_client_secret" {}

provider "stackpath" {
  stack         = "${var.stackpath_stack}"
  client_id     = "${var.stackpath_client_id}"
  client_secret = "${var.stackpath_client_secret}"
}
```

The new syntax that works:

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

For more help, visit this guide: https://stackpath.dev/docs/getting-started

`virtual_machine` and `container` are not modules but independent Terraform configuration files.

A module scenario will look like this:

virtual_machine
  |-network_policy
  |  |-main.tf
  |  |-variables.tf
  |  |-outputs.tf
  |-main.tf
  |-variables.tf
  |-outputs.tf

