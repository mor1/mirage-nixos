Mirage / NixOS
==============

VirtualBox NixOS image for Linux-hosted Mirage.

Forked from <https://github.com/dysinger/nixbox> so as to reuse `veewee` definitions file.

Overall workflow is:

1. install dependencies
2. build the NixOS/Mirage basebox using `veewee`
3. create VM instance using `vagrant`
4. strip and convert VM instance into Amazon AMI

Dependencies
------------

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
    
Basebox Build
-------------

* Build NixOS basebox

  + Download base ISO (latest minimal 64 bit)
  
    $ mkdir iso && cd iso
    $ wget http://nixos.org/releases/nixos/latest-iso-minimal-x86_64-linux
    $ cd ..
    
  + Build the basebox
  
    $ veewee vbox build --nogui 'nixos64'
    
  Note that this does not currently work with the install of `vagrant` due to version number mismatch and the separation imposed between gems and the bundled Ruby in the `vagrant` `DMG`.
 
Bring Up the Box
----------------

    $ veewee vbox up
    $ ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
        -p 7222 -l vagrant 127.0.0.1

    
  
Scratchpad 
==========

## post opam install

    . /home/vagrant/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
