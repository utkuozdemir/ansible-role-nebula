terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      # renovate: depName=hashicorp/terraform-provider-google
      version = "= 4.27.0"
    }
  }
}

provider "google" {
  project = "playground-54321"
  region  = "us-central1"
  zone    = "us-central1-f"
}


data "google_compute_network" "default" {
  name = "default"
}

resource "random_id" "id" {
  # hex does bytes X 2, so the actual id will be 4 chars long
  byte_length = 2
}

resource "google_compute_firewall" "allow_nebula" {
  name    = "${var.identifier}-allow-nebula"
  network = data.google_compute_network.default.name
  allow {
    protocol = "udp"
    ports    = ["4242"]
  }
  target_tags   = var.common_tags
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.identifier}-allow-ssh"
  network = data.google_compute_network.default.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = var.common_tags
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm" {
  count = var.num_vms

  name         = "${var.identifier}-${random_id.id.hex}-${count.index + 1}"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = data.google_compute_network.default.name
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${var.vm_user_ssh_public_key}"
  }

  tags = concat(var.common_tags, lookup(var.vm_tags, "${var.identifier}-${count.index + 1}", []))
}

resource "local_file" "ansible_inventory" {
  content = templatefile("ansible_inventory.tpl", {
    vms        = google_compute_instance.vm.*
    tags       = sort(distinct(flatten(google_compute_instance.vm.*.tags)))
    identifier = var.identifier
    user       = var.vm_user
    }
  )
  filename = "../inventories/cloud/hosts"
}
