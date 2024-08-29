const std = @import("std");

const c_str = [*c]const u8;

/// Inits the runtime
pub extern fn Py_Initialize() void;
pub extern fn PyRun_SimpleString(c_str) void;
/// Ends the runtime
pub extern fn Py_FinalizeEx() c_int;

pub fn basic() void {
    Py_Initialize();
    defer std.debug.print("exit: {}\n", .{Py_FinalizeEx()});

    PyRun_SimpleString(
        \\ from time import time,ctime\n
        \\ print('Today is', ctime(time()))\n
    );
}
