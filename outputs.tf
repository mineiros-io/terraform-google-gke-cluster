
locals {
  # we need to get the name from the cluster id to create an implicit dependency
  # on the actual created cluster.
  # Just using the name here will not create this dependency as the name is known
  # in the planning phase of terraform.
  # node pools are created using the name only (no self_link, no id is working)
  name_from_id = element(reverse(split("/", google_container_cluster.cluster[0].id)), 0)
}

output "name" {
  value = local.name_from_id
}


output "cluster" {
  value = try(google_container_cluster.cluster[0], null)
}
