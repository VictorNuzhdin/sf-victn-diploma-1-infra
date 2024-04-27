variable "ssh_secrets" {
  description     = "Credentials for ssh connections to instances"
  type            = object({
    user_name     = string
    user_keys     = string
    user_key_priv = string
    user_key_pub  = string
  })
  default         = {
    user_name     = "ubuntu"
    user_keys     = "~/.ssh"
    user_key_priv = "~/.ssh/id_ed25519"
    user_key_pub  = "~/.ssh/id_ed25519.pub"
  }
}

variable "yc_token" {
  description = "(required) Yandex.Cloud: IAM auth token"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "(required) Yandex.Cloud: Cloud ID"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "(required) Yandex.Cloud: Folder ID"
  type        = string
  sensitive   = true
}

variable "yc_access_zone" {
  description = "(required) Yandex.Cloud: Acess Zone Name"
  type        = string
  default     = "ru-central1-b"
  sensitive   = true
}

variable "monitor_vm_access_zone" {
  description = "(required) Gateway: VM Access Zone"
  type        = string
  default     = "ru-central1-b"
  sensitive   = false
}

variable "monitor_vm_subnet_id" {
  description = "(required) Gateway: VM Subnet ID"
  type        = string
  default     = ""
  sensitive   = false
}

variable "monitor_vm_name" {
  description = "(required) Gateway: VM display name"
  type        = string
  default     = "gw"
  sensitive   = false
}

variable "monitor_vm_hostname" {
  description = "(required) Gateway: VM hostname"
  type        = string
  default     = "gw"
  sensitive   = false
}

variable "monitor_vm_platform" {
  description = "(required) Gateway: VM platform ID/Name"
  type        = string
  default     = "standard-v2"
  sensitive   = false
}

variable "monitor_vm_cores" {
  description = "(required) Gateway: VM CPU cores"
  type        = number
  default     = 2
  sensitive = false
}

variable "monitor_vm_core_fract" {
  description = "(required) Gateway: VM CPU fraction (%)"
  type        = number
  default     = 5
  sensitive   = false
}

variable "monitor_vm_memory" {
  description = "(required) Gateway: VM RAM size, GiB"
  type        = number
  default     = 2
  sensitive   = false
}

variable "monitor_vm_isMayBeDisabled" {
  description = "(required) Gateway: Should the VM shutdowned due cloud maintenance jobs?"
  type        = bool
  default     = true
  sensitive   = false
}

variable "monitor_vm_isConsoleEnabled" {
  description = "(required) Gateway: Should the web console be enabled?"
  type        = number
  default     = 0
  sensitive   = false
}

variable "monitor_vm_boot_image_id" {
  description = "(required) Gateway: VM boot image ID from Yandex.Cloud Marketplace"
  type        = string
  default     = ""
  sensitive   = false
}

variable "monitor_vm_boot_image_descr" {
  description = "(optional) Gateway: VM boot image ID Description"
  type        = string
  default     = ""
  sensitive   = false
}

variable "monitor_vm_boot_disk_type" {
  description = "(required) Gateway: VM boot disk drive type"
  type        = string
  default     = ""
  sensitive   = false
}

variable "monitor_vm_boot_disk_size_gb" {
  description = "(required) Gateway: VM boot disk size, GiB"
  type        = number
  default     = 10
  sensitive   = false
}

variable "monitor_vm_net_ipv4_address" {
  description = "(required) Gateway: IPv4 address for LAN interface"
  type        = string
  sensitive   = false
}

variable "monitor_vm_net_isNat" {
  description = "(required) Gateway: Is NAT enabled for LAN interface"
  type        = bool
  default     = true
  sensitive   = false
}
