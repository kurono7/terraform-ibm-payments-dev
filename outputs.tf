output "public_ip" {
  description = "Public floating IP assigned to the VSI."
  value       = ibm_is_floating_ip.main.address
}

output "ssh_command" {
  description = "Ready-to-run SSH command to connect to the VSI."
  value       = "ssh root@${ibm_is_floating_ip.main.address}"
}
