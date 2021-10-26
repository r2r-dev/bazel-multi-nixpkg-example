def _transition_impl(settings, attr):
    if len(attr.platforms_systems) == 0:
        return settings

    split = dict()
    for platform, system in attr.platforms_systems.items():
        split[system] = {
            "//flag:nix_system": system,
            "//command_line_option:platforms": platform,
        }
    return split

_transitive_options = [
    "//command_line_option:platforms",
    "//flag:nix_system",
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
        "platforms_systems": attr.string_dict(),
        "targets": attr.label_list(cfg = transitions.rule_transition),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

rules = struct(
    derive = _derive,
)
