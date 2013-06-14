# vagrant-php5-dev-env

Setup a PHP5 development environment using [Vagrant] and [Librarian-puppet] based on Debian with Nginx and PHP5-FPM.

Provisioning is done via [Puppet]. The Puppet modules are managed by [Librarian-puppet].

Librarian-puppet is a bundler for a puppet infrastructure. It can be used to manage the puppet modules the infrastructure depends on.

It is based on [Librarian], a framework for writing bundlers, which are tools that resolve, fetch, install, and isolate a project's dependencies.

Librarian-puppet manages the `modules/` directory based on the `Puppetfile`. The `[PROJECT_DIR]/Puppetfile` becomes the authoritative source for what modules are required and at which version, tag or branch.

With using Librarian-puppet the contents of the `modules/` directory should be modified.

The integration of Vargant with librarian-puppet is provided by [librarian-puppet-vagrant] - a simple Vagrant middleware which runs `librarian-puppet install` before each `vagrant up` and `vagrant provision` right on the host system.


## Prerequisits

- [Ruby Version Manager (RVM)](https://rvm.io/) installed.
- [Oracle VM Virtualbox](https://www.virtualbox.org/), v4.2.10 installed.

## One-time Setup Procedure

    cd [PROJECT_DIR]

...install required ruby gems using [Bundler]:

    bundle install

The default IP of the Vagrant VM is `192.168.13.40`. This can be configured in `[PROJECT_DIR]/Vagrantfile`.

Create a local host entry: `192.168.13.40 NAME_OF_PROJECT.local` by editing `/etc/hosts` on *nix systems.

Test with `ping NAME_OF_PROJECT.local`.

Adjust path for shared folder pointing to project's php src in `[PROJECT_DIR]/Vagrantfile` (3rd parameter):

    config.vm.share_folder "v-data", "/vagrant_data", "../vagrant-php5-dev-env-PROJECT/", :nfs => true

## Start Development Environment

    vagrant up

## Troubleshooting

### OS X - Error: Could not connect via HTTPS to https://forge.puppetlabs.com

In case `vagrant up` or `vagrant provision` result in the following error on OS X:

    Notice: Searching https://forge.puppetlabs.com ...
    Error: Could not connect via HTTPS to https://forge.puppetlabs.com
      Unable to verify the SSL certificate
        The certificate may not be signed by a valid CA
        The CA bundle included with OpenSSL may not be valid or up to date
    Error: Try 'puppet help module search' for usage

... you need to add openssl to rvm and reinstall ruby:

    rvm pkg install openssl
    rvm remove 1.9.3-p327
    rvm install 1.9.3-p327 --with-openssl-dir=$rvm_path/usr


[Vagrant]: http://www.vagrantup.com/ "Vagrant"
[Librarian-puppet]: https://github.com/rodjek/librarian-puppet "Librarian-puppet"
[Puppet]: https://puppetlabs.com/puppet/puppet-open-source/ "Puppet"
[Librarian]: https://github.com/applicationsonline/librarian "Librarian"
[librarian-puppet-vagrant]: https://github.com/garethr/librarian-puppet-vagrant "librarian-puppet-vagrant"
[Bundler]: http://gembundler.com/ "Bundler"
