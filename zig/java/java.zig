const std = @import("std");
const JNI = @import("jni.zig");

const java_options = @import("java_options");

pub const CLASS_PATH: []const u8 = java_options.class_path;

pub fn basic() !void {

    // https://docs.oracle.com/en/java/javase/21/docs/specs/jni/invocation.html

    var jvm: *JNI.JavaVM = undefined;
    var env: *JNI.JNIEnv = undefined;

    var options = [_]JNI.JavaVMOption{
        .{ .optionString = @constCast("-Djava.class.path=" ++ CLASS_PATH) },
    };

    var args = JNI.JavaVMInitArgs{
        .version = JNI.JNI_VERSION_21,
        .nOptions = 1,
        .options = &options,
        .ignoreUnrecognized = @intFromBool(false),
    };

    // TODO: error handling
    _ = JNI.JNI_CreateJavaVM(
        &jvm,
        &env,
        &args,
    );

    const class = env.findClass("FluffiTest");

    // javap -s on class file to get the sig string
    const meth_id = env.getStaticMethodId(class, "test_fn", "()V");

    env.callStaticVoidMethod(class, meth_id);
}
