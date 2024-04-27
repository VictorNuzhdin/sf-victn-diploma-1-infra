##--ON_K8S_MASTERS: do test action
resource "null_resource" "k8s-masters-provisioner" {
  # 
  count = var.k8s_count_masters
  depends_on = [yandex_compute_instance.k8s-master]
  #
  #..connect to remote Master Node via ssh
  connection {
    user        = var.ssh_secrets.user_name
    private_key = file(var.ssh_secrets.user_key_priv)
    host        = yandex_compute_instance.k8s-master[count.index].network_interface.0.nat_ip_address
  }
  #
  #..executes cmd on remote Master node: just log some message
  provisioner "remote-exec" {
    inline = [
      #..create_logs_dir
      "sudo mkdir -p /home/$USER/_logs; sudo chown -R $USER:$USER /home/$USER/_logs",
      #
      #..set_local_timezone (+06)
      "sudo timedatectl set-timezone Asia/Omsk",
      #
      #..log_message
      "echo \"$(date +'%Y-%m-%dT%H:%M:%S') :: MASTER_VM_CREATED\" > /home/$USER/_logs/deploy.log",
      "echo \"$(date +'%Y-%m-%dT%H:%M:%S') :: $(timedatectl | grep Local | awk '{$1=$1;print}')\" >> /home/$USER/_logs/deploy.log"
    ]
  }

}

##--ON_K8S_WORKERS: do test action
resource "null_resource" "k8s-workers-provisioner" {
  # 
  count = var.k8s_count_workers
  depends_on = [yandex_compute_instance.k8s-worker, null_resource.k8s-masters-provisioner]
  #
  connection {
    user        = var.ssh_secrets.user_name
    private_key = file(var.ssh_secrets.user_key_priv)
    host        = yandex_compute_instance.k8s-worker[count.index].network_interface.0.nat_ip_address
  }

  #..executes cmd on remote Worker node: just log some message
  provisioner "remote-exec" {
    inline = [
      #..create_logs_dir
      "sudo mkdir -p /home/$USER/_logs; sudo chown -R $USER:$USER /home/$USER/_logs",
      #
      #..set_local_timezone (+06)
      "sudo timedatectl set-timezone Asia/Omsk",
      #
      #..log_message
      "echo \"$(date +'%Y-%m-%dT%H:%M:%S') :: WORKER_VM_CREATED\" > /home/$USER/_logs/deploy.log",
      "echo \"$(date +'%Y-%m-%dT%H:%M:%S') :: $(timedatectl | grep Local | awk '{$1=$1;print}')\" >> /home/$USER/_logs/deploy.log"
    ]
  }
}
