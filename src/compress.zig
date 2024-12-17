const std = @import("std");

pub fn compress(input_file: []const u8, output_file: []const u8) !void {
    const allocator = std.heap.page_allocator;

    // Open input file
    var input = try std.fs.cwd().openFile(input_file, .{});
    defer input.close();

    const input_size = (try input.stat()).size;

    var reader = input.reader();
    const content = try reader.readAllAlloc(allocator, 1 << 20); // Read up to 1MB
    defer allocator.free(content);

    // Define dictionary of common words/sequences
    const dictionary = [_]struct { []const u8, []const u8 }{
        .{ "the", "\x01" }, // Replace "the" with token 0x01
        .{ "and", "\x02" }, // Replace "and" with token 0x02
        .{ " ", "\x03" }, // Replace space with token 0x03
        .{ "\n", "\x04" }, // Replace newline with token 0x04
    };

    var output_content = try std.ArrayList(u8).initCapacity(allocator, content.len);
    defer output_content.deinit();

    var i: usize = 0;
    while (i < content.len) {
        var replaced = false;

        // Dictionary replacement
        for (dictionary) |entry| {
            if (std.mem.startsWith(u8, content[i..], entry[0])) {
                try output_content.appendSlice(entry[1]);
                i += entry[0].len;
                replaced = true;
                break;
            }
        }

        if (!replaced) {
            // RLE for repeated characters
            var run_length: usize = 1;
            while (i + run_length < content.len and content[i] == content[i + run_length]) {
                run_length += 1;
            }

            if (run_length > 3) { // Only encode runs longer than 3
                try output_content.append(0x05); // RLE marker
                try output_content.append(content[i]);
                try output_content.append(@as(u8, @truncate(run_length)));
                i += run_length;
            } else {
                try output_content.append(content[i]);
                i += 1;
            }
        }
    }

    // Write compressed file
    var output = try std.fs.cwd().createFile(output_file, .{ .truncate = true });
    defer output.close();
    try output.writeAll(output_content.items);

    const output_size = output_content.items.len;
    const ratio = @as(f64, @floatFromInt(output_size)) / @as(f64, @floatFromInt(input_size)) * 100;

    std.debug.print(
        "Compressed {s} to {s}\nOriginal size: {d} bytes\nCompressed size: {d} bytes\nCompression Ratio: {d:.2}%\n",
        .{ input_file, output_file, input_size, output_size, ratio },
    );
}
