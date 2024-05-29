# Example AWS stuff using terraform + packer

Confusingly enough, you first run the /packer stuff to create images (amis) and only afterwards do you set up the infrastructure with terraform.

There might be a better way to do it but i'm stupid

# Steps:
0. create a AWS account

1.  install the aws cli

https://aws.amazon.com/cli/

2. get the credentials for your account

i'm using the access keys, that is, (aws_access_key_id, aws_secret_access_key) pairs

For that you run

`aws configure`

and input the things.

That is not the recommended way, but i've only had bad experiences with the recommended option (IAM Identity Center)...

https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-authentication.html

see also this

https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration

3. go to /packer/