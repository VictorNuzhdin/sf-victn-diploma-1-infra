##--ON_MONITOR: PREPARE HOST
resource "null_resource" "monitor-provisioner" {
  # 
  depends_on = [yandex_compute_instance.monitor]
  #
  #..connect to remote Monitoring host via ssh
  connection {
    user        = var.ssh_secrets.user_name                                           # "ubuntu"
    private_key = file(var.ssh_secrets.user_key_priv)                                 # "~/.ssh/id_ed25519"
    host        = yandex_compute_instance.monitor.network_interface.0.nat_ip_address
    type        = "ssh"
    agent       = false
    timeout     = "3m"
  }
  #
  ##..copy files #1
  ##  copy ssh keys directory from local Host to remote VM for future NEW user configuration
  provisioner "file" {
    source      = var.ssh_secrets.user_keys                                           # "~/.ssh/"
    destination = "/tmp"
  }
  
  ##..copy files #2
  ##  copy shell scripts and configurations from local Host to remote VM
  provisioner "file" {
    source      = "setup/monitor"
    destination = "/home/ubuntu/setup/"
  }

  ##..execute cmd list (one cmd per one ssh connection)
  provisioner "remote-exec" {
    inline = [
      #..create_logs_dir
      "sudo mkdir -p /home/$USER/_logs; sudo chown -R $USER:$USER /home/$USER/_logs",
      #
      #..set_local_timezone (+06)
      "sudo timedatectl set-timezone Asia/Omsk",
      #
      #..execute_main_setup_script
      "chmod +x /home/ubuntu/setup/configure_00-main.sh",
      "/home/ubuntu/setup/configure_00-main.sh",
      #
      #..log_message
      "echo \"$(date +'%Y-%m-%dT%H:%M:%S') :: MONITOR_VM_CREATED\" > /home/$USER/_logs/deploy.log",
      "echo \"$(date +'%Y-%m-%dT%H:%M:%S') :: $(timedatectl | grep Local | awk '{$1=$1;print}')\" >> /home/$USER/_logs/deploy.log"
    ]
  }

}
