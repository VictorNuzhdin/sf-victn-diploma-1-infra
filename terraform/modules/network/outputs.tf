##..Export variables to global scope (to root module level)
#
output "k8s_network_id" {
  value       = yandex_vpc_network.k8s-net.id
  description = "k8s network ID"
  sensitive   = false
}

output "k8s_subnet1_id" {
  value       = yandex_vpc_subnet.k8s-subnet1.id
  description = "k8s subnet ID"
  sensitive   = false
}
