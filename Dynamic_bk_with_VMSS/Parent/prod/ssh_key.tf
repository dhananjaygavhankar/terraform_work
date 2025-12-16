# resource "tls_private_key" "vmss_ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "local_file" "vmss_ssh_private" {
#   content  = tls_private_key.vmss_ssh.private_key_pem
#   filename = "${path.module}/vmss_id_rsa"
# }

# resource "local_file" "vmss_ssh_public" {
#   content  = tls_private_key.vmss_ssh.public_key_openssh
#   filename = "${path.module}/vmss_id_rsa.pub"
# }

# output "vmss_ssh_public_key" {
#   value = tls_private_key.vmss_ssh.public_key_openssh
# }