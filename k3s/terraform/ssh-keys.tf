data "http" "ssh_keys" {
  url = "https://git.softiron.com/${var.gitlab_user_names[count.index]}.keys"
  count = length(var.gitlab_user_names)
}
