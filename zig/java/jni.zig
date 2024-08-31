pub const Gen = struct {
    usingnamespace @import("jni_gen.zig");
};

pub const JNI_VERSION_21 = Gen.JNI_VERSION_21;

pub const jint = Gen.jint;

pub const Constansts = struct {
    pub const JNI_FALSE = @as(c_int, 0);
    pub const JNI_TRUE = @as(c_int, 1);
    pub const JNI_OK = @as(c_int, 0);
    pub const JNI_ERR = -@as(c_int, 1);
    pub const JNI_EDETACHED = -@as(c_int, 2);
    pub const JNI_EVERSION = -@as(c_int, 3);
    pub const JNI_ENOMEM = -@as(c_int, 4);
    pub const JNI_EEXIST = -@as(c_int, 5);
    pub const JNI_EINVAL = -@as(c_int, 6);
    pub const JNI_COMMIT = @as(c_int, 1);
    pub const JNI_ABORT = @as(c_int, 2);
};

pub const JavaVM = *const Gen.struct_JNIInvokeInterface_;
pub const JNIEnv = *const Gen.struct_JNINativeInterface_;
pub const JavaVMInitArgs = Gen.struct_JavaVMInitArgs;

pub extern fn JNI_GetDefaultJavaVMInitArgs(args: *Gen.JavaVMInitArgs) jint;
pub extern fn JNI_CreateJavaVM(pvm: *JavaVM, penv: *JNIEnv, args: *JavaVMInitArgs) jint;
