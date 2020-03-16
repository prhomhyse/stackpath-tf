# Define the variables that are needed to execute this plan.

variable "stackpath_stack_id" {
  description = "The StackPath ID of the Stack you want to create these resources in."
  type        = string
}

variable "stackpath_client_id" {
  description = "The client ID to use for API authentication."
  type        = string
}

variable "stackpath_client_secret" {
  description = "The client secret to use for API authentication."
}

provider "stackpath" {
  stack_id      = var.stackpath_stack_id
  client_id     = var.stackpath_client_id
  client_secret = var.stackpath_client_secret
}