variable "image" {
    type = map
    default = {
        dev = "nodered/node-red:latest"
        prod = "nodered/node-red:latest-minimal"
    }
}

variable "ext_port" {
  type = map

validation {
    condition = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) >= 1980
  error_message = "The value must be between 1980 - 65535."

    }

validation {
    condition = max(var.ext_port["prod"]...) < 1980 && min(var.ext_port["prod"]...) >= 1880
  error_message = "The value must be between 1880 - 1979."

    }
}

variable "int_port" {
  type = number
  default = 1880

  validation {
    condition = var.int_port == 1880
    error_message = "The value must be 1880"
  }
}

variable "env" {
  type = string
  description = "The name of the environment"
  default = "prod"
  
}

locals {
  container_count = length(var.ext_port[var.env])
}
