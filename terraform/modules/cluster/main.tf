##--------------------------------------------------------------------------
##--VMs section: k8s Master Nodes
#
resource "yandex_compute_instance" "k8s-master" {
  #                                                             # EXAMPLES
  count       = var.k8s_count_masters                           # 1..N
  #
  name        = "${var.k8s_vm_master_name}-${count.index}"      # "k8s-master-0"
  hostname    = "${var.k8s_vm_master_hostname}${count.index}"   # "master0"
  platform_id = var.k8s_vm_master_platform                      # "standard-v2"
  zone        = var.yc_access_zone                              # "ru-central1-b"

  ##..VM virtual CPU and RAM configuration
  resources {
    cores         = var.k8s_vm_master_cores                     # 2
    core_fraction = var.k8s_vm_master_core_fract                # 5
    memory        = var.k8s_vm_master_memory                    # 2
  }

  ##..VM Cloud maintenance configuration
  scheduling_policy {
    preemptible = var.k8s_vm_master_isMayBeDisabled             # true|false
  }

  ##..VM boot-disk configuration (includes OS image from Yandex.Cloud Marketplace)
  boot_disk {
    initialize_params {
      image_id    = var.k8s_vm_master_boot_image_id             # "fd82vchjp2kdjiuam29k"
      type        = var.k8s_vm_master_boot_disk_type            # "network-hdd"
      size        = var.k8s_vm_master_boot_disk_size_gb         # 20
      description = var.k8s_vm_master_boot_image_descr          # "Ubuntu 22.04 LTS" # boot-disk description (optional)
    }
  }

  ##..Network interface configuration
  network_interface {
    #..using subnet from "networks" module
    subnet_id	  = var.k8s_subnet_id                             # "fd8dlvgiatiqd8tt2qke"
    nat         = var.k8s_vm_master_net_isNat                   # true|false
    #
    #ip_address = "10.0.10.10"
    #
    ip_address =  join(".", [
                    split(".", var.k8s_vm_master_net_ipv4_address)[0],
                    split(".", var.k8s_vm_master_net_ipv4_address)[1],
                    split(".", var.k8s_vm_master_net_ipv4_address)[2],
                    split(".", var.k8s_vm_master_net_ipv4_address)[3] + count.index
                  ])
  }

  ##..VM metadata configuration (including user data required for ssh connection)
  metadata = {
    serial-port-enable = var.k8s_vm_master_isConsoleEnabled  # 0
    #
    #..user management: basics: adds public ssh-key to default user
    #ssh-keys = "${local.vm_default_login}:${file("${local.ssh_pubkey_path}")}"
    #
    ssh-keys = "${var.ssh_secrets.user_name}:${file(var.ssh_secrets.user_key_pub)}"  # ubuntu:ssh-ed25519 AAAA..Wjbt devops@dotspace.ru
    #
    #..user management: advanced: using Cloud-Init OS feature
    #user-data = "${file("configs/cloud-init.yaml")}"
  }

} ## << resource "yandex_compute_instance" "k8s-master"


##--------------------------------------------------------------------------
##--VMs section: k8s Worker Nodes
#
resource "yandex_compute_instance" "k8s-worker" {
  #
  count           = var.k8s_count_workers
  #
  name            = "${var.k8s_vm_worker_name}-${count.index}"       # "k8s-worker-0"
  hostname        = "${var.k8s_vm_worker_hostname}${count.index}"    # "app0"
  platform_id     = var.k8s_vm_worker_platform
  zone            = var.yc_access_zone

  resources {
    cores         = var.k8s_vm_worker_cores
    core_fraction = var.k8s_vm_worker_core_fract
    memory        = var.k8s_vm_worker_memory
  }

  scheduling_policy {
    preemptible   = var.k8s_vm_worker_isMayBeDisabled
  }

  boot_disk {
    initialize_params {
      image_id    = var.k8s_vm_worker_boot_image_id
      type        = var.k8s_vm_worker_boot_disk_type
      size        = var.k8s_vm_worker_boot_disk_size_gb
      description = var.k8s_vm_worker_boot_image_descr
    }
  }

  network_interface {
    subnet_id	    = var.k8s_subnet_id
    nat           = var.k8s_vm_worker_net_isNat
    ip_address    = join(".", [
                      split(".", var.k8s_vm_worker_net_ipv4_address)[0],
                      split(".", var.k8s_vm_worker_net_ipv4_address)[1],
                      split(".", var.k8s_vm_worker_net_ipv4_address)[2],
                      split(".", var.k8s_vm_worker_net_ipv4_address)[3] + count.index
                    ])
  }
                    # "10.0.10.20", "10.0.10.21", "10.0.10.22" ..

  metadata = {
    serial-port-enable = var.k8s_vm_worker_isConsoleEnabled
    ssh-keys = "${var.ssh_secrets.user_name}:${file(var.ssh_secrets.user_key_pub)}"
  }

} ## << resource "yandex_compute_instance" "k8s-worker"
