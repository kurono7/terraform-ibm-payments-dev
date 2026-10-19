# ------------------------------------------------------------------
# Network — private module vpc-standard
# ------------------------------------------------------------------
module "network" {
  source  = "app.terraform.io/IBMCE/vpc-standard/ibm"
  version = "1.0.0"

  name   = "payments-dev"
  region = var.region
  zone   = var.zone
}

# ------------------------------------------------------------------
# SSH Key — must be RSA (IBM Cloud VPC does not accept ed25519)
# ------------------------------------------------------------------
resource "ibm_is_ssh_key" "payments_key" {
  name       = "payments-demo-key"
  public_key = var.ssh_public_key
}

# ------------------------------------------------------------------
# VSI
# ------------------------------------------------------------------
resource "ibm_is_instance" "payments_vsi" {
  name    = "payments-vsi"
  vpc     = module.network.vpc_id
  zone    = var.zone
  profile = var.instance_profile
  image   = var.image_id

  primary_network_interface {
    subnet          = module.network.subnet_id
    security_groups = [module.network.security_group_id]
  }

  keys = [ibm_is_ssh_key.payments_key.id]
}

# ------------------------------------------------------------------
# Floating IP — public access
# ------------------------------------------------------------------
resource "ibm_is_floating_ip" "payments_fip" {
  name   = "payments-fip"
  target = ibm_is_instance.payments_vsi.primary_network_interface[0].id
}
