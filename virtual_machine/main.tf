# Specify StackPath Provider and your access details
provider "stackpath" {
  stack_id      = var.stackpath_stack_id
  client_id     = var.stackpath_client_id
  client_secret = var.stackpath_client_secret
}

# Create a new Ubuntu virtual machine workload
resource "stackpath_compute_workload" "jollofx" {
  name = "Jollof X Workload"
  slug = "jollofx"

  # Define multiple labels on the workload VM.
  labels = {
    "role"        = "web-server"
    "environment" = "production"
  }

  # Define the network interface.
  network_interface {
    network = "default"
  }

  # Define an Ubuntu virtual machine
  virtual_machine {
    # Name that should be given to the VM
    name = "app"

    # StackPath image to use for the VM
    image = "stackpath-edge/ubuntu-1804-bionic:v201909061930"

    # Hardware resources dedicated to the VM
    resources {
      requests = {
        # The number of CPU cores to allocate
        "cpu" = "1"
        # The amount of memory the VM should have
        "memory" = "2Gi"
      }
    }

    # The ports that should be publicly exposed on the VM.
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

    # Cloud-init user data. Provide at least a public key
    user_data = <<EOT
#cloud-config
ssh_authorized_keys:
 - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCk5l6+MVTswob+xbUog2/Ow2J+mX/ZDPDl9W++m+0r5ku859/CTXOm1p+3bGZYWotvBpaFlB8ZQO/2PKYgStqByLzzAwpI7vdGrYHJWAbL76u0uyB9t0ds44GSn9+ehIGjtDs+vEfBTuzeSqCuaSQ51dIapbra+GtORjo75ilITq38kzPKbNOXn0QYOFZqQR+L5cQss+oOg4Ud/8l2NrgEte/KEAmMf4wf2xS0+o/A2jG1cs3x3IYZRR1UaluTBRbrz/Mjg+1KsezuZNJELL2KxbcHUd1xbHRFibzIb1/+gTKddwi7fZwVoORY+Z2tx+25R+vKUF5f74nLyqAlJh45 akpanpromise@hotmail.com
EOT

    liveness_probe {
      period_seconds = 60
      success_threshold = 1
      failure_threshold = 4
      initial_delay_seconds = 60
      http_get {
        port = 80
        path = "/"
        scheme = "HTTP"
        http_headers = {
          "content-type" = "application/json"
        }
      }
    }

    # Define a probe to determine when the instance is ready to serve traffic.
    readiness_probe {
      tcp_socket {
        port = 80
      }
      period_seconds = 60
      success_threshold = 1
      failure_threshold = 4
      initial_delay_seconds = 60
    }

    # Mount an additional volume into the virtual machine.
    volume_mount {
      slug       = "logging-volume"
      mount_path = "/var/log"
    }
  }

  # Define the target configurations
  target {
    name = "us"
    deployment_scope = "cityCode"
    min_replicas = 1
    selector {
      key = "cityCode"
      operator = "in"
      values = [
        "SEA",
        "JFK",
      ]
    }
  }

  # Provision a new additional volume that can be mounted to the containers and
  # virtual machines defined in the workload.
  volume_claim {
    name = "Logging volume"
    slug = "logging-volume"
    resources {
      requests = {
        storage = "100Gi"
      }
    }
  }
}