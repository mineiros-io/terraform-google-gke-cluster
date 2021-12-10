module "cluster" {
  source = "../"

  project                       = ""
  network                       = ""
  name                          = ""
  subnetwork                    = ""
  location                      = ""
  min_master_version           = ""
  services_secondary_range_name = ""
  cluster_secondary_range_name  = ""
  master_ipv4_cidr_block        = ""
}
