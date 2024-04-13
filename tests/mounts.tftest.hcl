variables {
  name = "test"
  image = "test:latest"
  swarm_mode = true

  mounts = [{
    target    = "/mnt/data"
    source    = "/data"
    type      = "bind"
    read_only = false
  }]
}

mock_provider "docker" {}

run "docker_setup" {
  module {
    source = "./tests/setup"
  }
}

run "sets_mount_length_to_1" {
  assert {
    condition     = length(docker_service.default[0].task_spec[0].container_spec[0].mounts) == 1
    error_message = "incorrect mount length"
  }
}

run "sets_mount_length_to_2" {
  variables {
    devices = [{
      target    = "/var/run/docker.sock"
      source    = "/var/run/docker.sock"
      read_only = true
    }]
  }

  assert {
    condition     = length(docker_service.default[0].task_spec[0].container_spec[0].mounts) == 2
    error_message = "incorrect mount length"
  }
}
