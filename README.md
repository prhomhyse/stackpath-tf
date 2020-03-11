# stackpath-tf
Deploy StackPath Edge Computing Resources (VMs and Containers) using Terraform

Take note of the **old syntax** that may return errors when you `terraform plan` on Terraform version `0.12.23`:

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
