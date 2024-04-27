variable "yc_token" {
  description = "(required) Yandex.Cloud IAM auth token"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "(required) Yandex.Cloud Cloud ID"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "(required) Yandex.Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "yc_access_zone" {
  description = "(required) Yandex.Cloud Acess Zone Name"
  type        = string
  default     = "ru-central1-b"
  sensitive   = false
}

variable "k8s_net_name" {
  description = "(required) k8s Cluster: k8s Network Name"
  type        = string
  default     = "k8s-net"
  sensitive   = false
}

variable "k8s_net_subnet1_name" {
  description = "(required) k8s Cluster: k8s SubNetwork 1 Name"
  type        = string
  default     = "k8s-net-sub1"
  sensitive   = false
}

variable "k8s_net_subnet1_ipv4_cidr" {
  description = "(required) k8s Cluster: k8s SubNetwork 1 IPv4 Adress Range"
  type        = list
  default     = ["10.0.10.0/24"] 
  sensitive   = false
}
