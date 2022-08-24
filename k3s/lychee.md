# Lychee with CephFS integration

This example will deploy Lychee photo-management tool using CephFS as the storage backend through [Ceph CSI].

The first thing we need to configure is the [CSI CephFS plugin]. You will find
an example configuration file that can be modified for your environment in
[kubernetes/lychee/ceph-csi-configmap.yaml]

Additionally we need to configure a Kubernetes StorageClass. For this to work
in your environment you will need to modify the following files:
- [kubernetes/lychee/ceph-conf.yaml] with your `ceph.conf`
- [ceph-cephfs-secrets.yaml] with the relevant Keyrings
- [kubernetes/lychee/ceph-cephfs-sc.yaml] with the Ceph pool to use

The rest of the files the `kubernetes/lychee` folder will deploy MariaDB
and the Lychee service itself, with the necessary Persitent Volume Claims.

To simplify the deployment of the service and dependencies, you can run the
following Ansible playbook from the `ansible/` folder:

    ansible-playbook -i inventory/hosts deploy_lychee_kubernetes.yaml

[Ceph CSI]: https://github.com/ceph/ceph-csi
[CSI CephFS plugin]: https://github.com/ceph/ceph-csi/blob/devel/docs/deploy-cephfs.md
[kubernetes/lychee/ceph-csi-configmap.yaml]: kubernetes/lychee/ceph-csi-configmap.yaml
[kubernetes/lychee/ceph-conf.yaml]: kubernetes/lychee/ceph-conf.yaml
[ceph-cephfs-secrets.yaml]: ceph-cephfs-secrets.yaml
[kubernetes/lychee/ceph-cephfs-sc.yaml]: kubernetes/lychee/ceph-cephfs-sc.yaml
