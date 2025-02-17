variable "node1_ip" {
  description = "Master Node IP"
  type        = string
}

variable "node2_ip" {
  description = "Worker Node IP"
  type        = string
}

variable "ssh_user" {
  description = "SSH Username"
  type        = string
}

variable "ssh_password" {
  description = "SSH Password"
  type        = string
  sensitive   = true
}

# Install Kubernetes on Node1 (Master)
resource "null_resource" "setup_k8s_master" {
  connection {
    type     = "ssh"
    host     = var.node1_ip
    user     = var.ssh_user
    password = var.ssh_password
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt install -y curl apt-transport-https ca-certificates gnupg2",
      "sudo mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.asc",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.asc] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt update && sudo apt install -y kubelet kubeadm kubectl",
      "sudo swapoff -a",
      "sudo sed -i '/swap/d' /etc/fstab",
      "sudo sysctl --system",
      "sudo kubeadm init --apiserver-advertise-address=${var.node1_ip} --pod-network-cidr=192.168.0.0/16",
      "mkdir -p $HOME/.kube",
      "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml"
    ]
  }
}

# Install Kubernetes on Node2 (Worker)
resource "null_resource" "setup_k8s_worker" {
  connection {
    type     = "ssh"
    host     = var.node2_ip
    user     = var.ssh_user
    password = var.ssh_password
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt install -y curl apt-transport-https ca-certificates gnupg2",
      "sudo mkdir -p /etc/apt/keyrings",
      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.asc",
      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.asc] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt update && sudo apt install -y kubelet kubeadm kubectl",
      "sudo swapoff -a",
      "sudo sed -i '/swap/d' /etc/fstab",
      "sudo sysctl --system"
    ]
  }
}

# Get Kubernetes Join Command from Master
resource "null_resource" "get_join_command" {
  depends_on = [null_resource.setup_k8s_master]

  connection {
    type     = "ssh"
    host     = var.node1_ip
    user     = var.ssh_user
    password = var.ssh_password
  }

  provisioner "remote-exec" {
    inline = [
      "sudo kubeadm token create --print-join-command > /tmp/k8s_join.sh",
      "sudo chmod +x /tmp/k8s_join.sh"
    ]
  }
}

# Join Node2 to Kubernetes Cluster
resource "null_resource" "join_worker" {
  depends_on = [null_resource.setup_k8s_worker, null_resource.get_join_command]

  connection {
    type     = "ssh"
    host     = var.node2_ip
    user     = var.ssh_user
    password = var.ssh_password
  }

  provisioner "remote-exec" {
    inline = [
      "scp root@${var.node1_ip}:/tmp/k8s_join.sh /tmp/k8s_join.sh",
      "sudo chmod +x /tmp/k8s_join.sh",
      "sudo /tmp/k8s_join.sh"
    ]
  }
}
