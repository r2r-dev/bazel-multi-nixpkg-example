def _transition_impl(settings, attr):
    if len(attr.platforms) == 0:
        return settings

    split = dict()
    for platform in attr.platforms:
        split[platform] = {
            "//command_line_option:platforms": platform,
        }
    return split

_transitive_options = [
    "//command_line_option:platforms",
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
        "platforms": attr.string_list(),
        "targets": attr.label_list(cfg = transitions.rule_transition),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

rules = struct(
    derive = _derive,
)
