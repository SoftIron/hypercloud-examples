# K3s deployment example for HyperCloud

This example will help you deploy a basic Kubernetes cluster into HyperCloud,
and additionally a few application examples running on top. These examples also
integrate with persistent storage from HyperCloud, and configure the services
with SSL certificates.

To run these scripts you will need recent versions of `terraform` and `ansible`
tools installed.

Some variables used by the scripts need to be modified to work on other
environments as there are a few values hardcoded. You can find them in
[terraform/terraform.tfvars]:

- `hypercloud_image_id` - ID of the image to use on the VMs, Debian or Ubuntu.
- `hypercloud_group` - Name of the group used to deploy the VMs.
- `internal_net_id` - ID of the network used by the VMs. Needs to be reachable
  from where you are running the deployment scripts.
- `public_net_id` - ID of a network that can get public IPs.
- `public_net_ip` - The public IP to use. Empty by default, this will use an
  available IP from the network specified. You can set an specific IP.

## Creating the VMs with Terraform

First you have to run the Terraform scripts from the `terraform/` folder. You
will need a couple of env variables with your HyperCloud credentials to
authenticate, for example:

    export TF_VAR_one_username="palvarez"
    export TF_VAR_one_password="23a0ce0ac7809e0as98e7..."

With those env variables configured, you should be able to run the Terraform
scripts:

    terraform init
    terraform apply

This will create all the VMs needed, and an Ansible inventory file located on
`ansible/inventory/hosts`

## Installing K3s

With the VMs deployed, you can run the following Ansible playbook from
the `ansible/` folder:

    ansible-playbook -i inventory/hosts k3s_cluster.yaml

This command will take a while. It will configure all the Kubernetes nodes.

## Example applications on Kubernetes

Once Kubernetes is running, you can start installing things on top. You can
find on the `kubernetes/` folder the examples we are going to be deploying now.

These examples include:
- [Haste-Server with S3 integration](haste-server.md)
- [Lychee with CephFS integration](lychee.md)


[terraform/terraform.tfvars]: terraform/terraform.tfvars
