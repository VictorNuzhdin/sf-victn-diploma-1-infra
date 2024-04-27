variable "k8s_count_workers" {
  description = "(required) k8s Cluster: Number of Worker nodes"
  type        = number
  default     = 1
  sensitive   = false
}

variable "k8s_vm_worker_name" {
  description = "(required) k8s Cluster: k8s Worker node name prefix"
  type        = string
  default     = "k8s-worker"
  sensitive   = false
}

variable "k8s_vm_worker_hostname" {
  description = "(required) k8s Cluster: k8s Worker node hostname prefix"
  type        = string
  default     = "k8s-worker"
  sensitive   = false
}

variable "k8s_vm_worker_platform" {
  description = "(required) k8s Cluster: k8s Worker node platform ID/Name"
  type        = string
  default     = "standard-v2"
  sensitive   = false
}

variable "k8s_vm_worker_cores" {
  description = "(required) k8s Cluster: k8s Worker CPU cores"
  type        = number
  default     = 2
  sensitive = false
}

variable "k8s_vm_worker_core_fract" {
  description = "(required) k8s Cluster: k8s Worker CPU fraction (%)"
  type        = number
  default     = 5
  sensitive   = false
}

variable "k8s_vm_worker_memory" {
  description = "(required) k8s Cluster: k8s Worker RAM size, GiB"
  type        = number
  default     = 2
  sensitive   = false
}

variable "k8s_vm_worker_isMayBeDisabled" {
  description = "(required) k8s Cluster: Should the k8s Worker node shutdowned due cloud maintenance jobs?"
  type        = bool
  default     = true
  sensitive   = false
}

variable "k8s_vm_worker_isConsoleEnabled" {
  description = "(required) k8s Cluster: Should the web console be enabled?"
  type        = number
  default     = 0
  sensitive   = false
}

variable "k8s_vm_worker_boot_image_id" {
  description = "(required) k8s Cluster: k8s Worker VM boot image ID from Yandex.Cloud Marketplace"
  type        = string
  default     = ""
  sensitive   = false
}

variable "k8s_vm_worker_boot_image_descr" {
  description = "(optional) k8s Cluster: k8s Worker VM boot image ID Description"
  type        = string
  default     = ""
  sensitive   = false
}

variable "k8s_vm_worker_boot_disk_type" {
  description = "(required) k8s Cluster: k8s Worker VM boot disk drive type"
  type        = string
  default     = ""
  sensitive   = false
}

variable "k8s_vm_worker_boot_disk_size_gb" {
  description = "(required) k8s Cluster: k8s Worker VM boot disk size, GiB"
  type        = number
  default     = 10
  sensitive   = false
}

variable "k8s_vm_worker_net_ipv4_address" {
  description = "(required) k8s Cluster: k8s Worker IPv4 address for LAN interface"
  type        = string
  sensitive   = false
}

variable "k8s_vm_worker_net_isNat" {
  description = "(required) k8s Cluster: k8s Worker is NAT enabled for LAN interface"
  type        = bool
  default     = true
  sensitive   = false
}
