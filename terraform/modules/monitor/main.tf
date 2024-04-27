##--------------------------------------------------------------------------
##--VMs section: K8S Monitoring on "srv" Host
#
resource "yandex_compute_instance" "monitor" {
  #
  name            = var.monitor_vm_name                 # "k8s-monitor"
  hostname        = var.monitor_vm_hostname             # "srv"
  platform_id     = var.monitor_vm_platform             # "standard-v2"
  zone            = var.yc_access_zone                  # "ru-central1-b"

  ##..VM virtual CPU and RAM configuration
  resources {
    cores         = var.monitor_vm_cores                # 2
    core_fraction = var.monitor_vm_core_fract           # 5
    memory        = var.monitor_vm_memory               # 2
  }

  ##..VM Cloud maintenance configuration
  scheduling_policy {
    preemptible   = var.monitor_vm_isMayBeDisabled      # true|false
  }

  ##..VM boot-disk configuration (includes OS image from Yandex.Cloud Marketplace)
  boot_disk {
    initialize_params {                                 # EXAMPLES
      image_id    = var.monitor_vm_boot_image_id        # "fd82vchjp2kdjiuam29k"
      type        = var.monitor_vm_boot_disk_type       # "network-hdd"
      size        = var.monitor_vm_boot_disk_size_gb    # 20
      description = var.monitor_vm_boot_image_descr     # "Ubuntu 22.04 LTS" # boot-disk description (optional)
    }
  }

  ##..Network interface configuration
  network_interface {
    #..using subnet from "network" module               # EXAMPLES
    subnet_id	    = var.monitor_vm_subnet_id            # "e2lbvjotvmelh1nslcrr"
    nat           = var.monitor_vm_net_isNat            # true|false
    ip_address    = var.monitor_vm_net_ipv4_address     # "10.129.0.254"

  }

  ##..VM metadata configuration (including user data required for ssh connection)
  metadata = {
    serial-port-enable = var.monitor_vm_isConsoleEnabled   # 0
    #
    #..user management: basics: adds public ssh-key to default user
    ssh-keys = "${var.ssh_secrets.user_name}:${file(var.ssh_secrets.user_key_pub)}"
    #           ubuntu:ssh-ed25519 AAAA..Wjbt devops@dotspace.ru
    #
    #..user management: advanced: using Cloud-Init OS feature
    #user-data = "${file("configs/cloud-init.yaml")}"
  }

} ## << resource "yandex_compute_instance" "monitor"
