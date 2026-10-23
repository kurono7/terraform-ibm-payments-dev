output "public_ip" {
  description = "Floating IP assigned to the VSI"
  value       = ibm_is_floating_ip.main.address
}

output "ssh_command" {
  description = "SSH command to connect to the VSI"
  value       = "ssh ubuntu@${ibm_is_floating_ip.main.address}"
}
