vagrant_version = node[:vagrant][:version]
vagrant_source  = node[:vagrant][:source]
vagrant_plugins = node[:vagrant][:plugins]
vagrant_path    = "#{Chef::Config[:file_cache_path]}/vagrant_#{vagrant_version}_x86_64.deb"

package 'lxc' do
  options "-o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'"
end

remote_file vagrant_path do
  source vagrant_source
end

bash 'install-vagrant' do
  code   "dpkg -i #{vagrant_path}"
  not_if "dpkg -s vagrant | grep -q '#{vagrant_version}'"
end

node.vagrant.plugins.each do |plugin|
  bash "install-#{plugin}" do
    code "vagrant plugin install #{plugin}"
    user node.developer.user
    environment 'VAGRANT_HOME' => "/home/#{node.developer.user}/.vagrant.d"
    not_if "sudo su -l #{node.developer.user} -- vagrant plugin list | grep -q #{plugin}"
  end
end

bash 'set-vagrant-lxc-default-provider' do
  code "echo 'export VAGRANT_DEFAULT_PROVIDER=lxc' >> /home/#{node.developer.user}/.profile"
  not_if "grep -q 'VAGRANT_DEFAULT_PROVIDER' /home/#{node.developer.user}/.profile"
end

developer_user = node[:developer][:user]
node[:developer][:vagrant_lxc_boxes].each do |name, url|
  bash "vagrant-lxc-box-add-#{name}" do
    code "vagrant box add #{name} #{url}"
    user developer_user
    environment 'VAGRANT_HOME' => "/home/#{developer_user}/.vagrant.d"
    not_if "test -d /home/#{developer_user}/.vagrant.d/boxes/#{name}/lxc"
  end
end
