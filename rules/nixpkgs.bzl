load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", _nixpkgs_package = "nixpkgs_package")

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

_nixpkgs_bundle = repository_rule(
    implementation = _nixpkgs_bundle_impl,
    attrs = {
        "config_package_map": attr.string_dict(default = {}),
        "targets": attr.string_list(default = []),
    },
)

def nixpkgs_package(systems = None, targets = [], **kwargs):
    name = kwargs["name"]
    if systems:
        config_package_map = {}
        for key, system in systems.items():
            derived_kwargs = {key: value for (key, value) in kwargs.items()}
            derived_name = name + system["suffix"]
            derived_kwargs["name"] = derived_name
            derived_kwargs["nixopts"] = derived_kwargs.get("nixopts", []) + system["extra_nix_opts"]
            config_package_map[system["config"]] = "@" + derived_name
            _nixpkgs_package(**derived_kwargs)

        _nixpkgs_bundle(
            name = name,
            config_package_map = config_package_map,
            targets = targets,
        )
    else:
        _nixpkgs_package(**kwargs)
