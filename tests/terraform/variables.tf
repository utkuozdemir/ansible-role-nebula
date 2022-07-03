variable "image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "vm_user" {
  type    = string
  default = "ansible"
}

variable "vm_user_ssh_public_key" {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMrmzi4x1ueVITQXq+Ro4D08BTqe/WYvK4Dw99HMTl/"
}

variable "identifier" {
  type    = string
  default = "ansible-role-nebula"
}

variable "num_vms" {
  type    = number
  default = 5
}

variable "common_tags" {
  type    = list(string)
  default = ["nebula"]
}

variable "vm_tags" {
  type    = map(list(string))
  default = {}
}
