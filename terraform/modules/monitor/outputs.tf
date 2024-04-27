##--Collecting/Exporting Output data (VM ipv4 addresses and other dynamic data) from current Module level to Root Module
#
output "monitor_wan_ip" {
  value = yandex_compute_instance.monitor.network_interface.0.nat_ip_address
}

output "monitor_endpoint" {
  value = "https://srv.dotspace.ru"
}
