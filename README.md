# K3S deployment scripts for HyperCloud

To run this scripts you will need `terraform` and `ansible` installed.

Frist you have to run the Terraform scripts from the `terraform/` folder. You
will need a couple of env variables with your HyperCloud credentials:

    export TF_VAR_one_username="palvarez"
    export TF_VAR_one_password="23a0ce0ac7809e0as98e7..."
    terraform init
    terraform apply

This will create all the VMs needed, and an Ansible inventory file located on
`ansible/inventory/hosts`

Once the VMs are created, you can run the following `ansible` commands from
the `ansible/` folder:

    ansible-playbook -i inventory/hosts k3s_cluster.yaml
    ansible-playbook -i inventory/hosts haproxy.yaml
