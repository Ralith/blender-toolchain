load("@toolchains//blender.bzl", "BlenderToolchainInfo")

def impl(ctx: AnalysisContext) -> list[Provider]:
    basename = ctx.attrs.src.basename.removesuffix(".blend")
    prefab = ctx.actions.declare_output(basename + ".prefab.toml")
    glb = ctx.actions.declare_output(basename + ".glb")
    toolchain = ctx.attrs._toolchain[BlenderToolchainInfo]
    action = ctx.actions.run(
        cmd_args(
            [toolchain.blender, ctx.attrs.src, "-b", "--python-expr", "import bpy\nimport sys\nbpy.ops.export_scene.sg(filepath = sys.argv[-1])", "--", prefab.as_output()],
            hidden = [glb.as_output()],
        ),
        category = "asset_compile",
    )
    return [
        DefaultInfo(default_outputs = [prefab, glb]),
    ]

blender_prefab = rule(impl = impl, attrs = {
  "src": attrs.source(),
  "_toolchain": attrs.default_only(attrs.toolchain_dep(
        default="toolchains//:blender",
        providers=[BlenderToolchainInfo],
    )),
})

def gltf_impl(ctx: AnalysisContext) -> list[Provider]:
    basename = ctx.attrs.src.basename.removesuffix(".blend")
    glb = ctx.actions.declare_output(basename + ".glb")
    toolchain = ctx.attrs._toolchain[BlenderToolchainInfo]
    action = ctx.actions.run(
        cmd_args(
            [toolchain.blender, ctx.attrs.src, "-b", "--python-expr", "import bpy\nimport sys\nbpy.ops.export_scene.gltf(filepath = sys.argv[-1], export_apply=True, use_renderable=True)", "--", glb.as_output()],
        ),
        category = "asset_compile",
    )
    return [
        DefaultInfo(default_outputs = [glb]),
    ]

blender_gltf = rule(impl = gltf_impl, attrs = {
  "src": attrs.source(),
  "_toolchain": attrs.default_only(attrs.toolchain_dep(
        default="toolchains//:blender",
        providers=[BlenderToolchainInfo],
    )),
})
