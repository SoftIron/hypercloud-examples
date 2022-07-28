module "controllers" {
  source          = "./modules/tf-module-hypercloud-node"
  group_name      = "SoftIron PE"
  num             = 3
  name            = "k3s_controller"
  cpus            = 1
  vcpus           = 2
  memory          = 1024
  ssh_key         = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1jman9yJ/cjGZtsr7m+QR3JTd+ZikIfbrNA+tqUbo0x/yFvw0VIF7PFe99pFpzlfNqjqk6/u61g4pQSPDnBHT8IxN43V0K97ul7hLag0+AWP2/qyvxW4yTX7sXr9KOCwa9jaOs2VCGr3pZf0EKulh0NW8ZFwBxh9XjhJGl+k4Witp9k4jTB6xdwVHQaFPP8mcDYcTyWSioPDiLyfml5+Dg9T1OoRWFil+OBZpMx0fOc5K2ZNXo7vIXS2aqeLSNOoHQJ52EhcVzAgwBPhcuQVjyrVCtw4m2zMfjdtTVQ78hpitfBfUgcIOCPZ75Tmx3dj40OV6HtxWYHDgO7427SY9GfnsfhajmtS0QGcsfFPA4jdTdiZly9WOnJr5JZb6PW3PdNZR5I33JkVBLNbg1hFdQqs6dTjL9LG99UUYtC5S0lSuklpwyQCIt5W95n/9JRB2jPv/eg7xQ2htrRm1PFiC2zVJ/l7DWc03cws747mOvMXq9ETOjMJI9DMtTzwsNrc= pedroalvarez@ironx1"
  image_id        = 26
  network_id      = 2
  security_groups = [0, 101]
}
