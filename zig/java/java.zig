const std = @import("std");

const JNI = @import("jni.zig");

pub fn basic() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();

    // https://docs.oracle.com/javase/7/docs/technotes/guides/jni/spec/invocation.html#wp9502

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

    var args = JNI.JavaVMInitArgs{ .version = JNI.JNI_VERSION_21 };

    _ = JNI.JNI_GetDefaultJavaVMInitArgs(&args);

    _ = JNI.JNI_CreateJavaVM(&jvm, &env, &args);

    std.debug.print("JVM: {}\tENV: {}\n", .{ jvm, env });
}
