# terraform-ibm-payments-dev

Terraform configuration for the payments team on IBM Cloud.

> Infrastructure was provisioned and destroyed as part of the DevOps Day 2026 demo.
> Resources can be re-provisioned by adding the Terraform files back and triggering a new run in HCP Terraform (org: IBMCE).

## What was provisioned

- VPC (`payments-dev`) via private module `IBMCE/vpc-standard/ibm v1.0.0`
- Public gateway, subnet, security group (SSH + ICMP inbound, all outbound)
- VSI `payments-vsi` — Ubuntu 22.04 minimal (`bx2-2x8`, `us-south-1`)
- Floating IP (public access)
- SSH key registered from `prerequisites/ssh-keys/payments-demo.pub`
