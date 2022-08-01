[all:vars]
ansible_ssh_user=root

[control]
%{ for index, ip in controller_ips ~}
${controller_names[index]} ansible_host=${ip}
%{ endfor ~}

[worker]
%{ for index, ip in worker_ips ~}
${worker_names[index]} ansible_host=${ip}
%{ endfor ~}

[k3s_cluster:children]
control
worker
