output "container_name" {
  description = "The name of the container"
  value       = docker_container.nodered_container[*].name
}

output "container_ipaddress" {
  description = "The ip address and external port of the container"
  value       = [for i in docker_container.nodered_container[*] : join("", concat(["http://", join(":", [i.ip_address], i.ports[*]["external"])]))]
}
