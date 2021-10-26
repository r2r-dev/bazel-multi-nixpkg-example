{ crossSystem ? null
, system ? builtins.currentSystem
, pkgs ? import ./nixpkgs.nix { inherit crossSystem system; }
}:
{
  openssl = pkgs.symlinkJoin {
    name = "openssl";
    paths = [ pkgs.openssl.out pkgs.openssl.dev ];
  };
}
