provider "ibm" {
  region = var.region
}

# ------------------------------------------------------------------
# Networking — private module (VPC, subnet, security group, gateway)
# ------------------------------------------------------------------
module "vpc" {
  source  = "app.terraform.io/IBMCE/vpc-standard/ibm"
  version = "1.0.0"

  name           = var.name
  region         = var.region
  zone           = var.zone
  tags           = var.tags
}

# ------------------------------------------------------------------
# SSH Key
# ------------------------------------------------------------------
resource "ibm_is_ssh_key" "payments" {
  name       = "${var.name}-key"
  public_key = var.ssh_public_key
  tags       = var.tags
}

# ------------------------------------------------------------------
# VSI
# ------------------------------------------------------------------
data "ibm_is_image" "ubuntu" {
  name = var.image_name
}

resource "ibm_is_instance" "payments" {
  name    = "${var.name}-vsi"
  image   = data.ibm_is_image.ubuntu.id
  profile = var.instance_profile
  zone    = var.zone

  vpc            = module.vpc.vpc_id
  resource_group = null

  primary_network_interface {
    subnet          = module.vpc.subnet_id
    security_groups = [module.vpc.security_group_id]
  }

  keys = [ibm_is_ssh_key.payments.id]
  tags = var.tags
}

# ------------------------------------------------------------------
# Floating IP (public IP)
# ------------------------------------------------------------------
resource "ibm_is_floating_ip" "payments" {
  name   = "${var.name}-fip"
  target = ibm_is_instance.payments.primary_network_interface[0].id
  tags   = var.tags
}
