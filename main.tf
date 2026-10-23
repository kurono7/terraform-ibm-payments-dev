module "network" {
  source  = "app.terraform.io/IBMCE/vpc-standard/ibm"
  version = "1.0.0"

  name              = var.name
  region            = var.region
  zone              = var.zone
  subnet_cidr       = var.subnet_cidr
  allow_ssh_cidr    = "0.0.0.0/0"
  tags              = var.tags
}

resource "ibm_is_ssh_key" "payments" {
  name       = "${var.name}-key"
  public_key = var.ssh_public_key
  tags       = var.tags
}

resource "ibm_is_instance" "payments" {
  name    = "${var.name}-vsi"
  image   = var.image_id
  profile = var.profile

  vpc  = module.network.vpc_id
  zone = module.network.zone

  primary_network_interface {
    subnet          = module.network.subnet_id
    security_groups = [module.network.security_group_id]
  }

  keys = [ibm_is_ssh_key.payments.id]
  tags = var.tags
}

resource "ibm_is_floating_ip" "payments" {
  name   = "${var.name}-fip"
  target = ibm_is_instance.payments.primary_network_interface[0].id
  tags   = var.tags
}
