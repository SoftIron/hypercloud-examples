[all:vars]
ansible_ssh_user=root

[dnsmasq]
%{ for index, ip in dnsmasq_ips ~}
${dnsmasq_names[index]} ansible_host=${ip}
%{ endfor ~}
