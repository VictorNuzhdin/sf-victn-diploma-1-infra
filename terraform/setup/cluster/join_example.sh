#!/usr/bin/env bash
sudo kubeadm join 10.0.10.10:6443 --token yacb2b.w9akzb2fkszozfvm --discovery-token-ca-cert-hash sha256:9c9c267f3059b0bdc13d9566e360870408b77d81c9aafe716d292b764f056234 
exit 0
