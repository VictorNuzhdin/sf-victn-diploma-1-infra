variable "k8s_count_masters" {
  description = "(required) k8s Cluster: Number of Master nodes"
  type        = number
  default     = 1
  sensitive   = false
}

variable "k8s_vm_master_name" {
  description = "(required) k8s Cluster: k8s Master node name prefix"
  type        = string
  default     = "k8s-manager"
  sensitive   = false
}

variable "k8s_vm_master_hostname" {
  description = "(required) k8s Cluster: k8s Master node hostname prefix"
  type        = string
  default     = "k8s-manager"
  sensitive   = false
}

variable "k8s_vm_master_platform" {
  description = "(required) k8s Cluster: k8s Master node platform ID/Name"
  type        = string
  default     = "standard-v2"
  sensitive   = false
}

variable "k8s_vm_master_cores" {
  description = "(required) k8s Cluster: k8s Master CPU cores"
  type        = number
  default     = 2
  sensitive = false
}

variable "k8s_vm_master_core_fract" {
  description = "(required) k8s Cluster: k8s Master CPU fraction (%)"
  type        = number
  default     = 5
  sensitive   = false
}

variable "k8s_vm_master_memory" {
  description = "(required) k8s Cluster: k8s Master RAM size, GiB"
  type        = number
  default     = 2
  sensitive   = false
}

variable "k8s_vm_master_isMayBeDisabled" {
  description = "(required) k8s Cluster: Should the k8s Master node shutdowned due cloud maintenance jobs?"
  type        = bool
  default     = true
  sensitive   = false
}

variable "k8s_vm_master_isConsoleEnabled" {
  description = "(required) k8s Cluster: Should the web console be enabled?"
  type        = number
  default     = 0
  sensitive   = false
}

variable "k8s_vm_master_boot_image_id" {
  description = "(required) k8s Cluster: k8s Master VM boot image ID from Yandex.Cloud Marketplace"
  type        = string
  default     = ""
  sensitive   = false
}

variable "k8s_vm_master_boot_image_descr" {
  description = "(optional) k8s Cluster: k8s Master VM boot image ID Description"
  type        = string
  default     = ""
  sensitive   = false
}

variable "k8s_vm_master_boot_disk_type" {
  description = "(required) k8s Cluster: k8s Master VM boot disk drive type"
  type        = string
  default     = ""
  sensitive   = false
}

variable "k8s_vm_master_boot_disk_size_gb" {
  description = "(required) k8s Cluster: k8s Master VM boot disk size, GiB"
  type        = number
  default     = 10
  sensitive   = false
}

variable "k8s_vm_master_net_ipv4_address" {
  description = "(required) k8s Cluster: k8s Master IPv4 address for LAN interface"
  type        = string
  sensitive   = false
}

variable "k8s_vm_master_net_isNat" {
  description = "(required) k8s Cluster: k8s Master is NAT enabled for LAN interface"
  type        = bool
  default     = true
  sensitive   = false
}
