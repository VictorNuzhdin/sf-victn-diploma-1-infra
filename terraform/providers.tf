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
  token     = local.iam_token
  cloud_id  = local.cloud_id
  folder_id = local.folder_id
  zone      = local.access_zone
}
