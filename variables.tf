variable "region" {
  description = "IBM Cloud region where resources will be created."
  type        = string
  default     = "us-south"
}

variable "zone" {
  description = "IBM Cloud zone within the region."
  type        = string
  default     = "us-south-1"
}

variable "instance_profile" {
  description = "VSI instance profile (size)."
  type        = string
  default     = "bx2-2x8"
}

variable "image_id" {
  description = "ID of the OS image for the VSI."
  type        = string
  default     = "r006-2cbe47f3-b1cd-4af6-88d4-35469bf795af"
}

variable "ssh_public_key" {
  description = "Public SSH key content to register in IBM Cloud and assign to the VSI."
  type        = string
}
