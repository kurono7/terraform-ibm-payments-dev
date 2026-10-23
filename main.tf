provider "ibm" {
  region = var.region
}

module "vpc" {
  source  = "app.terraform.io/IBMCE/vpc-standard/ibm"
  version = "1.0.0"

  name   = "payments-dev"
  region = var.region
  zone   = var.zone
  tags   = ["team:payments", "env:dev"]
}

data "ibm_is_image" "ubuntu" {
  name = var.image_name
}

resource "ibm_is_ssh_key" "main" {
  name       = "payments-dev-key"
  public_key = var.ssh_public_key
}

resource "ibm_is_instance" "main" {
  name    = "payments-dev-vsi"
  image   = data.ibm_is_image.ubuntu.id
  profile = var.instance_profile

  primary_network_interface {
    subnet          = module.vpc.subnet_id
    security_groups = [module.vpc.security_group_id]
  }

  vpc  = module.vpc.vpc_id
  zone = module.vpc.zone
  keys = [ibm_is_ssh_key.main.id]

  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_is_floating_ip" "main" {
  name   = "payments-dev-fip"
  target = ibm_is_instance.main.primary_network_interface[0].id
}
