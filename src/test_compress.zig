const std = @import("std");
const compress = @import("compress.zig");

test "compress function should work" {
    try compress.compress("test_input.txt", "test_output.zigc");
    // TODO: Add file verification logic
}
