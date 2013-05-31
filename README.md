Mirage / NixOS
==============

VirtualBox NixOS image for Linux-hosted Mirage.

Forked from <https://github.com/dysinger/nixbox> so as to reuse `veewee` definitions file.

* Install ruby via `rvm` from <https://rvm.io/rvm/install/>

* Install `vagrant` from <http://downloads.vagrantup.com/>

  Also install `vbguest` plugin to maintain guest additions
  
    $ vagrant plugin install vagrant-vbguest

* Install `veewee`

    $ gem install bundle
    $ bundle init                    # create Gemfile
    $ echo 'gem "veewee"' >> Gemfile # add veewee to list
    $ bundle                         # install veewee+deps
    $ alias veewee="bundle exec veewee"
    
* Build NixOS basebox

  + Download base ISO (latest minimal 64 bit)
  
    $ mkdir iso && cd iso
    $ wget http://nixos.org/releases/nixos/latest-iso-minimal-x86_64-linux
    $ cd ..
    
