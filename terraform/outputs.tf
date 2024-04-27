##--------------------------------------------------------------------------
##--Outputs section
##..Output data (VM IPv4 address and other dynamic data) from child Module
#
output "monitor_external_ip" {
  description = "Monitoring host external IPv4 address"
  value = module.monitor.monitor_wan_ip
  sensitive   = false
}

output "monitor_external_endpoint" {
  description = "Monitoring host external Endpoint/URL"
  value = module.monitor.monitor_endpoint
  sensitive   = false
}

output "k8s_masters_ip_external" {
  description = "k8s Master nodes external IPv4 address"
  value = module.cluster[*].k8s_masters_wan_ip
  sensitive   = false
}

output "k8s_workers_ip_external" {
  description = "k8s Worker nodes external IPv4 address"
  value = module.cluster[*].k8s_workers_wan_ip
  sensitive   = false
}



##=EXAMPLE_OUTPUTS:
##
##    Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
##
##    Outputs:
##
##    gateway_external_endpoint = "https://srv.dotspace.ru"
##    gateway_external_ip = "158.160.80.214"
##    k8s_masters_ip_external = [
##      [
##        "158.160.4.83",
##      ],
##    ]
##    k8s_workers_ip_external = [
##      [
##        "158.160.29.135",
##      ],
##    ]
##
