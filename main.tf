resource "docker_secret" "default" {
  for_each = var.swarm_mode ? var.secrets : {}

  name = "${each.key}-secret-${replace(timestamp(), ":", ".")}"
  data = base64encode(each.value.content)

  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }
}

resource "docker_config" "default" {
  for_each = var.swarm_mode ? var.configs : {}

  name = each.key
  data = base64encode(each.value.content)
}

resource "docker_volume" "default" {
  for_each = var.volumes

  name = each.key
}

resource "docker_service" "default" {
  count = var.swarm_mode ? 1 : 0

  name = var.name

  task_spec {
    container_spec {
      hostname = var.name

      image = var.image

      command = var.command

      args = var.args

      env = var.env

      dynamic "mounts" {
        for_each = var.devices
        content {
          target    = mounts.value.target
          source    = mounts.value.source
          type      = "bind"
          read_only = mounts.value.read_only
        }
      }

      dynamic "mounts" {
        for_each = var.volumes
        content {
          target    = mounts.value.target
          source    = docker_volume.default[mounts.key].name
          type      = "volume"
          read_only = mounts.value.read_only
        }
      }

      dynamic "mounts" {
        for_each = var.mounts
        content {
          target    = mounts.value.target
          source    = mounts.value.source
          type      = mounts.value.type
          read_only = mounts.value.read_only

          dynamic "bind_options" {
            for_each = mounts.value.bind_options[*]
            content {
              propagation = bind_options.value.propagation
            }
          }

          dynamic "tmpfs_options" {
            for_each = mounts.value.tmpfs_options[*]
            content {
              size_bytes = tmpfs_options.value.size_bytes
              mode       = tmpfs_options.value.mode
            }
          }

          dynamic "volume_options" {
            for_each = mounts.value.volume_options[*]
            content {
              driver_name = volume_options.value.driver_name
            }
          }
        }
      }

      dynamic "secrets" {
        for_each = var.secrets
        content {
          secret_id   = docker_secret.default[secrets.key].id
          secret_name = docker_secret.default[secrets.key].name
          file_name   = secrets.value.target
        }
      }

      dynamic "configs" {
        for_each = var.configs
        content {
          config_id   = docker_config.default[configs.key].id
          config_name = docker_config.default[configs.key].name
          file_name   = configs.value.target
        }
      }

      dynamic "healthcheck" {
        for_each = var.health_check[*]
        content {
          test     = healthcheck.value.test
          interval = healthcheck.value.interval
          timeout  = healthcheck.value.timeout
          retries  = healthcheck.value.retries
        }
      }
    }

    restart_policy {
      condition    = var.restart_policy.condition
      delay        = var.restart_policy.delay
      max_attempts = var.restart_policy.max_attempts
      window       = var.restart_policy.window
    }

    placement {
      constraints = [
        "node.role==manager",
      ]

      prefs = [
        "spread=node.role.manager",
      ]

      max_replicas = var.max_replicas
    }

    log_driver {
      name = var.log_driver.name

      options = var.log_driver.options
    }

    dynamic "networks_advanced" {
      for_each = var.network_id[*]
      content {
        name = networks_advanced.value
      }
    }
  }

  endpoint_spec {
    mode = var.endpoint_mode

    dynamic "ports" {
      for_each = var.ports
      content {
        target_port    = ports.value.internal
        published_port = ports.value.external
        protocol       = ports.value.protocol
        publish_mode   = var.publish_mode
      }
    }
  }

  mode {
    global = var.global
  }
}

resource "docker_container" "default" {
  count = var.swarm_mode ? 0 : 1

  name  = var.name
  image = data.docker_registry_image.default[0].id

  entrypoint = var.command

  command = var.args

  env = formatlist("%s=%s", keys(var.env), values(var.env))

  dynamic "labels" {
    for_each = var.labels
    content {
      label = labels.key
      value = labels.value
    }
  }

  dynamic "mounts" {
    for_each = var.mounts
    content {
      target    = mounts.value.target
      source    = mounts.value.source
      type      = mounts.value.type
      read_only = mounts.value.read_only

      dynamic "bind_options" {
        for_each = mounts.value.bind_options[*]
        content {
          propagation = bind_options.value.propagation
        }
      }

      dynamic "tmpfs_options" {
        for_each = mounts.value.tmpfs_options[*]
        content {
          size_bytes = tmpfs_options.value.size_bytes
          mode       = tmpfs_options.value.mode
        }
      }

      dynamic "volume_options" {
        for_each = mounts.value.volume_options[*]
        content {
          driver_name = volume_options.value.driver_name
        }
      }
    }
  }

  dynamic "volumes" {
    for_each = var.volumes
    content {
      container_path = volumes.value.target
      volume_name    = docker_volume.default[volumes.key].name
      read_only      = volumes.value.read_only
    }
  }

  dynamic "devices" {
    for_each = var.devices
    content {
      container_path = devices.value.target
      host_path      = devices.value.source
      permissions    = devices.value.read_only ? "r" : "rw"
    }
  }

  dynamic "upload" {
    for_each = var.swarm_mode ? {} : merge(var.configs, var.secrets)
    content {
      file    = upload.value.target
      content = upload.value.content
    }
  }

  network_mode = var.network_mode

  dynamic "networks_advanced" {
    for_each = var.network_id[*]
    content {
      name = networks_advanced.value
    }
  }

  dynamic "capabilities" {
    for_each = var.capabilities[*]
    content {
      add  = capabilities.value.add
      drop = capabilities.value.drop
    }
  }

  dynamic "healthcheck" {
    for_each = var.health_check[*]
    content {
      test     = healthcheck.value.test
      interval = healthcheck.value.interval
      timeout  = healthcheck.value.timeout
      retries  = healthcheck.value.retries
    }
  }

  log_driver = var.log_driver.name

  log_opts = var.log_driver.options

  max_retry_count = var.restart_policy.max_attempts

  restart = var.restart_policy.condition

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
      protocol = ports.value.protocol
      ip       = ports.value.ip
    }
  }

  wait = true
}
