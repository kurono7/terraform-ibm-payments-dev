output "public_ip" {
  description = "Floating (public) IP address assigned to the payments VSI."
  value       = ibm_is_floating_ip.payments.address
}

output "ssh_command" {
  description = "SSH command to connect to the VSI."
  value       = "ssh root@${ibm_is_floating_ip.payments.address}"
}

output "vpc_id" {
  description = "ID of the VPC created for the payments team."
  value       = module.network.vpc_id
}

output "vsi_id" {
  description = "ID of the payments VSI."
  value       = ibm_is_instance.payments.id
}
