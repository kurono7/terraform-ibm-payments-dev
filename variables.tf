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

variable "image_id" {
  description = "VSI image ID. Default: ibm-ubuntu-22-04-5-minimal-amd64 in us-south."
  type        = string
  default     = "r006-2cbe47f3-b1cd-4af6-88d4-35469bf795af"
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
