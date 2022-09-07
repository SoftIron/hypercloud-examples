k3s_loadbalancers = 1
k3s_servers       = 1
k3s_agents        = 2

ssh_keys = "$USER[SSH_PUBLIC_KEY]"

hypercloud_group  = "SoftIron PE"
hypercloud_image_id = 26

/* Networking */
internal_net_id              = 2
public_net_id                = 3
public_net_ip                = ""
