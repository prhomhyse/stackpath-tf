variable "stackpath_stack_id" {}
variable "stackpath_client_id" {}
variable "stackpath_client_secret" {}

provider "stackpath" {
  stack_id         = var.stackpath_stack_id
  client_id     = var.stackpath_client_id
  client_secret = var.stackpath_client_secret
}

resource "stackpath_compute_workload" "terranginx" {
  name = "init-nginx"
  slug = "init-nginx"

  annotations = {
    # request an anycast IP
    "anycast.platform.stackpath.net" = "true"
  }

  network_interface {
    network = "default"
  }

container {
    name = "terranginx"
    image = "nginx:latest"
    resources {
      requests = {
        "cpu"    = "1"
        "memory" = "2Gi"
      }
    }
}

    target {
    name         = "us"
    min_replicas = 1
    max_replicas = 2
    scale_settings {
      metrics {
        metric = "cpu"
        # Scale up when CPU averages 50%.
        average_utilization = 50
      }
    }
    # Deploy these 1 to 2 instances in Dallas, TX, USA and Amsterdam, NL.
    deployment_scope = "cityCode"
    selector {
      key      = "cityCode"
      operator = "in"
      values   = [
        "DFW", "AMS"
      ]
    }
  }
}
