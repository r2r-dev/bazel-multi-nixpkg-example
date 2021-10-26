# bazel-multi-nixpkg-example
Example of building a Bazel target against multiple execution architectures with support for transitioning on both internal and external, nix-provided packages.

1. Build `example/ssl` package for `x86_64`
```
bazel run //example:ssl --platforms=//platforms:x86_64-linux
```

2. Build `example/ssl` package for `aarch64-linux`
```
bazel run //example:ssl --platforms=//platforms:aarch64-linux
```

3. Build `example/ssl` package for both `x86_64` and `aarch64` by transitioning on `--platform` flag
```
bazel build :split_ssl
```
