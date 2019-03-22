data "google_compute_network" "default_network" {
  name = "default"
}

resource "google_compute_firewall" "fw_public_node" {
  name = "${var.resources_name}-node-public"
  network = "${data.google_compute_network.default_network.self_link}"
  priority = 530
  target_tags = [ "${var.resources_name}-node-public" ]
  allow {
    protocol = "tcp"
    ports = [ 40400, 40403, 40404 ]
  }
}

resource "google_compute_firewall" "fw_public_node_rpc" {
  name = "${var.resources_name}-node-rpc"
  network = "${data.google_compute_network.default_network.self_link}"
  priority = 540
  target_tags = [ "${var.resources_name}-node-rpc" ]
  allow {
    protocol = "tcp"
    ports = [ 40401 ]
  }
}

resource "google_dns_record_set" "bootstrap_dns_record" {
  name = "bootstrap${var.dns_suffix}"
  managed_zone = "rchain-dev"
  type = "CNAME"
  ttl = 300
  rrdatas = ["node0${var.dns_suffix}"]
}

