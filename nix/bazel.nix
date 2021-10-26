{ 
  crossSystem
, system ? builtins.currentSystem
, pkgs ? import ./nixpkgs.nix { inherit system crossSystem; }
}:
{
  openssl = pkgs.symlinkJoin {
    name = "openssl";
    paths = [ pkgs.openssl.out pkgs.openssl.dev ];
  };
}
