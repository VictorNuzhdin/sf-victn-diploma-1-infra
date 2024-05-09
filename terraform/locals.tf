##--------------------------------------------------------------------------
##--Local variables section
#
locals {

  ##--COMMON
  ##..ssh connection params
  vm_default_username          = "ubuntu"                # yandex cloud Ubuntu image default username
  vm_custom_username           = "devops"
  #
  ssh_keys_path                 = "~/.ssh/"              # "/home/devops/.ssh"
  ssh_pubkey_path              = "~/.ssh/id_ed25519.pub" # "/home/devops/.ssh/id_ed25519.pub"
  ssh_privkey_path             = "~/.ssh/id_ed25519"     # "/home/devops/.ssh/id_ed25519"

  ##..cloud params
  iam_token                    = var.yc_token
  cloud_id                     = var.yc_cloud_id
  folder_id                    = var.yc_folder_id
  access_zone                  = "ru-central1-b"

  ##..vm network params: prod
  net_name                     = "k8s-net"
  net_sub1_name                = "k8s-net-sub1"
  net_sub1_cidr                = ["10.0.10.0/24"]

  ##..vm counter
  count_master_vms             = 1                        # кол-во создаваемых K8S Master/ControlPlane Нод/ВМ
  count_worker_vms             = 1                        # кол-во создаваемых K8S Worker Нод/ВМ


  ##--K8S_CLUSTER_MONITORING
  ##..k8s Gateway VM params
  vm_monitor_name              = "k8s-monitor"
  vm_monitor_hostname          = "srv"                   # СЕТЕВОЕ_ИМЯ_ПО_ЗАДАНИЮ
  #
  vm_monitor_platform          = "standard-v2"
  vm_monitor_cores             = 2
  vm_monitor_ram_gb            = 2
  vm_monitor_core_fract        = 5
  vm_monitor_isMayBeDisabled   = true                    # true|false
  vm_monitor_isConsoleEnabled  = 0                       # 0:disabled|1:enabled
  #
  vm_monitor_boot_image_id     = "fd87j6d92jlrbjqbl32q"  # OS Image id (family_id: ubuntu-2204-lts, last_update: 2024-05-06, https://cloud.yandex.ru/ru/marketplace/products/yc/ubuntu-22-04-lts)
  vm_monitor_boot_image_descr  = "Ubuntu 22.04 LTS"      # boot-disk description (optional)
  vm_monitor_boot_disk_type    = "network-hdd"           # boot disk type (network-hdd | network-ssd)
  vm_monitor_boot_disk_size_gb = 20                      # boot disk size, GiB (not less then 8GiB for "Ubuntu 22.04")
  #
  vm_monitor_net_ipv4_address  = "10.0.10.254"           # Monitor Host LAN IPv4address: prod
  vm_monitor_net_isNat         = true


  ##--K8S_CLUSTER_MASTER_NODES                           # K8S Master Nodes / Control Plane Nodes
  ##..k8s Master VMs params
  vm_master_name_prefix        = "k8s-master"
  vm_master_hostname_prefix    = "master"                # СЕТЕВОЕ_ИМЯ_ПО_ЗАДАНИЮ
  #
  vm_master_platform           = "standard-v2"
  vm_master_cores              = 2
  vm_master_ram_gb             = 4                       # 4GB RAM for "minikube" k8s Cluster
  vm_master_core_fract         = 5
  vm_master_isMayBeDisabled    = true                    # true|false
  vm_master_isConsoleEnabled   = 0                       # 0:disabled|1:enabled
  #
  vm_master_boot_image_id      = "fd87j6d92jlrbjqbl32q"  # OS Image id (family_id: ubuntu-2204-lts, last_update: 2024-05-06, https://cloud.yandex.ru/ru/marketplace/products/yc/ubuntu-22-04-lts)
  vm_master_boot_image_descr   = "Ubuntu 22.04 LTS"      # boot-disk description (optional)
  vm_master_boot_disk_type     = "network-hdd"           # boot disk type (network-hdd | network-ssd)
  vm_master_boot_disk_size_gb  = 40                      # boot disk size, GiB (not less then 8GiB for "Ubuntu 22.04") - 40GB for "minikube" k8s Cluster
  #
  vm_master_net_ipv4_address   = "10.0.10.10"            # Master node FIRST IPv4 address
  vm_master_net_isNat          = true


  ##--K8S_CLUSTER_WORKERS                                # Swarm Worker Nodes == K8S Worker Nodes
  ##..k8s Worker VMs params
  vm_worker_name_prefix        = "k8s-worker"
  vm_worker_hostname_prefix    = "app"                   # СЕТЕВОЕ_ИМЯ_ПО_ЗАДАНИЮ
  #
  vm_worker_platform           = "standard-v2"
  vm_worker_cores              = 2
  vm_worker_ram_gb             = 2
  vm_worker_core_fract         = 5
  vm_worker_isMayBeDisabled    = true                    # true|false
  vm_worker_isConsoleEnabled   = 0                       # 0:disabled|1:enabled
  #
  vm_worker_boot_image_id      = "fd87j6d92jlrbjqbl32q"  # OS Image id (family_id: ubuntu-2204-lts, last_update: 2024-05-06, https://cloud.yandex.ru/ru/marketplace/products/yc/ubuntu-22-04-lts)
  vm_worker_boot_image_descr   = "Ubuntu 22.04 LTS"      # boot-disk description (optional)
  vm_worker_boot_disk_type     = "network-hdd"           # boot disk type (network-hdd | network-ssd)
  vm_worker_boot_disk_size_gb  = 20                      # boot disk size, GiB (not less then 8GiB for "Ubuntu 22.04")
  #
  vm_worker_net_ipv4_address   = "10.0.10.20"            # Worker node FIRST IPv4 address
  vm_worker_net_isNat          = true

}
