const builtin = @import("builtin");
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("zig-tflite", "src/main.zig");
    lib.setBuildMode(mode);
    if (builtin.os.tag == .windows) {
        lib.include_dirs.append(.{ .raw_path = "c:/msys64/mingw64/include" }) catch unreachable;
        lib.lib_paths.append("c:/msys64/mingw64/lib") catch unreachable;
    }
    lib.install();

    const main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);
    if (builtin.os.tag == .windows) {
        main_tests.include_dirs.append(.{ .raw_path = "c:/msys64/mingw64/include" }) catch unreachable;
        main_tests.lib_paths.append("c:/msys64/mingw64/lib") catch unreachable;
    }
    main_tests.linkSystemLibrary("tensorflowlite-delegate_xnnpack");
    main_tests.linkSystemLibrary("c");

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
