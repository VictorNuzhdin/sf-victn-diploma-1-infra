##--Collecting/Exporting Output data (VM ipv4 addresses and other dynamic data) from current Module level to Root Module
#
output "k8s_masters_wan_ip" {
  value = yandex_compute_instance.k8s-master[*].network_interface.0.nat_ip_address
}

output "k8s_workers_wan_ip" {
  value = yandex_compute_instance.k8s-worker[*].network_interface.0.nat_ip_address
}
