[control]
%{ for index, ip in controller_ips ~}
${controller_names[index]} ansible_host=${ip}
%{ endfor ~}

[k3s_cluster:children]
control
worker
