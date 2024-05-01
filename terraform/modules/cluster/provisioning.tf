##--ON_K8S_MASTERS: setup kubernetes
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
  #..creates kebernetes setup dir on remote host
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ubuntu/setup_kuber; sudo chown -R $USER:$USER /home/ubuntu/setup_kuber"
    ]
  }
  #
  #..copies kubernetes setup shell scripts from local host to remote host
  provisioner "file" {
    #..copy all files
    #source      = "setup/cluster/"
    #destination = "/home/ubuntu/setup_kuber"
    #..copy single file
    source      = "setup/cluster/kuber_setup_master.sh"
    destination = "/home/ubuntu/setup_kuber/kuber_setup_master.sh"
  }
  #
  #..executes shell commands on remote Master Node
  provisioner "remote-exec" {
    inline = [
      #--BEGININIG_KUBERNETES_SETUP
      #..install common tools & init cluster
      "chmod +x setup_kuber/kuber_setup_master.sh; setup_kuber/kuber_setup_master.sh",
    ]
  }
}


##--ON_LOCAL_DEV_HOST: create join script (with token) for joining Workers to the Kubernetes Cluster (join.sh)
resource "null_resource" "k8s-masters-make-join-provisioner" {
  #
  count = var.k8s_count_masters
  depends_on = [yandex_compute_instance.k8s-master, null_resource.k8s-masters-provisioner]
  #
  #..connect to remote Master Node via ssh
  connection {
    user        = var.ssh_secrets.user_name
    private_key = file(var.ssh_secrets.user_key_priv)
    host        = yandex_compute_instance.k8s-master[count.index].network_interface.0.nat_ip_address
  }

  #..creates join script locally for joining Workers node to Kubernetes Cluster
  provisioner "local-exec" {
    command = "sleep 120; JOIN_CMD=$(ssh -i ${var.ssh_secrets.user_key_priv} -o StrictHostKeyChecking=no ${var.ssh_secrets.user_name}@${yandex_compute_instance.k8s-master[0].network_interface.0.nat_ip_address} sudo kubeadm token create --description CustomInfinityToken --ttl 0 --print-join-command);echo '#!/usr/bin/env bash' > join.sh;echo \"sudo $JOIN_CMD\" >> join.sh; echo \"exit 0\" >> join.sh"
  }

}


##--ON_K8S_WORKERS: setup kubernetes
resource "null_resource" "k8s-workers-provisioner" {
  #
  count = var.k8s_count_workers
  #depends_on = [yandex_compute_instance.k8s-worker, null_resource.k8s-masters-provisioner]
  depends_on = [yandex_compute_instance.k8s-worker, null_resource.k8s-masters-provisioner, null_resource.k8s-masters-make-join-provisioner]
  #
  connection {
    user        = var.ssh_secrets.user_name
    private_key = file(var.ssh_secrets.user_key_priv)
    host        = yandex_compute_instance.k8s-worker[count.index].network_interface.0.nat_ip_address
  }
  #
  #..creates kebernetes setup dir on remote host
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ubuntu/setup_kuber; sudo chown -R $USER:$USER /home/ubuntu/setup_kuber"
    ]
  }
  #..copies kubernetes setup shell scripts from local host to remote host
  provisioner "file" {
    source      = "setup/cluster/kuber_setup_worker.sh"
    destination = "/home/ubuntu/setup_kuber/kuber_setup_worker.sh"
  }
  #
  provisioner "file" {
    source      = "join.sh"
    destination = "/home/ubuntu/setup_kuber/join.sh"
  }
  #
  #..executes shell commands on remote Worker Node
  provisioner "remote-exec" {
    inline = [
      #--KUBERNETES_SETUP
      #..install common tools
      "chmod +x setup_kuber/kuber_setup_worker.sh; setup_kuber/kuber_setup_worker.sh",
      #..join worker to kubernetes cluster
      "chmod +x setup_kuber/join.sh; setup_kuber/join.sh",
    ]
  }
  #
  #..set worker node Role and Label to "worker" on remote Manager Node after join
  provisioner "local-exec" {
    command = "sleep 120; rm -f join.sh; ssh -i ${var.ssh_secrets.user_key_priv} -o StrictHostKeyChecking=no ${var.ssh_secrets.user_name}@${yandex_compute_instance.k8s-master[0].network_interface.0.nat_ip_address} kubectl label node app0 node-role.kubernetes.io/worker=worker && kubectl label node app0 role=worker"
    #
    #on_failure = fail      ## default
    on_failure = continue

  }

}
