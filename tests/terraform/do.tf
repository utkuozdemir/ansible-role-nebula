terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.16.0"
    }
  }
}

provider "digitalocean" {
  token = trimspace(file(".do-token.txt"))
}

resource "digitalocean_droplet" "droplet" {
  count    = var.num_droplets
  image    = var.image
  name     = "${var.name_prefix}${count.index + 1}"
  region   = var.region
  size     = var.size
  ssh_keys = var.ssh_keys
  tags     = concat(var.common_tags, lookup(var.droplet_tags, "${var.name_prefix}${count.index + 1}", []))
}

resource "local_file" "ansible_inventory" {
  content = templatefile("ansible_inventory.tpl", {
    droplets = digitalocean_droplet.droplet.*
    tags     = sort(distinct(flatten(digitalocean_droplet.droplet.*.tags)))
    }
  )
  filename = "../inventories/do/hosts"
}
