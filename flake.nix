{
  description = "Project Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell = (let
        inherit system;
        pkgs = nixpkgs.legacyPackages.${system};
        bazel = pkgs.writeScriptBin "bazel" (''
          #!${pkgs.bash}/bin/bash
          # Set the JAVA_HOME to our JDK
          export JAVA_HOME=${pkgs.jdk8.home}
          export GIT_SSL_CAINFO="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        '' + pkgs.lib.optionalString (pkgs.buildPlatform.libc == "glibc") ''
          export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"
        '' + ''
          exec ${pkgs.bazel_4}/bin/bazel "$@"
        '');
      in pkgs.mkShell {
        buildInputs = with pkgs; [
          perl
          cacert
          coreutils-full
          toybox
          curlFull
          gnutar
          # For Bazel rules
          nixFlakes
          bazel
          bazel-buildtools
        ];
        shellHook = ''
          # patch binary from toybox breaks some of bazel repository rules when running `bazel sync`
          # override path to force use of gnupatch instead
          export PATH="${pkgs.gnupatch}/bin:''${PATH}"
          export WORKSPACE_ROOT="`pwd`"

          # Store debug output in a separate directory
          BAZEL_DEBUG="''${WORKSPACE_ROOT}/bazel-debug"
          if [ ! -d "''${BAZEL_DEBUG}" ]; then mkdir -p "''${BAZEL_DEBUG}"; fi

          source ${pkgs.bash-completion}/etc/profile.d/bash_completion.sh
        '';
      });
    });
}
