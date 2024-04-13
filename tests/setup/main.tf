variable "name" {
  type        = string
  description = "The name of the container"
  default     = "test"
  nullable    = false
}

variable "swarm_mode" {
  type        = bool
  description = "Whether the container should be created in swarm mode"
  default     = true
}

output "swarm_mode" {
  value = var.swarm_mode
}

output "name" {
  value = var.name
}

output "image" {
  value = "${var.name}:latest"
}
