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

def _transition_impl(settings, attr):
    if len(attr.platforms) == 0:
        return settings

    split = dict()
    for p in attr.platforms:
        split[p] = {
            "//flag:platform": p,
        }
    return split

_transitive_options = [
    "//flag:%s" % o
    for o in [
        "platform",
    ]
]

_base_transition = transition(
    implementation = _transition_impl,
    inputs = _transitive_options,
    outputs = _transitive_options,
)

transitions = struct(
    rule_transition = _base_transition,
)

def _impl(ctx):
    return []

_derive = rule(
    implementation = _impl,
    attrs = {
        "platforms": attr.string_list(default = []),
        "targets": attr.label_list(cfg = transitions.rule_transition),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

rules = struct(
    derive = _derive,
)
