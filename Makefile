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

ISOVER = nixos-minimal-0.2pre4761_4a40a1f-c9208b9
ISO = $(ISOVER)-x86_64-linux.iso
URL = http://nixos.org/releases/nixos/$(subst minimal-,,$(ISOVER))/$(ISO)

.PHONY: configure iso/$(ISO) distclean build
DEBUG ?= 
FLAGS ?= 

VAGRANT = bundle exec vagrant
VEEWEE = bundle exec veewee

# ENVIRONMENT:
# aenv PATH ~/.rvm/bin
#  && aenv PATH ~/.rvm/gems/ruby-1.9.3-p125/bin
#  && [ -s "$HOME/.rvm/scripts/rvm" ]
#  && source "$HOME/.rvm/scripts/rvm"
#  && rvm use 1.9.3@global'

configure: Gemfile iso/$(ISO)

Gemfile:
	gem install bundle
	bundle init
	echo 'gem "vagrant", "1.0.7"' >> Gemfile
	echo 'gem "veewee", "0.3.7"' >> Gemfile
	bundle

iso/$(ISO):
	[ ! -d 'iso' ] && mkdir iso ; cd iso ; wget -c $(URL) ; cd ..

build:
	$(VEEWEE) vbox build 'nixos64' --auto $(FLAGS)
	# $(VEEWEE) vbox validate 'nixos64'
	$(VAGRANT) basebox export 'nixos64' --force
	[ ! -d 'box' ] && mkdir box ; cd box ; mv ../*.box . ; cd ..

distclean:
	$(RM) -r iso/ Gemfile
