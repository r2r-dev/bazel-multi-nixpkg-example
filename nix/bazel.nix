{ system ? builtins.currentSystem
, pkgs ? import ./nixpkgs.nix { inherit system; }
}:
{
  openssl = pkgs.symlinkJoin {
    name = "openssl";
    paths = [ pkgs.openssl.out pkgs.openssl.dev ];
  };
}
