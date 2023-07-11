//Config blog

terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

provider "linode" {
  token = var.token
  api_version = "v4beta"
}

//Provision the server which will go through the router

resource "linode_instance" "glustersfs"{
label = "glfs${count.index + 1}"
count = 4
image = "linode/centos7"
region = "us-southeast"
type = "g6-dedicated-4"
root_pass = var.root_pass

//Provisioner/Script setup
  
    provisioner "file"{
    source = "bash/install.sh"
    destination = "/tmp/install.sh"
    connection {
      type = "ssh"
      host = self.ip_address
      user = "root"
      password = var.root_pass
    }
  }

  provisioner "remote-exec"{
    inline = [
      "chmod +x /tmp/install.sh",
      "/tmp/install.sh",
      "sleep 1"
    ]
    connection {
      type = "ssh"
      host = self.ip_address
      user = "root"
      password = var.root_pass
    }
  }
    //VLAN-0 setup
    interface {
    purpose = "public"
    }

    //VLAN-1 setup
    interface {
    purpose      = "vlan"
    label        = "labvlan"
    ipam_address = "192.168.0.${count.index + 1}/24"
    }

}


#variables 

variable "token"{}
variable "root_pass"{}