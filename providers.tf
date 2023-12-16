terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.34.0"
    }
    # ansible = {
    #   version = "~> 1.1.0"
    #   source  = "ansible/ansible"
    # }
  }
}

provider "digitalocean" {
  token = var.do_token
}