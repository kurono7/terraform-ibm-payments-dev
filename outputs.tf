output "vpc_id" {
  description = "ID of the VPC."
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "ID of the subnet."
  value       = module.vpc.subnet_id
}

output "vsi_id" {
  description = "ID of the VSI."
  value       = ibm_is_instance.payments.id
}

output "vsi_private_ip" {
  description = "Private IP address of the VSI."
  value       = ibm_is_instance.payments.primary_network_interface[0].primary_ip[0].address
}

output "vsi_public_ip" {
  description = "Public floating IP address assigned to the VSI."
  value       = ibm_is_floating_ip.payments.address
}
