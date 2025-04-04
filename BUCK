load("@prelude//toolchains:python.bzl", "system_python_bootstrap_toolchain", "system_python_toolchain")

load("blender.bzl", "system_blender_toolchain", "blender_archive")

system_python_bootstrap_toolchain(
    name = "python_bootstrap",
    visibility = ["PUBLIC"],
)

[blender_archive(
    name = "blender-archive-" + info[0],
    version = "4.4.0",
    suffix = info[0] + info[1],
    sha256 = info[2],
) for info in [
    ["windows-arm64", ".zip", "4c8ecd0a3d77d66d7f75da38ac7c38147149656980adbd25a543e4ad490eb89f"],
    ["windows-x64", ".zip", "1a603c06d67ef5ae4fae2e5991742a183af525e2f4162e0e5a8c5d010ba0119e"],
    ["macos-arm64", ".dmg", "c3a1192d36d6202cd233081a54391c5778f3dd7aa3ca5af077f641e87a412104"],
    ["macos-x64", ".dmg", "e387e88b569afd0c569da0ff6b0615a882615f3047d94633cc87b288a4b09c54"],
    ["linux-x64", ".tar.xz", "b4a74463677618d09621332ddbd62baa1a3ed06a11818714f6c5f1c7f31a15c6"],
]]

# blender_toolchain(
#     name = "blender",
#     archive = select({
#         "config//os:linux": select({
#             "config//cpu:x86_64": ":blender-archive-linux-x64",
#         }),
#         "config//os:macos": select({
#             "config//cpu:arm64": ":blender-archive-macos-arm64",
#             "config//cpu:x86_64": ":blender-archive-macos-x64",
#         }),
#         "config//os:windows": select({
#             "config//cpu:arm64": ":blender-archive-windows-arm64",
#             "config//cpu:x86_64": ":blender-archive-windows-x64",
#         }),
#     }),
#     visibility = ["PUBLIC"],
# )

system_blender_toolchain(
    name = "blender",
    visibility = ["PUBLIC"],
)