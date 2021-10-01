{ system ? builtins.currentSystem
, pkgs ? import ./nixpkgs.nix { inherit system; }
, pkgsArm ? import ./nixpkgs.nix { system = "aarch64-linux"; },
}:
{
  gtest-x86_64-linux = pkgs.symlinkJoin {
    name = "gtest";
    paths = [ pkgs.gtest pkgs.gtest.dev ];
  };
  gtest-aarch64-linux = pkgs.symlinkJoin {
    name = "gtest";
    paths = [ pkgsArm.gtest pkgsArm.gtest.dev ];
  };
}
