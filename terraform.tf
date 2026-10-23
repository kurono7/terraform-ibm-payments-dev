terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "IBMCE"
    workspaces {
      name = "terraform-ibm-payments-dev"
    }
  }

  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.65.0"
    }
  }
}
