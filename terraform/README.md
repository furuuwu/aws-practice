# Terraform

0. install terraform

https://developer.hashicorp.com/terraform/install?product_intent=terraform

Optionally, install these extensions for VSCode:
- HashiCorp Terraform

1. plan and apply

`terraform plan`

`terraform apply`

2. store the keys if you want to ssh

`terraform output -raw private_key_out > myKey.pem` (delete any previous one)

`chmod 400 myKey.pem`

`ssh -i myKey.pem ec2-user@$(terraform output -raw public_ip)` (for amazon linux)

`ssh -i myKey.pem ec2-user@$(terraform output -raw public_ip)` (for ubuntu)