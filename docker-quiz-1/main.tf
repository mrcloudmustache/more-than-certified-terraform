provider "docker" {}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.15.0"
    }
  }
}

resource "docker_image" "container_image" {
  name = "grafana/grafana"


}

resource "docker_container" "container_grafana" {
    count = 2
    image = docker_image.container_image.latest
    name = "grafana_container-${count.index}"
    
    ports {
      internal = var.int_port
      external = var.ext_port[count.index]
    }
  
}

variable "int_port" {
    default = 3000

    validation {
        condition = var.int_port == 3000
        error_message = "The Grafana port must be set to 3000."
    }
  
}

variable "ext_port" {
    type = list
  
}

output "public_ip" {
  value = [for x in docker_container.container_grafana: "${x.name} - ${x.ip_address}:${x.ports[0].external}"]
} 
