k3s_loadbalancers = 1
k3s_controllers   = 1
k3s_workers       = 2
gitlab_user_names = ["palvarez", "rlopez", "dabukalam", "clucasmcmillan"]

/* Networking */
internal_net_id              = 2
internal_net_security_groups = [0, 101]
public_net_id                = 3
public_net_security_groups   = [0, 110]
public_net_ip                = "98.163.170.11"
