[all:vars]
ansible_ssh_user=root

[k3s_server]
%{ for index, ip in server_ips ~}
${server_names[index]} ansible_host=${ip}
%{ endfor ~}

[k3s_agents]
%{ for index, ip in agent_ips ~}
${agent_names[index]} ansible_host=${ip}
%{ endfor ~}

[k3s_loadbalancers]
%{ for index, ip in lb_ips ~}
${lb_names[index]} ansible_host=${ip}
%{ endfor ~}

[k3s_cluster:children]
k3s_server
k3s_agents
