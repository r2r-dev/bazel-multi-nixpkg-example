{ 
  crossSystem ? { config = "x86_64-unknown-linux-gnu"; }
, system ? builtins.currentSystem
, ...
}:
let
  flakes_spec = builtins.fromJSON (builtins.readFile ../flake.lock);
  nixpkgs_spec = flakes_spec.nodes.nixpkgs.locked;
  nixpkgs_src = builtins.fetchTarball {
    url =
      "https://github.com/${nixpkgs_spec.owner}/${nixpkgs_spec.repo}/archive/${nixpkgs_spec.rev}.tar.gz";
    sha256 =
      (builtins.replaceStrings [ "sha256-" ] [ "" ] nixpkgs_spec.narHash);
  };
  nixpkgs = import nixpkgs_src {
    inherit system crossSystem;
    config.allowUnfree = true;
    overlays = [ ];
  };
in nixpkgs
