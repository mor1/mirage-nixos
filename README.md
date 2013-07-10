Mirage / NixOS
==============

follow the makefile:

    make distclean
    make install-nix
    ## ...then update environment and profile
    make install-nixops
    ## ...then update environment and profile

create a nix deployment

    make create-mirage
    make deploy-mirage
    
start installing stuff

    rm -rf ~/.opam && opam init --yes
    . /root/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
    opam install mirage-www


findlib:
wrapping ocamlc in shell script to pass OCAMLFLAGS allows setting libs dir correctly

    mkdir bin
    cat > bin/ocamlc << __EOF
    > #!/bin/sh
    > /run/current-system/sw/bin/ocamlc \${OCAMLC_FLAGS} "\$*"
    > __EOF
    chmod +x bin/ocamlc

    export OCAMLC_FLAGS="-I ~/.nix-profile/lib"

    nix-env -i ncurses



lwt:

    nix-env -i  glibc ## for pthreads
    export PTHREAD_CFLAGS=-L/root/.nix-profile/lib
    export PTHREAD_LIB=-L/root/.nix-profile/lib

    export LIBEV_CFLAGS=-L/root/.nix-profile/lib
    export LIBEV_LIB=-L/root/.nix-profile/lib
    
    opam install --yes conf-libev lwt
