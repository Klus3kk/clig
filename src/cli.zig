const std = @import("std");
const compress = @import("compress");
const decompress = @import("decompress");

pub fn handle(args: [][]const u8) !void {
    if (args.len < 2) {
        printHelp();
        return;
    }
    const command = args[1];
    if (std.mem.eql(u8, command, "compress")) {
        if (args.len < 4) {
            std.debug.print("Usage: clig compress <input_file> <output_file>\n", .{});
            return;
        }
        try compress.compress(args[2], args[3]);
    } else if (std.mem.eql(u8, command, "decompress")) {
        if (args.len < 4) {
            std.debug.print("Usage: clig decompress <input_file> <output_file>\n", .{});
            return;
        }
        try decompress.decompress(args[2], args[3]);
    } else {
        printHelp();
    }
}

fn printHelp() void {
    std.debug.print(
        "clig: Your small file compressor c: \n -------------- \n Usage: compress <input_file> <output_file>\n decompress <input_file> <output_file>\n",
        .{},
    );
}