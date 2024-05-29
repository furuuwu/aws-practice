# Packer

This is a tool used to create images and to define what to install and whatever on them, once they are created

0. install Packer

https://developer.hashicorp.com/packer/install?product_intent=packer

Optionally, install these extensions for VSCode:
- Packer Powertools
- Systemd Helper

1. initialize

`packer init .`

2. build

In here you choose what to build.

eg.
- inline html in amazon linux

`packer build -var-file=variables.auto.pkrvars.hcl setup_amazon_linux_nginx.pkr.hcl`

- node app compressed to a .zip file

Zip your app and rename it app.zip. Then run

`packer build -var-file=variables.auto.pkrvars.hcl setup_amazon_linux_node.pkr.hcl`

3. go to /terraform/
