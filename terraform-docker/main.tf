resource "null_resource" "dockervol1" {
    provisioner "local-exec" {
        command = "sudo mkdir dockervol1/ || true && sudo chown -R 1000:1000 dockervol1/"
    }
}

module "images" {
    source = "./image"
    image_in = var.image[var.env]
  
}

resource "docker_container" "nodered_container" {
  depends_on = [ null_resource.dockervol1 ]
  count = local.container_count
  name  = join("-", ["nodered" ,var.env,random_string.random[count.index].result])
  image = module.images.image_out
  ports {
    internal = var.int_port
    external = var.ext_port[var.env][count.index]
  }

  volumes {
    container_path = "/data"
    host_path = "${path.cwd}/dockervol1"
  }
}


resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  upper   = false
  special = false
}
