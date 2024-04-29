##--------------------------------------------------------------------------
##--Modules Section
#
##..k8s network
module "network" {
  source                           = "./modules/network"
  yc_token                         = local.iam_token
  yc_cloud_id                      = local.cloud_id                     # get Cloud ID from local variable and use in this (root) Module
  yc_folder_id                     = local.folder_id
  yc_access_zone                   = local.access_zone
  #
  k8s_net_name                     = local.net_name                     # "k8s-net"
  k8s_net_subnet1_name             = local.net_sub1_name                # "k8s-net-sub1"
  k8s_net_subnet1_ipv4_cidr        = local.net_sub1_cidr                # ["10.0.10.0/24"]
}


##..k8s Monitoring (srv) :: K8s Monitoring, CI/CD Tasks and App gateway for "OnePoint" access to internal Services
module "monitor" {
  # BASE
  source                           = "./modules/monitor"
  #
  # COMMON
  yc_token                         = local.iam_token
  ssh_secrets                      = { user_name = local.vm_default_username, user_keys = local.ssh_keys_path, user_key_priv = local.ssh_privkey_path, user_key_pub = local.ssh_pubkey_path }
  yc_cloud_id                      = local.cloud_id
  yc_folder_id                     = local.folder_id
  yc_access_zone                   = local.access_zone
  monitor_vm_access_zone           = local.access_zone
  monitor_vm_subnet_id             = module.network.k8s_subnet1_id      # prod  version: get Subnet ID from "networks" Module and send to "nonitor" Module
  #

  # MONITOR/ING HOST
  monitor_vm_name                  = local.vm_monitor_name              # "k8s-monitor"
  monitor_vm_hostname              = local.vm_monitor_hostname          # "srv"
  #
  monitor_vm_platform              = local.vm_monitor_platform          # "standard-v2"
  #
  monitor_vm_cores                 = local.vm_monitor_cores             # 2
  monitor_vm_core_fract            = local.vm_monitor_core_fract        # 5
  monitor_vm_memory                = local.vm_monitor_ram_gb            # 2 
  #
  monitor_vm_isMayBeDisabled       = local.vm_monitor_isMayBeDisabled   # true
  monitor_vm_isConsoleEnabled      = local.vm_monitor_isConsoleEnabled  # 0
  #
  monitor_vm_boot_image_id         = local.vm_monitor_boot_image_id     # "fd82vchjp2kdjiuam29k"
  monitor_vm_boot_image_descr      = local.vm_monitor_boot_image_descr  # "Ubuntu 22.04 LTS"
  monitor_vm_boot_disk_type        = local.vm_monitor_boot_disk_type    # "network-hdd"
  monitor_vm_boot_disk_size_gb     = local.vm_monitor_boot_disk_size_gb # 20
  #
  monitor_vm_net_ipv4_address      = local.vm_monitor_net_ipv4_address  # "10.0.10.254"
  monitor_vm_net_isNat             = local.vm_monitor_net_isNat         # true

}


##..k8s instances
module "cluster" {
  # BASE
  source                           = "./modules/cluster"                # Module relative Path
  k8s_count_masters                = local.count_master_vms             # how many k8s Master nodes need to be created (default: 1)
  k8s_count_workers                = local.count_worker_vms             # how many k8s Worker nodes need to be created (default: 1)
  #
  # COMMON
  yc_token                         = local.iam_token
  ssh_secrets                      = { user_name = local.vm_default_username, user_key_priv = local.ssh_privkey_path, user_key_pub = local.ssh_pubkey_path }
  #                                #   user_name = "ubuntu", user_key_priv = "~/.ssh/id_ed25519", user_key_pub = "~/.ssh/id_ed25519.pub"
  #
  yc_cloud_id                      = local.cloud_id                     # get Cloud ID from local variables and send to "instances" Module
  yc_folder_id                     = local.folder_id
  yc_access_zone                   = local.access_zone
  k8s_vm_access_zone               = local.access_zone                  # "ru-central1-b"
  k8s_subnet_id                    = module.network.k8s_subnet1_id      # get Subnet ID from "networks" Module and send to "instances" Module
  #

  # MANAGERS
  k8s_vm_master_name              = local.vm_master_name_prefix         # "k8s-master"
  k8s_vm_master_hostname          = local.vm_master_hostname_prefix     # "k8s-master"
  #
  k8s_vm_master_platform          = local.vm_master_platform            # "standard-v2"
  #
  k8s_vm_master_cores             = local.vm_master_cores               # 2
  k8s_vm_master_core_fract        = local.vm_master_core_fract          # 5
  k8s_vm_master_memory            = local.vm_master_ram_gb              # 2 
  #
  k8s_vm_master_isMayBeDisabled   = local.vm_master_isMayBeDisabled     # true|false
  k8s_vm_master_isConsoleEnabled  = local.vm_master_isConsoleEnabled    # 0|1
  #
  k8s_vm_master_boot_image_id     = local.vm_master_boot_image_id       # "fd82vchjp2kdjiuam29k"
  k8s_vm_master_boot_image_descr  = local.vm_master_boot_image_descr    # "Ubuntu 22.04 LTS"
  k8s_vm_master_boot_disk_type    = local.vm_master_boot_disk_type      # "network-hdd"
  k8s_vm_master_boot_disk_size_gb = local.vm_master_boot_disk_size_gb   # 20
  #
  k8s_vm_master_net_ipv4_address  = local.vm_master_net_ipv4_address    # "10.0.10.10"
  k8s_vm_master_net_isNat         = local.vm_master_net_isNat           # true|false
  #

  # WORKERS
  k8s_vm_worker_name               = local.vm_worker_name_prefix        # "k8s-worker"
  k8s_vm_worker_hostname           = local.vm_worker_hostname_prefix    # "k8s-worker"
  #
  k8s_vm_worker_platform           = local.vm_worker_platform           # "standard-v2"
  #
  k8s_vm_worker_cores              = local.vm_worker_cores              # 2
  k8s_vm_worker_core_fract         = local.vm_worker_core_fract         # 5
  k8s_vm_worker_memory             = local.vm_worker_ram_gb             # 2 
  #
  k8s_vm_worker_isMayBeDisabled    = local.vm_worker_isMayBeDisabled    # true|false
  k8s_vm_worker_isConsoleEnabled   = local.vm_worker_isConsoleEnabled   # 0|1
  #
  k8s_vm_worker_boot_image_id      = local.vm_worker_boot_image_id      # "fd82vchjp2kdjiuam29k"
  k8s_vm_worker_boot_image_descr   = local.vm_worker_boot_image_descr   # "Ubuntu 22.04 LTS"
  k8s_vm_worker_boot_disk_type     = local.vm_worker_boot_disk_type     # "network-hdd"
  k8s_vm_worker_boot_disk_size_gb  = local.vm_worker_boot_disk_size_gb  # 20
  #
  k8s_vm_worker_net_ipv4_address   = local.vm_worker_net_ipv4_address   # "10.0.10.20"
  k8s_vm_worker_net_isNat          = local.vm_worker_net_isNat          # true|false

}
