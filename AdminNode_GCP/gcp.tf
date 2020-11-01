
#Declaring GCP provider
provider "google" {
  credentials = "${file("credentials.json")}"
  project = "tough-history-289605"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Declaring instance-1
resource "google_compute_instance" "vm_instance1" {
  name         = "ubuntu-admin-vm2"
  machine_type = "e2-micro"


  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20201014"
    }
  }

  network_interface {
    # Default network
    network = "default"

  access_config {
      // Ephemeral IP
    }
  }

  #Copy public key
  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }

  #Copy GCP auth token
  provisioner "file" {
    source = "credentials.json"
    destination = "/tmp/credentials.json"

    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent = "false"
  }
  }

  #Remote command execution over ssh
  provisioner "remote-exec" {
    inline = [
      "apt-get update && apt-get install -y docker.io mc wget openjdk-8-jdk python-boto ansible awscli"
    ]
  }
    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent = "false"
  }
    }

################
# Firewall rules
################
resource "google_compute_firewall" "default" {
  name    = "instance-firewall"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22"]
  }

}







