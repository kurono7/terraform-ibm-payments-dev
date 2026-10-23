terraform {
  required_version = ">= 1.9"

  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.69"
    }
  }

  cloud {
    organization = "IBMCE"
    workspaces {
      name = "terraform-ibm-payments-dev"
    }
  }
}

provider "ibm" {
  region = var.region
}
