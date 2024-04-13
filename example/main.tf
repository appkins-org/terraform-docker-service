module "traefik" {
  source = "../."

  name  = "traefik"
  image = "traefik:latest"

  network_id = "web"
  ports = {
    "80"   = "80"
    "8080" = "8080"
  }

  command = ["--api.insecure=true", "--providers.docker=true", "--entrypoints.web.address=:80"]

  devices = {
    docker_sock = {
      target = "/var/run/docker.sock"
      source = "/var/run/docker.sock"
    }
  }

  swarm_mode = true
}
