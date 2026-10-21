output "public_ip" {
  description = "Public floating IP assigned to the VSI."
  value       = ibm_is_floating_ip.payments_fip.address
}

output "ssh_command" {
  description = "SSH command to connect to the VSI."
  value       = "ssh -i prerequisites/ssh-keys/payments-demo ubuntu@${ibm_is_floating_ip.payments_fip.address}"
}
