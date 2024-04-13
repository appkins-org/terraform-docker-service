locals {
  configs = var.swarm_mode ? var.configs : {}
}
