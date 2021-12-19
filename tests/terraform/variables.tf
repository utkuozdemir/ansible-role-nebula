variable "region" {
  type    = string
  default = "fra1"
}

variable "image" {
  type    = string
  default = "ubuntu-20-04-x64"
}

variable "size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "ssh_keys" {
  type    = list(number)
  default = [32679303]
}

variable "name_prefix" {
  type    = string
  default = "do"
}

variable "num_droplets" {
  type    = number
  default = 5
}

variable "common_tags" {
  type    = list(string)
  default = ["nebula"]
}

variable "droplet_tags" {
  type = map(list(string))
  //noinspection TFIncorrectVariableType
  default = {}
}
