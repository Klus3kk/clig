const std = @import("std");

pub fn decompress(input_file: []const u8, output_file: []const u8) !void {
    const allocator = std.heap.page_allocator;

    // Open input file
    var input = try std.fs.cwd().openFile(input_file, .{});
    defer input.close();

    const input_size = (try input.stat()).size;

    var reader = input.reader();
    const content = try reader.readAllAlloc(allocator, 1 << 20); // Read up to 1MB
    defer allocator.free(content);

    // Define dictionary (reverse of compression)
    const dictionary = [_]struct { u8, []const u8 }{
        .{ '\x01', "the" }, // Token 0x01 → "the"
        .{ '\x02', "and" }, // Token 0x02 → "and"
        .{ '\x03', " " }, // Token 0x03 → Space
        .{ '\x04', "\n" }, // Token 0x04 → Newline
    };

    var output_content = try std.ArrayList(u8).initCapacity(allocator, content.len);
    defer output_content.deinit();

    var i: usize = 0;
    while (i < content.len) {
        if (content[i] == 0x05) { // RLE marker detected
            if (i + 2 >= content.len) return error.InvalidInput; // Ensure enough bytes follow

            const char = content[i + 1];
            const run_length = content[i + 2];
            try output_content.appendNTimes(char, run_length);
            i += 3; // Skip RLE marker, char, and length
        } else {
            var replaced = false;

            // Dictionary replacement
            for (dictionary) |entry| {
                if (content[i] == entry[0]) {
                    try output_content.appendSlice(entry[1]);
                    replaced = true;
                    break;
                }
            }

            if (!replaced) {
                try output_content.append(content[i]); // Append raw character
            }
            i += 1;
        }
    }

    // Write decompressed file
    var output = try std.fs.cwd().createFile(output_file, .{ .truncate = true });
    defer output.close();
    try output.writeAll(output_content.items);

    const output_size = output_content.items.len;

    std.debug.print(
        "Decompressed {s} to {s}\nOriginal size: {d} bytes\nDecompressed size: {d} bytes\n",
        .{ input_file, output_file, input_size, output_size },
    );
}
