[all:vars]
ansible_ssh_user=root

[rke2_server]
%{ for index, ip in server_ips ~}
${server_names[index]} ansible_host=${ip}
%{ endfor ~}

[rke2_bootstrap]
${server_names[0]} ansible_host=${server_ips[0]}

[rke2_agents]
%{ for index, ip in agent_ips ~}
${agent_names[index]} ansible_host=${ip}
%{ endfor ~}

[rke2_loadbalancers]
%{ for index, ip in lb_ips ~}
${lb_names[index]} ansible_host=${ip}
%{ endfor ~}

[rke2_cluster:children]
rke2_server
rke2_agents
