output "server_ip" {
  value = module.server.public_ip
}

output "server_instance_id" {
  value = module.server.instance_id
}
