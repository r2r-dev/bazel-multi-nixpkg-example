def _transition_impl(settings, attr):
    if len(attr.systems) == 0:
        return settings

    split = dict()
    for s in attr.systems:
        split[s] = {
            "//flag:system": s,
        }
    return split

_transitive_options = [
    "//flag:%s" % o
    for o in [
        "system",
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
        "systems": attr.string_list(default = []),
        "targets": attr.label_list(cfg = transitions.rule_transition),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

rules = struct(
    derive = _derive,
)
