const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("loomUI", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Define a static library
    const static_lib = b.addLibrary(.{
        .linkage = .static,
        .name = "loomUI",
        .root_module = mod,
    });
    b.installArtifact(static_lib);

    // Define a shared (dynamic) library
    const shared_lib = b.addLibrary(.{
        .linkage = .dynamic,
        .name = "loomUI",
        .root_module = mod,
    });
    b.installArtifact(shared_lib);

    // Creates an executable that will run `test` blocks from the provided module.
    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}
