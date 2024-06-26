variable "name" {
  type        = string
  description = "The name of the container"
  nullable    = false
}

variable "network_id" {
  type        = string
  description = "The name of the network to attach the container to"
  nullable    = true
  default     = null
}

variable "network_mode" {
  type        = string
  description = "The network mode for the container"
  nullable    = true
  default     = "default"
}

variable "capabilities" {
  type = object({
    add  = optional(list(string))
    drop = optional(list(string))
  })
  description = "The capabilities to add or drop in the container."
  nullable    = true
  default     = null
}

variable "swarm_mode" {
  type        = bool
  description = "Whether the container should be created in swarm mode"
  nullable    = false
  default     = true
}

variable "image" {
  type        = string
  description = "The image to use for the container"
  nullable    = false
}

variable "labels" {
  type        = map(string)
  description = "The labels to apply to the container"
  nullable    = false
  default     = {}
}

variable "ports" {
  type = list(object({
    internal = number
    external = number
    protocol = optional(string, "tcp")
    ip       = optional(string, "0.0.0.0")
  }))
  description = "The ports to publish."
  nullable    = false
  default     = []
}

variable "command" {
  type        = list(string)
  description = "The command to run in the container"
  nullable    = false
  default     = []
}

variable "args" {
  type        = list(string)
  description = "Arguments to pass to the command in the container"
  nullable    = false
  default     = []
}

variable "env" {
  type        = map(string)
  description = "The environment variables to set in the container"
  nullable    = false
  default     = {}
}

variable "volumes" {
  type = map(object({
    target    = optional(string)
    read_only = optional(bool, false)
  }))
  description = "The volumes to mount in the container"
  nullable    = false
  default     = {}
}

variable "configs" {
  type = map(object({
    target    = string
    content   = string
    file_gid  = optional(number, 0)
    file_uid  = optional(number, 0)
    file_mode = optional(number, 420)
  }))
  description = "The configs to create in the container"
  nullable    = false
  default     = {}
}

variable "secrets" {
  type = map(object({
    target  = string
    content = string
  }))
  description = "The secrets to create in the container"
  nullable    = false
  default     = {}
}

variable "mounts" {
  type = list(object({
    target = string
    type   = optional(string, "bind")
    source = optional(string)
    tmpfs_options = optional(object({
      size_bytes = number
      mode       = number
    }))
    bind_options = optional(object({
      propagation = string
    }))
    volume_options = optional(object({
      driver_name    = string
      driver_options = map(string)
      no_copy        = bool
      labels         = map(string)
    }))
    read_only = optional(bool, false)
  }))
  description = "The mounts to create in the container"
  nullable    = false
  default     = []
}

variable "devices" {
  type = list(object({
    source    = string
    target    = string
    read_only = optional(bool, true)
  }))
  description = "The devices to mount in the container"
  nullable    = false
  default     = []
}

variable "health_check" {
  type = object({
    test         = list(string)
    interval     = optional(string, "10s")
    timeout      = optional(string, "5s")
    retries      = optional(number, 4)
    start_period = optional(string, "1s")
  })
  description = "The healthcheck configuration for the container"
  nullable    = true
  default     = null
}

variable "log_driver" {
  type = object({
    name    = string
    options = map(string)
  })
  description = "The log driver configuration for the container"
  nullable    = false
  default = {
    name = "json-file"
    options = {
      "max-size" = "10m"
      "max-file" = "3"
    }
  }
}

variable "restart_policy" {
  type = object({
    condition = optional(string, "on-failure")

    delay        = optional(string, "3s")
    max_attempts = optional(number, 4)
    window       = optional(string, "10s")
  })
  description = "The restart policy for the container"
  nullable    = false
  default     = {}
}

# Swarm mode variables

variable "endpoint_mode" {
  type        = string
  description = "The endpoint mode for the container"
  default     = "vip"
  nullable    = false

  validation {
    condition     = contains(["vip", "dnsrr"], var.endpoint_mode)
    error_message = "Invalid endpoint mode"
  }
}

variable "groups" {
  type        = list(string)
  description = "A list of additional groups that the container process will run as."
  nullable    = false
  default     = []
}

variable "publish_mode" {
  type        = string
  description = "The publish mode for the container"
  default     = "ingress"
  nullable    = false

  validation {
    condition     = contains(["host", "ingress"], var.publish_mode)
    error_message = "Invalid publish mode"
  }
}

variable "global" {
  type        = bool
  description = "Whether the container should be global"
  default     = false
  nullable    = false
}

variable "placement" {
  type = object({
    constraints = optional(list(string), [])
    prefs       = optional(list(string), [])
  })
  description = "The placement configuration for the container"
  nullable    = false
  default     = {}
}

variable "max_replicas" {
  type        = number
  description = "The maximum number of replicas for the container"
  default     = 1
  nullable    = false
}

variable "runtime" {
  type        = string
  description = "The runtime to use for the container"
  default     = "container"
  nullable    = false
}

variable "sysctl" {
  type        = map(string)
  description = "Sysctl config."
  default     = {}
  nullable    = false
}

variable "privileges" {
  type = object({
    se_linux = optional(object({
      disable = optional(bool, false)
      user    = optional(string, "system_u")
      role    = optional(string, "system_r")
      type    = optional(string, "super_t")
      level   = optional(string, "s0")
    }))
  })
  default     = null
  nullable    = true
  description = "SELinux options for the container."
}
