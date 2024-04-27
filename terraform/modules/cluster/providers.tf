##--------------------------------------------------------------------------
##--Terraform Providers section
#
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.113"
    }
  }
  required_version = ">= 1.7.3"
}

##--Yandex Cloud Provider Authorization section
provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_access_zone
}
