const std = @import("std");

const Rust = @import("rust.zig");
const Python = @import("python.zig");

pub fn main() !void {
    const add_res = Rust.rust_add(10, 45);
    std.debug.print("calling rust {}\n", .{add_res});

    Python.basic();
}
