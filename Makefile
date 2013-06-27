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

NIXDMG = nix-store.dmg

NIXBIN = nix-1.5.3-x86_64-darwin.tar.bz2
NIXREV = 5350097
NIXURL = http://hydra.nixos.org/build/$(NIXREV)/download/1/$(NIXBIN)

OPSBIN = nixops-1.0-x86_64-linux.nixpkg
OPSREV = 5426863
OPSURL = http://hydra.nixos.org/build/$(OPSREV)/nix/pkg/$(OPSBIN)

clean:
	sudo $(RM) -r /nix
	$(RM) -r ~/.nix-*

prepare-dmg: 
	[ -r "$(NIXDMG)" ] || hdiutil create -size 10G -fs "Case-sensitive HFS+" -volname NixStore $(NIXDMG)
	sudo mkdir -p /nix
	sudo chown $$(whoami) /nix

mount-dmg:
	hdiutil attach $(NIXDMG) -mountpoint /nix

install-nix:
	[ -r "$(NIXBIN)" ] || curl $(NIXURL)
	sudo tar xzfvP $(NIXBIN)
	sudo chown -R $$(whoami) /nix
	nix-finish-install
	sudo $(RM) $$(which nix-finish-install)
	source ~/.nix-profile/etc/profile.d/nix.sh

update-nix:
	nix-channel --add http://nixos.org/channels/nixpkgs-unstable
	nix-channel --update
	nix-env -i nix

install-nixops:
	# [ -r "nixops" ] || git clone git://github.com/NixOS/nixops.git
	# nix-env -f nixops -i nixops
	nix-install-package --non-interactive --url $(OPSURL)
