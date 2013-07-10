Mirage / NixOS
==============

follow the makefile:

    make distclean
    make install-nix    ## ...then update environment and profile
    make install-nixops ## ...then update environment and profile

create a nix deployment

    make create-mirage
    make deploy-mirage
    make ports-mirage
    
start installing stuff

    make ssh-mirage-www
    rm -rf ~/.opam && opam init --yes
    . ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

findlib:
wrapping ocamlc in shell script to pass OCAMLFLAGS allows setting libs dir correctly

    mkdir bin
    cat > bin/ocamlc << __EOF
    #!/bin/sh
    /run/current-system/sw/bin/ocamlc \${OCAMLC_FLAGS} "\$*"
    __EOF
    chmod +x bin/ocamlc

    export OCAMLC_FLAGS="-I ~/.nix-profile/lib"
    nix-env -i ncurses
    opam install --yes ocamlfind

lwt:

    nix-env -i libev glibc ## for pthreads
    export C_INCLUDE_PATH=~/.nix-profile/include
    export LIBRARY_PATH=~/.nix-profile/lib
    opam install --yes conf-libev lwt

mirari:
note we need custom `obuild` package to tweak `bootstrap` hashbang line

    opam remote add mirage-dev git://github.com/mor1/opam-repository
    opam install --yes mirari

mirage-www:

    opam install --yes mirage-www

...then run `mir-www` and point a browser in the host at <http://localhost:8080> and you should see the mirage website <http://openmirage.org>.

