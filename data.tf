data "docker_registry_image" "default" {
  count = var.swarm_mode ? 0 : 1

  name = var.image
}
