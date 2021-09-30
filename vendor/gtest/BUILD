alias(
    name = "gtest",
    actual = select({
        "@multi-pkg-example//config:linux_x86_64": "@gtest_linux_x86_64//:gtest",
        "@multi-pkg-example//config:linux_aarch64": "@gtest_linux_aarch64//:gtest",
    }),
)

