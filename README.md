# bazel-multi-nixpkg-example
Build `example/ssl` package for both `x86_64` and `aarch64`, including cross-compiled transitive dependencies from nix
```
bazel build :split_ssl
```
