# bazel-multi-nixpkg-example
![graph](assets/graph.png)

Build `gtest` package for both `x86_64` and `aarch64`
```
bazel build :split_gtest
```
