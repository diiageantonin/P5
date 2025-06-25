pm_api_url           = "https://10.4.0.98:8006/api2/json"
pm_api_token_id      = "terraform-prov@pve!terraform"
pm_api_token_secret  = "5dc8f936-8a4d-4742-9839-54f660791dc6"

instance_count       = 3

name                 = ["docker-sec", "docker-app", "docker-rp"]
clone                = "template-debian"
target_node          = "Proxmox"

# vmbr0 = LAN / vmbr1 = VM_Network / vmbr2 = DMZ
network_bridge       = ["vmbr1", "vmbr1", "vmbr2"]

ip                   = [
  "ip=192.168.100.203/24,gw=192.168.100.254",
  "ip=192.168.100.204/24,gw=192.168.100.254",
  "ip=10.0.0.10/24,gw=10.0.0.254"
]

server_dns           = "192.168.1.1"
size                 = "20"
storage              = "local-lvm"
ciuser               = "terraform-prov"
cipwd                = "root1234"

ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjYLtCsOh3nJewnyxNnVNNRaD6CVenAZuzweO6buDJbTl8k/TVMXLX8ZDvrcQDM3M9eY6Z74jruX4D7CmGEXI0xeLUNBacqeu4BQvEZHxntHADq9zJYEtj+R7BB/yjhFDuHV3LoTt3rgNnHR/f6iy+yr4R5UMcZex4nd6Y4oMK4kYH+G/hQZXtX3B4eFIedMnups2u90JJKblb9YhRJ75uKIiZnHtWovk1yFM2ol3Bj6JDeEBoIzRycxLj8JaU5RZywfqCyWr2SbfG1/T+7fAhGm+p8Du6KtzI7VVgpwV0/JEieHeEu+zT6AQ69snJV9XBO8eRKwHYhK3lha+J82cNvzvfekyx0PtIv0MXPpEtRWNzl56za5OtwtNgad/5+jIic9gvA7IVEZsUY5k9EWfL7+F4+0vFKL+M6A9IK6FeOH9OTobpPzSDEELuqCbUf/0N8bcTfDCIg0S0XvP7Pqu/1MdlaQFq1u41S2SR1ByhLrPbjfRMGEpxQzbO5SbI4kwEL8EPz6P17kUHcSHO5KeYTM+CasCt1hFTPCqShW3885GEcWiv8SkQByUvq0B9+sn5cWlxsvhfaqzNf/JoxbuExB2Qp6N8kXjLTQ402Wlq7yVQ6ETJD+DNBdMMelmqx9jsWpg+Lo7xdDjL9vcNgLjGnzceneRuJYycnw65O+qHwQ== root@vm-terraform"
