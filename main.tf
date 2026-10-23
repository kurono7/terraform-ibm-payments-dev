provider "ibm" {
  region = var.region
}

module "network" {
  source  = "app.terraform.io/IBMCE/vpc-standard/ibm"
  version = "1.0.0"

  name   = "payments-dev"
  region = var.region
  zone   = var.zone
}

resource "ibm_is_ssh_key" "main" {
  name       = "payments-demo-key"
  public_key = var.ssh_public_key
}

data "ibm_is_image" "ubuntu" {
  name = var.image_name
}

resource "ibm_is_instance" "main" {
  name    = "payments-vsi"
  vpc     = module.network.vpc_id
  zone    = var.zone
  profile = var.instance_profile
  image   = data.ibm_is_image.ubuntu.id
  keys    = [ibm_is_ssh_key.main.id]

  primary_network_interface {
    subnet          = module.network.subnet_id
    security_groups = [module.network.security_group_id]
  }
}

resource "ibm_is_floating_ip" "main" {
  name   = "payments-fip"
  target = ibm_is_instance.main.primary_network_interface[0].id
}
