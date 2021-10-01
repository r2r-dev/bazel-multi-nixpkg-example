def _nixpkgs_bundle_impl(repository_ctx):
    build_file = ""
    for target in repository_ctx.attr.targets:
        config_target_map = dict()

        for config, package in repository_ctx.attr.config_package_map.items():
            config_target_map[config] = "{p}//:{t}".format(p = package, t = target)

        build_file += """\
alias(
    name = "{t}",
    actual = select({ctm}),
    visibility= ["//visibility:public"]
)
""".format(
            t = target,
            ctm = config_target_map,
        )

    repository_ctx.file(
        "BUILD.bazel",
        executable = False,
        content = build_file,
    )

nixpkgs_bundle = repository_rule(
    implementation = _nixpkgs_bundle_impl,
    attrs = {
        "config_package_map": attr.string_dict(default = {}),
        "targets": attr.string_list(default = []),
    },
)
