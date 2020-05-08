# Specify StackPath Provider and your access details
provider "stackpath" {
  stack_id      = var.stackpath_stack_id
  client_id     = var.stackpath_client_id
  client_secret = var.stackpath_client_secret
}

# Create a new compute workload that launches an nginx virtual_machine
resource "stackpath_compute_workload" "jollofx" {
  # A human friendly name for the workload
  name = "Jollof X Workload"
  # A DNS compatible value that uniquely identifies
  # a workload.
  slug = "jollofx-workload"

  labels = {
    "role"        = "web-server"
    "environment" = "production"
  }

  network_interface {
    network = "default"
  }

  # Define your virtual machine
  virtual_machine {
    # Name that should be given to the virtual machine
    name = "terrajollofx"
    # OS image to use for the virtual machine
    image = "stackpath-edge/ubuntu-1804-bionic:v201909061930"
    
    resources {
      requests = {
        "cpu"    = "1"
        "memory" = "2Gi"
      }
    }

    port {
      name = "ssh"
      port = 22
      protocol = "TCP"
      enable_implicit_network_policy = true
    }

    port {
      name = "http"
      port = 80
      protocol = "TCP"
      enable_implicit_network_policy = true
    }

    port {
      name =  "https"
      port = 443
      protocol = "TCP"
      enable_implicit_network_policy = true
    }

    user_data = <<EOT
#cloud-config
  ssh-authorized-keys:
    - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCAR73HYZ9LMyPUNIzF8YD/cFaKazeFEX+Obq5C/8AeYc6kbssPCfLWXZfq2e+SSE3IuAiETg4sNtUW9do6zST0VqnA5lopiK34UoxdrAnA7RM34sq5kKB1diXF9tG0zz5tOPFMK3rwAFRod8ZF+2i5XIHkh6GULHry3vLfMGT8NwUovtSjpL+wOpW/2U4JNRQy3MMjiS9KHonczng4gfj41c/zHFhy7HvHt3iaXJ3EgUaZcPtSl50Q0j/YW/z7PnLLLkjcMz0KzEmwbTpuDswT6Ywl9o6/xJpM+pG1cfJ2dcAARyEIQIUz5+wHPoy2l8yFspY4fa9BE9Al79ZWyOv/ promise@example.com
EOT

    liveness_probe {
      period_seconds = 60
      success_threshold = 1
      failure_threshold = 4
      initial_delay_seconds = 60
      http_get {
        port = 80
        # defaults to "/"
        path = "/"
        # defaults to http
        scheme = "HTTP"
      }
    }

    readiness_probe {
      tcp_socket {
        port = 80
      }
      period_seconds = 60
      success_threshold = 1
      failure_threshold = 4
      initial_delay_seconds = 60
    }
  }

  # Define the target configurations that select
  # where workloads should be deployed.
  target {
    # Provider a name to the target, this name must be
    # a valid DNS label as described by RFC 1123, it can
    # only contain the characters 'a-z', '0-9', '-', '.'.
    name = "us"
    # The scope of where the compute instance should
    # be launched. The only option currently supported
    # is "cityCode".
    deployment_scope = "cityCode"

    # Create a single instance in each location that
    # matches the selectors defined below.
    min_replicas = 1

    # Define a selector that should be used to
    # decide where workload instances should be
    # launched. You can define multiple selectors
    # for a workload.
    selector {
      # Select the location to create an instance by
      # the city code of the location. This is currently
      # the only supported option.
      key = "cityCode"
      # The operator to use when comparing values
      operator = "in"
      # The city code that instances should be created in.
      values = [
        "SEA",
        "JFK",
      ]
    }
  }
}
