# output a map of instance name to IP address
output "my-terraform-workload-instances" {
  value = {
    for instance in stackpath_compute_workload.jollofx.instances:
    instance.name => instance.external_ip_address
  }
}