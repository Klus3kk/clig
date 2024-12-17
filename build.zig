const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Main executable
    const exe = b.addExecutable(.{
        .name = "clig",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    // Test compress
    const test_compress = b.addTest(.{
        .root_source_file = b.path("src/test_compress.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_compress.addIncludePath(b.path("src"));

    // Test decompress
    const test_decompress = b.addTest(.{
        .root_source_file = b.path("src/test_decompress.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_decompress.addIncludePath(b.path("src"));

    // Define a step named "test" to run all tests
    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&test_compress.step);
    test_step.dependOn(&test_decompress.step);
}
