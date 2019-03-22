resource "google_compute_address" "node_ext_addr" {
  count = "${var.node_count}"
  name = "${var.resources_name}-node${count.index}"
  address_type = "EXTERNAL"
}

resource "google_dns_record_set" "node_dns_record" {
  count = "${var.node_count}"
  name = "node${count.index}${var.dns_suffix}"
  managed_zone = "rchain-dev"
  type = "A"
  ttl = 300
  rrdatas = ["${google_compute_address.node_ext_addr.*.address[count.index]}"]
}

resource "google_compute_instance" "node_host" {
  count = "${var.node_count}"
  name = "${var.resources_name}-node${count.index}"
  machine_type = "custom-4-16384"
  tags = [
    "${var.resources_name}-node-public",
    "${var.resources_name}-node-grpc",
    "collectd-out",
    "elasticsearch-out"
  ]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1810"
      size = 160
      type = "pd-ssd"
    }
  }
  network_interface {
    network = "${data.google_compute_network.default_network.self_link}"
    access_config {
      nat_ip = "${google_compute_address.node_ext_addr.*.address[count.index]}"
      //public_ptr_domain_name = "${google_dns_record_set.node_dns_record.*.name[count.index]}"
    }
  }
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "root"
      private_key = "${file("~/.ssh/google_compute_engine")}"
    }
    script = "setup-node"
  }
}
