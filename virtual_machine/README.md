# StackPath Edge Compute Virtual Machine
You start by creating the `stackpath_compute_workload` resource. Replace `jollofx` with any name of choice.

`name`: A human friendly name for the workload.

`slug`: A DNS compatible value that uniquely identifies a workload.

Define multiple `labels` on the workload VM. These labels can be used as label selectors when applying network policies.

`role` and `environment` can be named at your discretion. In this example, `web-server` and `production` are used respectively.

`network_interface`: The network interfaces that should be provisioned for the workload instances. StackPath only supports a `default` network for edge compute workloads.

Provide the `name` and `image` to use for the `virtual_machine`. 

Proceed to allocate the number of `cpu` cores and amount of `memory` respectively in the `requests` block of `resources`.

What are virtual machines without ports?

Warning, exposing these ports allows all internet traffic to access the port. 
Ports are recorded in internal DNS SRV records for DNS-based service discovery.

To expose a `port`, set a `name`, port number, `protocol` (which must be either `TCP` or `UDP`) and `enable_implicit_network_policy` which tells whether or not the port is available from the public internet. This defaults to false.

It is recommended to create `user_data` with `cloud-init`. Provide at least a public key so you can SSH into the VM instances after they are started. See [Cloud-init](https://cloudinit.readthedocs.io/en/latest/topics/examples.html) docs for more information.

`liveness_probe` is used to determine the health of a workload instance. The workload instance restarts when the liveness probe begins failing.
`period_seconds` the amount of time in seconds you want to execute the probe.
`success_threshold` is number of successful probes you have before you mark the probe as successful.
`failure_threshold` is the number of failed checks you have before marking the check as failing.
`initial_delay_seconds` is the amount of time in seconds you wait before starting probe to give the application time to start up.

In the `http_get` block, set the `port`, `path` (which defaults to "/"), `scheme` (which defaults to HTTP and define the `http_headers`).

`readiness_probe` is the probe to determine when the instance is ready to serve traffic. Similar to `liveness probe`, except the `tcp_socket` parameter which opens a TCP connection to a specified `port` which in this case is `80`.

Make use of `volume_mount` to mount an additional volume into the virtual machine. 
However, note that a volume can not be mounted more than once to the same VM. 
You can mount a volume on multiple VMs in the same workload. 

This block accepts `slug` and `mount_path`.