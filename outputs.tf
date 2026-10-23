output "public_ip" {
  description = "Public floating IP of the VSI."
  value       = ibm_is_floating_ip.main.address
}

output "ssh_command" {
  description = "Command to connect to the VSI via SSH."
  value       = "ssh -i prerequisites/ssh-keys/payments-demo ubuntu@${ibm_is_floating_ip.main.address}"
}
