# Copyright (c) 2013 Richard Mortier <mort@cantab.net>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
# OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

NIXDMG = images/nix-store.dmg
NIXBIN = nix-1.5.3-x86_64-darwin.tar.bz2
NIXREV = 5350097
NIXURL = http://hydra.nixos.org/build/$(NIXREV)/download/1/$(NIXBIN)

all: install-nix

clean:
	sudo $(RM) -r /nix
	$(RM) -r ~/.nix-*

distclean: umount-dmg clean
	$(RM) $(NIXDMG)

prepare-dmg: 
	[ -r "$(NIXDMG)" ] || hdiutil create -size 10G -fs "Case-sensitive HFS+" -volname NixStore $(NIXDMG)
	sudo mkdir -p /nix
	sudo chown $$(whoami) /nix

mount-dmg: prepare-dmg
	hdiutil attach $(NIXDMG) -mountpoint /nix

umount-dmg:
	hdiutil detach /nix -force || true

install-nix: mount-dmg
	[ -r "images/$(NIXBIN)" ] || curl -o images/$(NIXBIN) $(NIXURL)
	sudo tar xzfvP images/$(NIXBIN)
	sudo chown -R $$(whoami) /nix
	nix-finish-install
	sudo $(RM) $$(which nix-finish-install)

	@echo
	@echo "*** Now execute and/or add to your shell profile:"
	@echo  source ~/.nix-profile/etc/profile.d/nix.sh
	@echo

update-nix:
	nix-channel --add http://nixos.org/channels/nixpkgs-unstable
	nix-channel --add http://nixos.org/channels/nixos-unstable
	nix-channel --add http://hydra.nixos.org/project/nixops/channel/latest
	nix-channel --update
	nix-env -i nix

	@echo
	@echo "*** Now execute and/or add to your shell profile:"
	@echo  export NIX_PATH=/nix/var/nix/profiles/per-user/$$(whoami)/channels/nixos
	@echo

install-nixops:
	nix-env -i nixops

install-nixops-dev:
	[ -r "nixops" ] || git clone git://github.com/NixOS/nixops.git
	cd nixops \
	  && nix-build release.nix -A build.x86_64-darwin \
	  && nix-env -i $$(readlink result)

## configure and manipulate VMs

ports-%: ## stem is VM name; VM must be stopped
	nixops stop -d $*
	VBoxManage modifyvm "$$(nixops info --plain -d $* | cut -f 4)" \
	  --natpf1 "ssh,tcp,,2222,,22"
	VBoxManage modifyvm "$$(nixops info --plain -d $* | cut -f 4)" \
	  --natpf1 "www,tcp,,8080,,80"

create-mirage-www:
	nixops create ./nixes/mirage.nix ./nixes/mirage-vbox.nix -d mirage
ssh-%:
	nixops ssh $*

deploy-%:
	nixops deploy -d $*
start-%:
	nixops start -d $*
stop-%:
	nixops stop -d $*

