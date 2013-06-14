# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'librarian/puppet/vagrant'

Vagrant::Config.run do |config|

  config.vm.box = "debian-607-x64-vbox4210"

  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-607-x64-vbox4210.box"

  config.vm.network :hostonly, "192.168.13.40"

  # NFS Folders for better performance (NOT AVAILABLE on Windows-Systems)
  config.vm.share_folder "v-root", "/vagrant", ".", :nfs => true

  # The 2nd parameter is a path to a directory on the host machine.
  # If the path is relative, it is relative to the project root.
  config.vm.share_folder "v-data", "/vagrant_data", "../vagrant-php5-dev-env-PROJECT/", :nfs => true

  # This allows symlinks to be created within the /vagrant root directory,
  # which is something librarian-puppet needs to be able to do. This might
  # be enabled by default depending on what version of VirtualBox is used.
  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file  = "main.pp"
  end

end
