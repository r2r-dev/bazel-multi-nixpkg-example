workspace(name = "multi-pkg-example")

load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_archive",
)

http_archive(
    name = "bazel_skylib",
    sha256 = "c6966ec828da198c5d9adbaa94c05e3a1c7f21bd012a0b29ba8ddbccb2c93b0d",
    urls = [
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.1.1/bazel-skylib-1.1.1.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

RULES_CC_COMMIT = "68cb652a71e7e7e2858c50593e5a9e3b94e5b9a9"

http_archive(
    name = "rules_cc",
    sha256 = "070e6220f6e695bb2e0d2f11ec8de137661d3700178cff13170c5aebed0b4f08",
    strip_prefix = "rules_cc-%s" % RULES_CC_COMMIT,
    urls = [
        "https://github.com/bazelbuild/rules_cc/archive/%s.tar.gz" % RULES_CC_COMMIT,
    ],
)

RULES_TWEAG_COMMIT = "a388ab60dea07c3fc182453e89ff1a67c9d3eba6"

http_archive(
    name = "io_tweag_rules_nixpkgs",
    sha256 = "6bedf80d6cb82d3f1876e27f2ff9a2cc814d65f924deba14b49698bb1fb2a7f7",
    strip_prefix = "rules_nixpkgs-%s" % RULES_TWEAG_COMMIT,
    urls = ["https://github.com/tweag/rules_nixpkgs/archive/%s.tar.gz" % RULES_TWEAG_COMMIT],
)

load(
    "@io_tweag_rules_nixpkgs//nixpkgs:repositories.bzl",
    "rules_nixpkgs_dependencies",
)

rules_nixpkgs_dependencies()

load(
    "@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl",
    "nixpkgs_cc_configure",
    "nixpkgs_local_repository",
    "nixpkgs_package",
)

nixpkgs_local_repository(
    name = "host_nixpkgs",
    nix_file = "//nix:nixpkgs.nix",
    nix_file_deps = [
        "//:flake.lock",
        "//nix:bazel.nix",
    ],
)

NIX_REPOS = {
    "nixpkgs": "@host_nixpkgs",
}

nixpkgs_cc_configure(
    name = "toolchain-linux-x86_64",
    exec_constraints = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    repositories = NIX_REPOS,
    target_constraints = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
)

nixpkgs_cc_configure(
    name = "toolchain-linux-aarch64",
    exec_constraints = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
    nix_file = "//nix/toolchains:linux_aarch64.nix",
    repositories = NIX_REPOS,
    target_constraints = [
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
)

nixpkgs_package(
    name = "gtest_linux_aarch64",
    attribute_path = "gtest-aarch64-linux",
    build_file_content = """
load("@rules_cc//cc:defs.bzl", "cc_library")
cc_library(name = "gtest", srcs = [ "lib/libgmock.so", "lib/libgtest.so" ], hdrs = glob(["include/gmock/**/*.h", "include/gtest/**/*.h"]), includes = ["include"], visibility=["//visibility:public"])
    """,
    nix_file = "//nix:bazel.nix",
    nix_file_deps = [
        "//:flake.lock",
        "//nix:bazel.nix",
        "//nix:nixpkgs.nix",
    ],
    repositories = NIX_REPOS,
)

nixpkgs_package(
    name = "gtest_linux_x86_64",
    attribute_path = "gtest-x86_64-linux",
    build_file_content = """
load("@rules_cc//cc:defs.bzl", "cc_library")
cc_library(name = "gtest", srcs = [ "lib/libgmock.so", "lib/libgtest.so" ], hdrs = glob(["include/gmock/**/*.h", "include/gtest/**/*.h"]), includes = ["include"], visibility=["//visibility:public"])
    """,
    nix_file = "//nix:bazel.nix",
    nix_file_deps = [
        "//:flake.lock",
        "//nix:bazel.nix",
        "//nix:nixpkgs.nix",
    ],
    repositories = NIX_REPOS,
)

load("//rules:defs.bzl", "nixpkgs_bundle")
nixpkgs_bundle(
    name = "gtest",
    target = "gtest",
    config_package_map = {
        "@multi-pkg-example//config:linux_x86_64": "@gtest_linux_x86_64//:gtest",
        "@multi-pkg-example//config:linux_aarch64": "@gtest_linux_aarch64//:gtest",
    },
)
