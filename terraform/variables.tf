##--------------------------------------------------------------------------
##--Variables section
#
variable "my_ssh_credentials" {
  description = "Credentials for connect to instances via ssh"
  type        = object({
    user        = string
    private_key = string
    pub_key     = string
  })
  default       = {
    user        = "ubuntu"
    pub_key     = "~/.ssh/id_ed25519.pub"
    private_key = "~/.ssh/id_ed25519"
  }
}

variable "yc_token" {
  type        = string
  default     = ""
  description = "(required) Yandex Cloud IAM auth token"
  sensitive = true
}

variable "yc_token_ts" {
  type        = string
  default     = ""
  description = "(optional) Yandex Cloud IAM auth token last update Timestamp"
  sensitive = false
}

variable "yc_cloud_id" {
  type        = string
  default     = ""
  description = "(required) Sets Yandex Cloud Cloud ID"
  sensitive = true
}

variable "yc_folder_id" {
  type        = string
  default     = ""
  description = "(required) Sets Yandex Cloud Folder ID"
  sensitive = true
}
