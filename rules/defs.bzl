def _nixpkgs_bundle_impl(repository_ctx):
    repository_ctx.file(
        "BUILD.bazel",
        executable = False,
        content = """\
package(default_visibility = ["//visibility:public"])
alias(
  name = "{target}",
  actual = select({config_package_map}),
)
""".format(
            target = repository_ctx.attr.target,
            config_package_map = repository_ctx.attr.config_package_map,
        ),
    )


nixpkgs_bundle = repository_rule(
    implementation = _nixpkgs_bundle_impl,
    attrs = {
        "config_package_map": attr.string_dict(default = {}),
        "target": attr.string(),
    },
)
