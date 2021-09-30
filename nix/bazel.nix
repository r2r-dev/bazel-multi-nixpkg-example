{ system ? builtins.currentSystem
, pkgs ? import ./nixpkgs.nix { inherit system; }, }:
{
  gtest = pkgs.symlinkJoin {
    name = "gtest";
    paths = [ pkgs.gtest pkgs.gtest.dev ];
  };
}
