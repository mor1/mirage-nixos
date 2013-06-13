iso = {
  :file => 'nixos-minimal-0.2pre4761_4a40a1f-c9208b9-x86_64-linux.iso',
  :md5  => '0c27290ee9cc5cb218aee1f410c2033f'
}

session = {
  :boot_cmd_sequence =>
  [
   '<Enter>', '<Wait>'*30,
   'root',                                              '<Enter>',
   'fdisk /dev/sda',                                    '<Enter>',
   'n',                                                 '<Enter>'*5,
   'a',                                                 '<Enter>',
   '1',                                                 '<Enter>',
   'w',                                                 '<Enter>',
   'mkfs.ext4 -j -L nixos /dev/sda1',                   '<Enter>',
   'mount LABEL=nixos /mnt',                            '<Enter>',
   'curl -O http://10.0.2.2:7122/configuration.nix &&', '<Enter>',
   'mkdir -p /mnt/etc/nixos &&',                        '<Enter>',
   'mv configuration.nix /mnt/etc/nixos &&',            '<Enter>',
   'nixos-install &&',                                  '<Enter>',
   'sleep 5 &&',                                        '<Enter>',
   'reboot',                                            '<Enter>'
  ],
  :boot_wait            => '5',
  :cpu_count            => '1',
  :disk_format          => 'VDI',
  :disk_size            => '8192',
  :hostiocache          => 'off',
  :iso_download_timeout => '1000',
  :iso_file             => iso[:file],
  :iso_md5              => iso[:md5],
  :iso_src              => "http://nixos.org/releases/nixos/#{iso[:file]}",
  :kickstart_file       => 'configuration.nix',
  :kickstart_port       => '7122',
  :kickstart_timeout    => '10000',
  :memory_size          => '256',
  :os_type_id           => 'Linux',
  :postinstall_files    => [ 'postinstall.sh' ],
  :postinstall_timeout  => '10000',
  :shutdown_cmd         => 'shutdown -h now',
  :ssh_guest_port       => '22',
  :ssh_host_port        => '7222',
  :ssh_key              => '',
  :ssh_login_timeout    => '10000',
  :ssh_password         => 'vagrant',
  :ssh_user             => 'vagrant',
  :sudo_cmd             => "sudo '%f'"
}

Veewee::Definition.declare session
