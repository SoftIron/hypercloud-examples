[all:vars]
ansible_ssh_user=root

[k3s_master]
%{ for index, ip in controller_ips ~}
${controller_names[index]} ansible_host=${ip}
%{ endfor ~}

[k3s_workers]
%{ for index, ip in worker_ips ~}
${worker_names[index]} ansible_host=${ip}
%{ endfor ~}

[k3s_cluster:children]
k3s_master
k3s_workers
