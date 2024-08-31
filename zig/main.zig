const std = @import("std");

const Rust = @import("rust.zig");
const Python = @import("python.zig");
const Java = @import("java/root.zig");

pub fn main() !void {
    const add_res = Rust.rust_add(10, 45);
    std.debug.print("calling rust {}\n", .{add_res});

    try Python.basic();

    try Java.basic();
}
