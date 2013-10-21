# dev-droplet

Recipes for building a [DigitalOcean](https://www.digitalocean.com) Droplet for
my needs, fell free to fork and adapt to your own :)


## Dependencies

Packer >= 0.3.10 for building DigitalOcean droplets and Vagrant 1.1+ for local
testing.


## What's included?

* [Go](http://golang.org/) 1.1.2
* Ruby 2.0.0 (default), 2.1.0-preview1, 1.9.3 and 1.8.7 installed with [RVM](https://rvm.io/)
* Vagrant 1.3.5 + [a whole lot of plugins](site-cookbooks/dev_droplet/attributes/default.rb#L28-L31)
  and some [vagrant-lxc](https://github.com/fgrehm/vagrant-lxc) base boxes
* Configuration of my own [dotfiles](https://github.com/fgrehm/dotfiles.git) and
  [vimfiles](https://github.com/fgrehm/vimfiles.git)
* Git checkout of some OSS projects I'm a maintainer / a collaborator / interested
  on working.


## Initial setup

First clone the repo and install the required cookbooks to the right path:

```
$ git clone https://github.com/fgrehm/dev-droplet.git
$ cd dev-droplet
$ gem install librarian-chef
$ librarian-chef install --path=vendor
```

### Testing on Vagrant

An [example user](data_bags/users/example.json) and a [`Vagrantfile`](Vagrantfile)
are provided along with the project, so just go ahead and `vagrant up` after
installing the required cookbooks with librarian-chef.

### Create Droplet image with Packer

Create a `variables.json` file with your DigitalOcean keys like:

```json
{
  "do_client_id": "DIGITAL_OCEAN_CLIENT_ID",
  "do_api_key": "DIGITAL_OCEAN_API_KEY"
}
```

Copy the provided [data_bags/users/developer.json.example](data_bags/users/developer.json.example)
over to `data_bags/users/developer.json` and add your desired password and public
SSH key to the data bag and run [`./build`](build) from the project's root.

To generate the password you can use `openssl passwd -1 "theplaintextpassword"`
