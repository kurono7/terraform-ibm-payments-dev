variable "region" {
  description = "IBM Cloud region"
  type        = string
  default     = "us-south"
}

variable "zone" {
  description = "IBM Cloud zone"
  type        = string
  default     = "us-south-1"
}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "payments-dev"
}

variable "profile" {
  description = "VSI instance profile"
  type        = string
  default     = "bx2-2x8"
}

variable "image" {
  description = "VSI image name"
  type        = string
  default     = "ibm-ubuntu-22-04-5-minimal-amd64-1"
}

variable "ssh_public_key" {
  description = "Public SSH key content to inject into the VSI"
  type        = string
  sensitive   = true
}
