terraform {
  required_version = "~> 1.9"

  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.89"
    }
  }

  cloud {
    organization = "IBMCE"
    workspaces {
      name = "payments-vsi-dev"
    }
  }
}

provider "ibm" {
  region = var.region
}
