# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "mirage-nixos64"
  config.ssh.forward_x11 = false
  config.vm.forward_port 80, 8080
  config.vm.share_folder "v-data", "/vagrant", "./data"

  ## uncomment to see the vbox gui while booting -- for debug
  # config.vm.boot_mode = :gui
end
