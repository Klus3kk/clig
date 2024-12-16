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

    // Test setup
    const test_compress = b.addTest(.{
        .root_source_file = b.path("tests/test_compress.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(test_compress);

    const test_decompress = b.addTest(.{
        .root_source_file = b.path("tests/test_decompress.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(test_decompress);
}
