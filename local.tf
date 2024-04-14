locals {
  configs = var.swarm_mode ? var.configs : {}

  ports = values({ for ports in var.ports : ports.internal => ports })
}
