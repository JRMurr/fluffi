const std = @import("std");
const JNI = @import("jni.zig");

const java_options = @import("java_options");

pub const CLASS_PATH: []const u8 = java_options.class_path;

pub fn basic() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();

    // https://docs.oracle.com/en/java/javase/21/docs/specs/jni/invocation.html

    var jvm: JNI.JavaVM = undefined;
    var env: JNI.JNIEnv = undefined;

    // const class_path_opt = JNI.JavaVMOption{
    //     // TODO: real class path
    //     .optionString = @constCast("-Djava.class.path=/usr/lib/java"),
    // };

    // const options = [_]JNI.JavaVMOption{class_path_opt};

    // const opt_slice = allocator.dupeZ(JNI.JavaVMOption, &options);

    // const args = JNI.JavaVMInitArgs{
    //     .version = JNI.JNI_VERSION_21,
    //     .nOptions = 1,
    //     .options = opt_slice,
    //     .ignoreUnrecognized = false,
    // };

    var options = [_]JNI.JavaVMOption{
        .{ .optionString = @constCast("-Djava.class.path=" ++ CLASS_PATH) },
    };

    var args = JNI.JavaVMInitArgs{
        .version = JNI.JNI_VERSION_21,
        .nOptions = 1,
        .options = &options,
        .ignoreUnrecognized = @intFromBool(false),
    };

    const create_res = JNI.JNI_CreateJavaVM(&jvm, &env, &args);

    std.debug.print("create_res: {}\n", .{create_res});

    // std.debug.print("env: {}\n", .{env});

    const class = env.FindClass(&env, "FluffiTest");

    std.debug.print("class: {any}\n", .{class});

    // // javap -s on class file to get the sig string
    // const method_id = env.GetStaticMethodID(&env, class, "test_fn", "()V");

    // env.CallStaticVoidMethod(&env, class, method_id);
}
