default[:developer][:user] = 'developer'
default[:developer][:projects_root] = "/home/#{node[:developer][:user]}/projects"
default[:developer][:projects] = { }
default[:developer][:vagrant_lxc_boxes] = { }

default.packages = %w( htop vim git curl wget psmisc tmux redir apparmor-utils )

default[:user][:ssh_keygen] = 'false'
default[:users] = [node.developer.user]

default[:go][:version] = "1.1.2"
default[:go][:filename] = "go#{node[:go][:version]}.#{node[:os]}-#{node[:go][:platform]}.tar.gz"
default[:go][:url] = "http://go.googlecode.com/files/#{node[:go][:filename]}"

# ruby that will get installed and set to `rvm use default`.
default[:rvm][:default_ruby] = "2.0.0"

# list of additional rubies that will be installed
default[:rvm][:rubies]  = ['1.9.3', '1.8.7', '2.1.0-preview1']

default[:rvm][:vagrant] = {
  'system_chef_client' => "/opt/chef/bin/chef-client",
  'system_chef_solo'   => "/opt/chef/bin/chef-solo"
}

default[:vagrant][:version] = "1.3.5"
default[:vagrant][:source]  = "http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/vagrant_1.3.5_x86_64.deb"
default[:vagrant][:plugins] = %w(
  vagrant-lxc vagrant-proxyconf vagrant-pristine vagrant-cachier
  vagrant-global-status vagrant-omnibus vagrant-hostmanager
)
