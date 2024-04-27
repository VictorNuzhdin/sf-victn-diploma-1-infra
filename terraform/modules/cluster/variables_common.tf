variable "ssh_secrets" {
  description     = "Credentials for ssh connections to instances"
  type            = object({
    user_name     = string
    user_key_priv = string
    user_key_pub  = string
  })
  default         = {
    user_name     = "ubuntu"
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

variable "k8s_subnet_id" {
  description = "(required) k8s Cluster: Subnet ID"
  type        = string
  default     = ""
  sensitive   = false
}

variable "k8s_vm_access_zone" {
  description = "(required) k8s Cluster: VMs Access Zone"
  type        = string
  default     = "ru-central1-b"
  sensitive   = false
}

variable "k8s_vm_platform_id" {
  description = "(required) k8s Cluster: VMs platform ID/Name"
  type        = string
  default     = "standard-v2"
  sensitive   = false
}
