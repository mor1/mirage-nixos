{
  mirage-www = { pkgs, ... }: {
   environment.systemPackages = [ 
      pkgs.gnumake
      pkgs.vim
      pkgs.gnum4
      pkgs.gcc
      pkgs.ncurses
      pkgs.glibc
      pkgs.libev
      pkgs.xlibs.makedepend
      pkgs.which
      pkgs.curl
      pkgs.bash
      pkgs.ocaml_4_00_1
      pkgs.ocamlPackages.opam 
    ];

  };
}
