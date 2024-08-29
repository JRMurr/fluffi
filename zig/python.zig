const std = @import("std");
const py = @import("python");

const c_str = [*c]const u8;

pub extern fn PyRun_SimpleString(c_str) void;

// https://github.com/Rexicon226/osmium/blob/e83ac667e006cf3a233c1868f76e57b155ba1739/src/frontend/Python.zig#L72
pub fn Initialize(
    // allocator: std.mem.Allocator,
) !void {
    var config: py.types.PyConfig = undefined;
    py.externs.PyConfig_InitIsolatedConfig(&config);
    defer py.externs.PyConfig_Clear(&config);

    // mute some silly errors that probably do infact matter
    config.pathconfig_warnings = 0;

    var status = py.externs.PyConfig_SetBytesString(
        &config,
        &config.program_name,
        "fluffi".ptr,
    );
    if (py.externs.PyStatus_Exception(status)) {
        py.externs.Py_ExitStatusException(status);
    }

    status = py.externs.PyConfig_Read(&config);
    if (py.externs.PyStatus_Exception(status)) {
        py.externs.Py_ExitStatusException(status);
    }

    // const utf32_path = try utf8ToUtf32Z(
    //     build_options.lib_path,
    //     allocator,
    // );

    // config.module_search_paths_set = 1;
    // _ = externs.PyWideStringList_Append(
    //     &config.module_search_paths,
    //     utf32_path.ptr,
    // );

    std.debug.print("config: {}\n", .{config});
    status = py.externs.Py_InitializeFromConfig(&config);

    if (py.externs.PyStatus_Exception(status)) {
        py.externs.Py_ExitStatusException(status);
    }
    // needs to be a pointer discard because the stack protector gets overrun?
    _ = &status;
}

pub fn basic() !void {
    try Initialize();
    defer std.debug.print("exit: {}\n", .{py.externs.Py_Finalize()});

    // PyRun_SimpleString(
    //     \\ from time import time,ctime\n
    //     \\ print('Today is', ctime(time()))\n
    // );

    PyRun_SimpleString("print('hi')");
}
