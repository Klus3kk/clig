const std = @import("std");
const decompress = @import("decompress.zig");

test "decompress function should work" {
    try decompress.decompress("test_output.zigc", "test_recovered.txt");
    // TODO: Add file verification logic
}
