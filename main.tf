##############################################################################
# VPC
##############################################################################
resource "ibm_is_vpc" "main" {
  name = "${var.prefix}-vpc"
}

##############################################################################
# Subnet
##############################################################################
resource "ibm_is_subnet" "main" {
  name                     = "${var.prefix}-subnet"
  vpc                      = ibm_is_vpc.main.id
  zone                     = var.zone
  total_ipv4_address_count = 256
}

##############################################################################
# Security group — SSH in, all out
##############################################################################
resource "ibm_is_security_group" "main" {
  name = "${var.prefix}-sg"
  vpc  = ibm_is_vpc.main.id
}

resource "ibm_is_security_group_rule" "ssh_in" {
  group     = ibm_is_security_group.main.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  protocol  = "tcp"
  port_min  = 22
  port_max  = 22
}

resource "ibm_is_security_group_rule" "all_out" {
  group     = ibm_is_security_group.main.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

##############################################################################
# SSH key
##############################################################################
resource "ibm_is_ssh_key" "main" {
  name       = "${var.prefix}-key"
  public_key = var.ssh_public_key
}

##############################################################################
# VSI
##############################################################################
data "ibm_is_image" "ubuntu" {
  name = var.image
}

resource "ibm_is_instance" "main" {
  name    = "${var.prefix}-vsi"
  vpc     = ibm_is_vpc.main.id
  zone    = var.zone
  profile = var.profile
  image   = data.ibm_is_image.ubuntu.id
  keys    = [ibm_is_ssh_key.main.id]

  primary_network_interface {
    subnet          = ibm_is_subnet.main.id
    security_groups = [ibm_is_security_group.main.id]
  }
}

##############################################################################
# Floating IP (public)
##############################################################################
resource "ibm_is_floating_ip" "main" {
  name   = "${var.prefix}-fip"
  target = ibm_is_instance.main.primary_network_interface[0].id
}
