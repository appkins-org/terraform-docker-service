locals {
  configs = var.swarm_mode ? var.configs : {}

  ports = values({ for port in var.ports : "${port.external}:${port.internal}/${port.protocol}" => port })
}
