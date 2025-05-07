BlenderToolchainInfo = provider(
    fields = {
        "blender": provider_field(RunInfo),
    },
)


def blender_archive(name: str, version: str, suffix: str, sha256: str):
    version_short = ".".join(version.split(".")[:-1])
    native.http_archive(
        name = name,
        urls = ["https://mirror.clarkson.edu/blender/release/Blender" + version_short + "/blender-" + version + "-" + suffix],
        sha256 = sha256,
        strip_prefix = "blender-" + version + "-" + suffix.split(".")[0],
    )

def portable_toolchain_impl(ctx: AnalysisContext) -> list[Provider]:
    extensions = ctx.actions.symlinked_dir("extensions", dict([(x.basename, x) for x in ctx.attrs.extensions]))
    return [
        DefaultInfo(),
        BlenderToolchainInfo(
            blender = RunInfo(args = cmd_args(
                [
                    cmd_args(ctx.attrs.archive[DefaultInfo].default_outputs[0], absolute_suffix = "/blender" + ctx.attrs.exe_suffix),
                    # "--factory-startup",
                    # "--env-system-extensions",
                    # extensions,
                ]
            )),
        )
    ]

blender_toolchain = rule(
    impl = portable_toolchain_impl, 
    attrs = {
        "archive": attrs.exec_dep(),
        "extensions": attrs.list(attrs.exec_dep(), default = []),
        "exe_suffix": attrs.default_only(
            attrs.string(
                default = select({"DEFAULT": "", "config//os:windows": ".exe"})
            )
        )
    },
    is_toolchain_rule = True,
)

def system_toolchain_impl(ctx: AnalysisContext) -> list[Provider]:
    return [
        DefaultInfo(),
        BlenderToolchainInfo(
            blender = RunInfo(args = cmd_args(
                [
                    ctx.attrs.blender,
                    # "--factory-startup",
                    # "--env-system-extensions",
                    # extensions,
                ]
            )),
        )
    ]

system_blender_toolchain = rule(
    impl = system_toolchain_impl, 
    attrs = {
        "blender": attrs.arg(default = "blender"),
    },
    is_toolchain_rule = True,
)