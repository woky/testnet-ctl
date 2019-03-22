variable "resources_name" { default = "testnet1" }
variable "gcp_zone" { default = "us-central1-a" }
variable "node_count" { default = 10 }
variable "dns_suffix" { default = ".testnet.rchain-dev.tk." }

provider "google" {
  project = "developer-222401"
  zone    = "${var.gcp_zone}"
}

provider "google-beta" {
  project = "developer-222401"
  zone    = "${var.gcp_zone}"
}
