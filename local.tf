locals {
  configs = var.swarm_mode ? var.configs : {}

  ports = values({ for port in var.ports : "${port.external}:${port.internal}/${port.protocol}" => port })

  mounts = concat([
    for k, v in var.volumes : {
      target    = v.target
      source    = docker_volume.default[k].name
      type      = "volume"
      read_only = v.read_only
    } if v.target != null], [
    for device in var.devices : {
      target    = device.target
      source    = device.source
      read_only = device.read_only
      type      = "bind"
    }
  ], var.mounts)
}
