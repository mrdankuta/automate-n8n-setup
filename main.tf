
resource "digitalocean_ssh_key" "default" {
  name       = "Terraform Key"
  public_key = file(var.ssh_public_key_path)
}

resource "digitalocean_droplet" "autoserve" {
  name      = "auto-server"
  region    = "lon1"
  size      = "s-1vcpu-2gb-amd"
  image     = "ubuntu-20-04-x64"
  ssh_keys  = [digitalocean_ssh_key.default.fingerprint]

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Server Ready!"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key_path)
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i ${digitalocean_droplet.autoserve.ipv4_address}, --private-key=${var.ssh_private_key_path} -e 'pub_key=${var.ssh_public_key_path}' playbook.yml"
  }

}

output "droplet_ip" {
  value = digitalocean_droplet.autoserve.ipv4_address
}
