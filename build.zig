const std = @import("std");

const Step = std.Build.Step;

fn buildRust(b: *std.Build, exe: *Step.Compile) void {
    const cargo_cmd = b.addSystemCommand(&.{ "cargo", "build", "--release" });
    cargo_cmd.setCwd(b.path("./rust/"));
    // https://github.com/coolaj86/rust-hello-cross-zig
    // cargo_cmd.setEnvironmentVariable("CC", "zig cc");

    // exe.linkLibC();
    exe.addObjectFile(b.path("./rust/target/release/librust.a"));

    exe.step.dependOn(&cargo_cmd.step);
}

fn buildPython(b: *std.Build, exe: *Step.Compile, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) void {
    _ = optimize;
    const cpython_dep = b.dependency("cpython", .{ .optimize = .ReleaseSmall, .target = target });
    // const cpython = cpython_dep.module("cpython");
    const lib_python = cpython_dep.artifact("lib-python");

    exe.linkLibrary(lib_python);

    exe.linkLibCpp(); // When we use python rust libunwind got sad with undefined symbol
    // exe.root_module.addImport("cpython", cpython);
}

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "fluffi",
        .root_source_file = b.path("zig/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    buildPython(b, exe, target, optimize);
    buildRust(b, exe);

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    buildTests(b, target, optimize);
}

fn buildTests(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) void {
    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("zig/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    // test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}

// const lib = b.addStaticLibrary(.{
//     .name = "fluffi",
//     // In this case the main source file is merely a path, however, in more
//     // complicated build scripts, this could be a generated file.
//     .root_source_file = b.path("zig/root.zig"),
//     .target = target,
//     .optimize = optimize,
// });

// // This declares intent for the library to be installed into the standard
// // location when the user invokes the "install" step (the default step when
// // running `zig build`).
// b.installArtifact(lib);
