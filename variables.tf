variable "name" {
  description = "Base name used as prefix for all resources (e.g. payments-dev)."
  type        = string
  default     = "payments-dev"
}

variable "region" {
  description = "IBM Cloud region."
  type        = string
  default     = "us-south"
}

variable "zone" {
  description = "IBM Cloud availability zone."
  type        = string
  default     = "us-south-1"
}

variable "subnet_cidr" {
  description = "IPv4 CIDR block for the subnet."
  type        = string
  default     = "10.240.0.0/24"
}

variable "image_name" {
  description = "VPC image name. Resolved to ID at plan time via data source — update when IBM publishes a new revision."
  type        = string
  default     = "ibm-ubuntu-22-04-5-minimal-amd64-19"
}

variable "profile" {
  description = "VSI instance profile."
  type        = string
  default     = "bx2-2x8"
}

variable "ssh_public_key" {
  description = "SSH public key content. Managed as a sensitive workspace variable in HCP Terraform."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to attach to all resources."
  type        = list(string)
  default     = ["team:payments", "env:dev", "managed-by:terraform"]
}
