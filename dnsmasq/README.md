# Dnsmasq deployment example for HyperCloud

This example will deploy a single DNS server running `dnsmasq`.

To run these scripts you will need recent versions of `terraform`
and `ansible` tools installed.

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


## Installing Dnsmasq

The scripts have some default domains configured as an example, you can modify
these by editing [ansible/files/hosts].

Now, with the VM deployed, and your `hosts` file configured, you can run the
following Ansible playbook from the `ansible/` folder:

    ansible-playbook -i inventory/hosts deploy_dnsmasq.yaml

This command will install and configure `dnsmasq` on the servers created
previously with Terraform.

You can use `dig` to verify that the service is working:

    dig @<host-IP> <domain>

[ansible/files/hosts]: ansible/files/hosts
