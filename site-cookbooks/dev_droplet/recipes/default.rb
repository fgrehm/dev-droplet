# apt-get update awesomeness
include_recipe 'apt'

# Install some random packages defined by the user
node.packages.each do |pkg|
  package pkg
end

# Stolen from https://github.com/bflad/chef-docker/blob/91cae5b866e096cbaa962ef1e3db3aafca7782ef/recipes/aufs.rb#L30
image_extra = Mixlib::ShellOut.new("apt-cache search linux-image-extra-`uname -r | grep --only-matching -e [0-9]\.[0-9]\.[0-9]-[0-9]*` | cut -d ' ' -f 1").run_command.stdout.strip
package image_extra

# https://github.com/fnichol/chef-user
include_recipe "user::data_bag"

# https://github.com/fnichol/chef-rvm
include_recipe 'rvm::system'

# Vagrant and vagrant-lxc
include_recipe 'dev_droplet::vagrant'

# GO!
include_recipe 'golang'

# # Git clone projects
include_recipe 'dev_droplet::git_projects'

# dotfiles + vimfiles
include_recipe 'dev_droplet::dotfiles'
