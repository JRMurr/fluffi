const std = @import("std");

const Rust = struct {
    pub extern fn rust_add(left: u64, right: u64) u64;
};

pub fn main() !void {
    const add_res = Rust.rust_add(10, 45);
    std.debug.print("calling rust {}\n", .{add_res});
}
