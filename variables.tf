variable "name" {
  description = "Base name prefix for all resources."
  type        = string
  default     = "payments-dev"
}

variable "region" {
  description = "IBM Cloud region."
  type        = string
  default     = "us-south"
}

variable "zone" {
  description = "IBM Cloud zone within the region."
  type        = string
  default     = "us-south-1"
}

variable "ssh_public_key" {
  description = "Public SSH key content to inject into the VSI."
  type        = string
  sensitive   = true
}

variable "instance_profile" {
  description = "VSI profile (vCPU x RAM)."
  type        = string
  default     = "bx2-2x8"
}

variable "image_name" {
  description = "Name of the IBM Cloud OS image; resolved to its ID with data.ibm_is_image."
  type        = string
  default     = "ibm-ubuntu-22-04-5-minimal-amd64-19"
}

variable "tags" {
  description = "Tags to attach to all resources."
  type        = list(string)
  default     = ["team:payments", "env:dev"]
}
