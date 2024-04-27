##--------------------------------------------------------------------------
##--Network section: create NEW network and subnet(s)
#
resource "yandex_vpc_network" "k8s-net" {
  name = var.k8s_net_name                         # "k8s-net"
}

resource "yandex_vpc_subnet" "k8s-subnet1" {
  #zone          = "ru-central1-b"
  network_id     = yandex_vpc_network.k8s-net.id
  name           = var.k8s_net_subnet1_name       # "k8s-net-sub1"
  v4_cidr_blocks = var.k8s_net_subnet1_ipv4_cidr  # ["10.0.10.0/24"]
}

#resource "yandex_vpc_subnet" "k8s-subnet2" {
#  zone           = "ru-central1-b"
#  network_id     = yandex_vpc_network.k8s-net.id
#  name           = "k8s-net-sub2"
#  v4_cidr_blocks = ["10.0.20.0/24"]
#}
#
#resource "yandex_vpc_subnet" "k8s-subnet3" {
#  zone           = "ru-central1-b"
#  network_id     = yandex_vpc_network.k8s-net.id
#  name           = "k8s-net-sub3"
#  v4_cidr_blocks = ["10.0.30.0/24"]
#}

## << resource "yandex_vpc_network" + "yandex_vpc_subnet"
