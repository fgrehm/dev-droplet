# -*- mode: ruby -*-
# vi: set ft=ruby :

begin
  require 'dotenv'
  Dotenv.load '.env.vagrant'
rescue LoadError; end

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "raring64"
  config.vm.hostname = ENV.fetch('HOST', 'dev.example.com')

  config.cache.auto_detect = true
  config.omnibus.chef_version = :latest

  config.vm.provider :lxc do |lxc, override|
    # Required to boot nested containers
    lxc.customize 'aa_profile', 'unconfined'
    override.vm.box_url = 'http://bit.ly/vagrant-lxc-raring64-2013-07-12'
  end

  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = ENV.fetch("PRIVATE_KEY", '~/.ssh/id_dsa')
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    # TODO: We should be able to skip this once https://github.com/fgrehm/vagrant-cachier/issues/45
    #       gets sorted out
    override.cache.auto_detect = false

    vars = JSON.parse(File.read('variables.json'))
    provider.client_id = vars['do_client_id']
    provider.api_key   = vars['do_api_key']
    provider.region    = 'New York 1'
    provider.image     = 'Ubuntu 13.04 x64'
  end

  # Required to boot nested containers
  config.vm.provision :shell, inline: %[
    if ! [ -f /etc/default/lxc ]; then
      cat <<STR > /etc/default/lxc
LXC_AUTO="true"
USE_LXC_BRIDGE="true"
LXC_BRIDGE="lxcbr0"
LXC_ADDR="10.1.253.1"
LXC_NETMASK="255.255.255.0"
LXC_NETWORK="10.1.253.0/24"
LXC_DHCP_RANGE="10.1.253.2,10.1.253.254"
LXC_DHCP_MAX="253"
LXC_SHUTDOWN_TIMEOUT=120
STR
    fi

    # Ugly workaround for triggering a Golang installation when the tarball is
    # cached because of vagrant-cachier
    if ! [ -d /usr/local/go ]; then
      echo 'Cleaning cached go tgz archive'
      rm -f /var/chef/cache/go*.tar.gz
    fi
  ]

  config.vm.provision :chef_solo do |chef|
    chef.data_bags_path = "data_bags"
    chef.cookbooks_path = %w( site-cookbooks vendor )

    chef.add_recipe "dev_droplet"
    chef.add_recipe "rvm::vagrant"

    chef.json = {
      "developer" => {
        "user" => "example",
        "projects" => {
          "dotfiles" => { "repository" => "https://github.com/fgrehm/dotfiles.git" },
          "vimfiles" => { "repository" => "https://github.com/fgrehm/vimfiles.git" },
        },
        "vagrant_lxc_boxes" => {
          "precise64" => "http://bit.ly/vagrant-lxc-precise64-2013-09-28",
        }
      },
      "vagrant" => { "plugins" => %w( vagrant-lxc vagrant-cachier ) }
    }
  end

  config.vm.provision :shell, inline: 'apt-get upgrade -y'
end
