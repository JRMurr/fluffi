const std = @import("std");

const Rust = struct {
    // https://docs.rust-embedded.org/book/interoperability/rust-with-c.html#linking-and-greater-project-context
    // TODO: look into cbindgen to get header automatically
    pub extern fn rust_add(left: u64, right: u64) u64;
};

pub fn main() !void {
    const add_res = Rust.rust_add(10, 45);
    std.debug.print("calling rust {}\n", .{add_res});
}
