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
  description = "VSI profile specifying vCPU and memory."
  type        = string
  default     = "bx2-2x8"
}

variable "image_name" {
  description = "Name of the base OS image for the VSI."
  type        = string
  default     = "ibm-ubuntu-22-04-5-minimal-amd64-19"
}

variable "ssh_public_key" {
  description = "Public SSH key for instance access."
  type        = string
}
