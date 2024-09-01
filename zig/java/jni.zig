pub const Gen = struct {
    usingnamespace @import("jni_gen.zig");
};
// https://docs.oracle.com/en/java/javase/21/docs/specs/jni/index.html
pub const JNI_VERSION_21 = Gen.JNI_VERSION_21;

pub const jint = c_int;
pub const jlong = c_long;
pub const jbyte = i8;
pub const jboolean = u8;
pub const jchar = c_ushort;
pub const jshort = c_short;
pub const jfloat = f32;
pub const jdouble = f64;
pub const jsize = jint;
pub const jobject = Gen.jobject;
pub const jobjectRefType = Gen.jobjectRefType;
pub const jclass = jobject;
pub const jthrowable = jobject;
pub const jstring = jobject;
pub const jarray = jobject;
pub const jbooleanArray = jarray;
pub const jbyteArray = jarray;
pub const jcharArray = jarray;
pub const jshortArray = jarray;
pub const jintArray = jarray;
pub const jlongArray = jarray;
pub const jfloatArray = jarray;
pub const jdoubleArray = jarray;
pub const jobjectArray = jarray;
pub const jweak = jobject;
pub const jvalue = Gen.jvalue;

pub const jmethodID = Gen.jmethodID;
pub const jfieldID = Gen.jfieldID;

pub const JNINativeMethod = Gen.JNINativeMethod;

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

pub const JNIVersion = packed struct {
    minor: u16,
    major: u16,
};

// https://github.com/zig-java/jui/blob/main/src/types.zig
pub const JNIEnv = extern struct {
    const Self = @This();

    interface: *const struct_JNINativeInterface_,

    pub fn getJNIVersion(self: *Self) JNIVersion {
        const version = self.interface.GetVersion(self);
        return @bitCast(version);
    }

    pub fn findClass(self: *Self, class_name: [*:0]const u8) jclass {
        return self.interface.FindClass(self, class_name);
    }

    pub fn getStaticMethodId(self: *Self, class: jclass, meth_name: [*:0]const u8, sig: [*:0]const u8) jmethodID {
        return self.interface.GetStaticMethodID(self, class, meth_name, sig);
    }

    // TODO: make call static/normal method wrapper for all types with args

    pub fn callStaticVoidMethod(self: *Self, class: jclass, method_id: jmethodID) void {
        return self.interface.CallStaticVoidMethod(self, class, method_id);
    }
};

pub const JavaVM = extern struct {
    const Self = @This();

    interface: *const JNIInvokeInterface,
};

const JNIInvokeInterface = extern struct {
    reserved0: ?*anyopaque,
    reserved1: ?*anyopaque,
    reserved2: ?*anyopaque,

    DestroyJavaVM: *const fn ([*c]JavaVM) callconv(.C) jint,
    AttachCurrentThread: *const fn ([*c]JavaVM, [*c]?*anyopaque, ?*anyopaque) callconv(.C) jint,
    DetachCurrentThread: *const fn ([*c]JavaVM) callconv(.C) jint,
    GetEnv: *const fn ([*c]JavaVM, [*c]?*anyopaque, jint) callconv(.C) jint,
    AttachCurrentThreadAsDaemon: *const fn ([*c]JavaVM, [*c]?*anyopaque, ?*anyopaque) callconv(.C) jint,
};

pub const JavaVMOption = Gen.struct_JavaVMOption;

pub const JavaVMInitArgs = extern struct {
    version: jint = JNI_VERSION_21,
    nOptions: jint,
    options: [*]JavaVMOption,
    ignoreUnrecognized: jboolean,
};

pub extern fn JNI_GetDefaultJavaVMInitArgs(args: *Gen.JavaVMInitArgs) jint;
// pub extern fn JNI_CreateJavaVM(pvm: **JavaVM_, penv: [*c]*anyopaque, args: *JavaVMInitArgs) jint;
pub extern fn JNI_CreateJavaVM(**JavaVM, **JNIEnv, *anyopaque) callconv(.C) jint;

pub const struct_JNINativeInterface_ = extern struct {
    reserved0: ?*anyopaque,
    reserved1: ?*anyopaque,
    reserved2: ?*anyopaque,
    reserved3: ?*anyopaque,
    GetVersion: *const fn ([*c]JNIEnv) callconv(.C) jint,
    DefineClass: *const fn ([*c]JNIEnv, [*c]const u8, jobject, [*c]const jbyte, jsize) callconv(.C) jclass,
    // FindClass: *const fn ([*c]const u8) callconv(.C) jclass,
    FindClass: *const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jclass,
    FromReflectedMethod: *const fn ([*c]JNIEnv, jobject) callconv(.C) jmethodID,
    FromReflectedField: *const fn ([*c]JNIEnv, jobject) callconv(.C) jfieldID,
    ToReflectedMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, jboolean) callconv(.C) jobject,
    GetSuperclass: *const fn ([*c]JNIEnv, jclass) callconv(.C) jclass,
    IsAssignableFrom: *const fn ([*c]JNIEnv, jclass, jclass) callconv(.C) jboolean,
    ToReflectedField: *const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) jobject,
    Throw: *const fn ([*c]JNIEnv, jthrowable) callconv(.C) jint,
    ThrowNew: *const fn ([*c]JNIEnv, jclass, [*c]const u8) callconv(.C) jint,
    ExceptionOccurred: *const fn ([*c]JNIEnv) callconv(.C) jthrowable,
    ExceptionDescribe: *const fn ([*c]JNIEnv) callconv(.C) void,
    ExceptionClear: *const fn ([*c]JNIEnv) callconv(.C) void,
    FatalError: *const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) void,
    PushLocalFrame: *const fn ([*c]JNIEnv, jint) callconv(.C) jint,
    PopLocalFrame: *const fn ([*c]JNIEnv, jobject) callconv(.C) jobject,
    NewGlobalRef: *const fn ([*c]JNIEnv, jobject) callconv(.C) jobject,
    DeleteGlobalRef: *const fn ([*c]JNIEnv, jobject) callconv(.C) void,
    DeleteLocalRef: *const fn ([*c]JNIEnv, jobject) callconv(.C) void,
    IsSameObject: *const fn ([*c]JNIEnv, jobject, jobject) callconv(.C) jboolean,
    NewLocalRef: *const fn ([*c]JNIEnv, jobject) callconv(.C) jobject,
    EnsureLocalCapacity: *const fn ([*c]JNIEnv, jint) callconv(.C) jint,
    AllocObject: *const fn ([*c]JNIEnv, jclass) callconv(.C) jobject,
    NewObject: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject,
    NewObjectV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jobject,
    NewObjectA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject,
    GetObjectClass: *const fn ([*c]JNIEnv, jobject) callconv(.C) jclass,
    IsInstanceOf: *const fn ([*c]JNIEnv, jobject, jclass) callconv(.C) jboolean,
    GetMethodID: *const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID,
    CallObjectMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jobject,
    CallObjectMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jobject,
    CallObjectMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jobject,
    CallBooleanMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jboolean,
    CallBooleanMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jboolean,
    CallBooleanMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jboolean,
    CallByteMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jbyte,
    CallByteMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jbyte,
    CallByteMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jbyte,
    CallCharMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jchar,
    CallCharMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jchar,
    CallCharMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jchar,
    CallShortMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jshort,
    CallShortMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jshort,
    CallShortMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jshort,
    CallIntMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jint,
    CallIntMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jint,
    CallIntMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jint,
    CallLongMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jlong,
    CallLongMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jlong,
    CallLongMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jlong,
    CallFloatMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jfloat,
    CallFloatMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jfloat,
    CallFloatMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jfloat,
    CallDoubleMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jdouble,
    CallDoubleMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jdouble,
    CallDoubleMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jdouble,
    CallVoidMethod: *const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) void,
    CallVoidMethodV: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) void,
    CallVoidMethodA: *const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) void,
    CallNonvirtualObjectMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jobject,
    CallNonvirtualObjectMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jobject,
    CallNonvirtualObjectMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject,
    CallNonvirtualBooleanMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jboolean,
    CallNonvirtualBooleanMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jboolean,
    CallNonvirtualBooleanMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean,
    CallNonvirtualByteMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jbyte,
    CallNonvirtualByteMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jbyte,
    CallNonvirtualByteMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte,
    CallNonvirtualCharMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jchar,
    CallNonvirtualCharMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jchar,
    CallNonvirtualCharMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar,
    CallNonvirtualShortMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jshort,
    CallNonvirtualShortMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jshort,
    CallNonvirtualShortMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort,
    CallNonvirtualIntMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jint,
    CallNonvirtualIntMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jint,
    CallNonvirtualIntMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint,
    CallNonvirtualLongMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jlong,
    CallNonvirtualLongMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jlong,
    CallNonvirtualLongMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong,
    CallNonvirtualFloatMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jfloat,
    CallNonvirtualFloatMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jfloat,
    CallNonvirtualFloatMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat,
    CallNonvirtualDoubleMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jdouble,
    CallNonvirtualDoubleMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jdouble,
    CallNonvirtualDoubleMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble,
    CallNonvirtualVoidMethod: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) void,
    CallNonvirtualVoidMethodV: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) void,
    CallNonvirtualVoidMethodA: *const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) void,
    GetFieldID: *const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID,
    GetObjectField: *const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jobject,
    GetBooleanField: *const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jboolean,
    GetByteField: *const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jbyte,
    GetCharField: *const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jchar,
    GetShortField: *const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jshort,
    GetIntField: *const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jint,
    GetLongField: *const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jlong,
    GetFloatField: *const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jfloat,
    GetDoubleField: *const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jdouble,
    SetObjectField: *const fn ([*c]JNIEnv, jobject, jfieldID, jobject) callconv(.C) void,
    SetBooleanField: *const fn ([*c]JNIEnv, jobject, jfieldID, jboolean) callconv(.C) void,
    SetByteField: *const fn ([*c]JNIEnv, jobject, jfieldID, jbyte) callconv(.C) void,
    SetCharField: *const fn ([*c]JNIEnv, jobject, jfieldID, jchar) callconv(.C) void,
    SetShortField: *const fn ([*c]JNIEnv, jobject, jfieldID, jshort) callconv(.C) void,
    SetIntField: *const fn ([*c]JNIEnv, jobject, jfieldID, jint) callconv(.C) void,
    SetLongField: *const fn ([*c]JNIEnv, jobject, jfieldID, jlong) callconv(.C) void,
    SetFloatField: *const fn ([*c]JNIEnv, jobject, jfieldID, jfloat) callconv(.C) void,
    SetDoubleField: *const fn ([*c]JNIEnv, jobject, jfieldID, jdouble) callconv(.C) void,
    GetStaticMethodID: *const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID,
    CallStaticObjectMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject,
    CallStaticObjectMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jobject,
    CallStaticObjectMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject,
    CallStaticBooleanMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jboolean,
    CallStaticBooleanMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jboolean,
    CallStaticBooleanMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean,
    CallStaticByteMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jbyte,
    CallStaticByteMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jbyte,
    CallStaticByteMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte,
    CallStaticCharMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jchar,
    CallStaticCharMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jchar,
    CallStaticCharMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar,
    CallStaticShortMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jshort,
    CallStaticShortMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jshort,
    CallStaticShortMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort,
    CallStaticIntMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jint,
    CallStaticIntMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jint,
    CallStaticIntMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint,
    CallStaticLongMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jlong,
    CallStaticLongMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jlong,
    CallStaticLongMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong,
    CallStaticFloatMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jfloat,
    CallStaticFloatMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jfloat,
    CallStaticFloatMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat,
    CallStaticDoubleMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jdouble,
    CallStaticDoubleMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) jdouble,
    CallStaticDoubleMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble,
    CallStaticVoidMethod: *const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) void,
    CallStaticVoidMethodV: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]Gen.struct___va_list_tag_1) callconv(.C) void,
    CallStaticVoidMethodA: *const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) void,
    GetStaticFieldID: *const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID,
    GetStaticObjectField: *const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jobject,
    GetStaticBooleanField: *const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jboolean,
    GetStaticByteField: *const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jbyte,
    GetStaticCharField: *const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jchar,
    GetStaticShortField: *const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jshort,
    GetStaticIntField: *const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jint,
    GetStaticLongField: *const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jlong,
    GetStaticFloatField: *const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jfloat,
    GetStaticDoubleField: *const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jdouble,
    SetStaticObjectField: *const fn ([*c]JNIEnv, jclass, jfieldID, jobject) callconv(.C) void,
    SetStaticBooleanField: *const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) void,
    SetStaticByteField: *const fn ([*c]JNIEnv, jclass, jfieldID, jbyte) callconv(.C) void,
    SetStaticCharField: *const fn ([*c]JNIEnv, jclass, jfieldID, jchar) callconv(.C) void,
    SetStaticShortField: *const fn ([*c]JNIEnv, jclass, jfieldID, jshort) callconv(.C) void,
    SetStaticIntField: *const fn ([*c]JNIEnv, jclass, jfieldID, jint) callconv(.C) void,
    SetStaticLongField: *const fn ([*c]JNIEnv, jclass, jfieldID, jlong) callconv(.C) void,
    SetStaticFloatField: *const fn ([*c]JNIEnv, jclass, jfieldID, jfloat) callconv(.C) void,
    SetStaticDoubleField: *const fn ([*c]JNIEnv, jclass, jfieldID, jdouble) callconv(.C) void,
    NewString: *const fn ([*c]JNIEnv, [*c]const jchar, jsize) callconv(.C) jstring,
    GetStringLength: *const fn ([*c]JNIEnv, jstring) callconv(.C) jsize,
    GetStringChars: *const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar,
    ReleaseStringChars: *const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void,
    NewStringUTF: *const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jstring,
    GetStringUTFLength: *const fn ([*c]JNIEnv, jstring) callconv(.C) jsize,
    GetStringUTFChars: *const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const u8,
    ReleaseStringUTFChars: *const fn ([*c]JNIEnv, jstring, [*c]const u8) callconv(.C) void,
    GetArrayLength: *const fn ([*c]JNIEnv, jarray) callconv(.C) jsize,
    NewObjectArray: *const fn ([*c]JNIEnv, jsize, jclass, jobject) callconv(.C) jobjectArray,
    GetObjectArrayElement: *const fn ([*c]JNIEnv, jobjectArray, jsize) callconv(.C) jobject,
    SetObjectArrayElement: *const fn ([*c]JNIEnv, jobjectArray, jsize, jobject) callconv(.C) void,
    NewBooleanArray: *const fn ([*c]JNIEnv, jsize) callconv(.C) jbooleanArray,
    NewByteArray: *const fn ([*c]JNIEnv, jsize) callconv(.C) jbyteArray,
    NewCharArray: *const fn ([*c]JNIEnv, jsize) callconv(.C) jcharArray,
    NewShortArray: *const fn ([*c]JNIEnv, jsize) callconv(.C) jshortArray,
    NewIntArray: *const fn ([*c]JNIEnv, jsize) callconv(.C) jintArray,
    NewLongArray: *const fn ([*c]JNIEnv, jsize) callconv(.C) jlongArray,
    NewFloatArray: *const fn ([*c]JNIEnv, jsize) callconv(.C) jfloatArray,
    NewDoubleArray: *const fn ([*c]JNIEnv, jsize) callconv(.C) jdoubleArray,
    GetBooleanArrayElements: *const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean) callconv(.C) [*c]jboolean,
    GetByteArrayElements: *const fn ([*c]JNIEnv, jbyteArray, [*c]jboolean) callconv(.C) [*c]jbyte,
    GetCharArrayElements: *const fn ([*c]JNIEnv, jcharArray, [*c]jboolean) callconv(.C) [*c]jchar,
    GetShortArrayElements: *const fn ([*c]JNIEnv, jshortArray, [*c]jboolean) callconv(.C) [*c]jshort,
    GetIntArrayElements: *const fn ([*c]JNIEnv, jintArray, [*c]jboolean) callconv(.C) [*c]jint,
    GetLongArrayElements: *const fn ([*c]JNIEnv, jlongArray, [*c]jboolean) callconv(.C) [*c]jlong,
    GetFloatArrayElements: *const fn ([*c]JNIEnv, jfloatArray, [*c]jboolean) callconv(.C) [*c]jfloat,
    GetDoubleArrayElements: *const fn ([*c]JNIEnv, jdoubleArray, [*c]jboolean) callconv(.C) [*c]jdouble,
    ReleaseBooleanArrayElements: *const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean, jint) callconv(.C) void,
    ReleaseByteArrayElements: *const fn ([*c]JNIEnv, jbyteArray, [*c]jbyte, jint) callconv(.C) void,
    ReleaseCharArrayElements: *const fn ([*c]JNIEnv, jcharArray, [*c]jchar, jint) callconv(.C) void,
    ReleaseShortArrayElements: *const fn ([*c]JNIEnv, jshortArray, [*c]jshort, jint) callconv(.C) void,
    ReleaseIntArrayElements: *const fn ([*c]JNIEnv, jintArray, [*c]jint, jint) callconv(.C) void,
    ReleaseLongArrayElements: *const fn ([*c]JNIEnv, jlongArray, [*c]jlong, jint) callconv(.C) void,
    ReleaseFloatArrayElements: *const fn ([*c]JNIEnv, jfloatArray, [*c]jfloat, jint) callconv(.C) void,
    ReleaseDoubleArrayElements: *const fn ([*c]JNIEnv, jdoubleArray, [*c]jdouble, jint) callconv(.C) void,
    GetBooleanArrayRegion: *const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]jboolean) callconv(.C) void,
    GetByteArrayRegion: *const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]jbyte) callconv(.C) void,
    GetCharArrayRegion: *const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]jchar) callconv(.C) void,
    GetShortArrayRegion: *const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]jshort) callconv(.C) void,
    GetIntArrayRegion: *const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]jint) callconv(.C) void,
    GetLongArrayRegion: *const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]jlong) callconv(.C) void,
    GetFloatArrayRegion: *const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]jfloat) callconv(.C) void,
    GetDoubleArrayRegion: *const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]jdouble) callconv(.C) void,
    SetBooleanArrayRegion: *const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]const jboolean) callconv(.C) void,
    SetByteArrayRegion: *const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]const jbyte) callconv(.C) void,
    SetCharArrayRegion: *const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]const jchar) callconv(.C) void,
    SetShortArrayRegion: *const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]const jshort) callconv(.C) void,
    SetIntArrayRegion: *const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]const jint) callconv(.C) void,
    SetLongArrayRegion: *const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]const jlong) callconv(.C) void,
    SetFloatArrayRegion: *const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]const jfloat) callconv(.C) void,
    SetDoubleArrayRegion: *const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]const jdouble) callconv(.C) void,
    RegisterNatives: *const fn ([*c]JNIEnv, jclass, [*c]const JNINativeMethod, jint) callconv(.C) jint,
    UnregisterNatives: *const fn ([*c]JNIEnv, jclass) callconv(.C) jint,
    MonitorEnter: *const fn ([*c]JNIEnv, jobject) callconv(.C) jint,
    MonitorExit: *const fn ([*c]JNIEnv, jobject) callconv(.C) jint,
    GetJavaVM: *const fn ([*c]JNIEnv, [*c][*c]JavaVM) callconv(.C) jint,
    GetStringRegion: *const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]jchar) callconv(.C) void,
    GetStringUTFRegion: *const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]u8) callconv(.C) void,
    GetPrimitiveArrayCritical: *const fn ([*c]JNIEnv, jarray, [*c]jboolean) callconv(.C) ?*anyopaque,
    ReleasePrimitiveArrayCritical: *const fn ([*c]JNIEnv, jarray, ?*anyopaque, jint) callconv(.C) void,
    GetStringCritical: *const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar,
    ReleaseStringCritical: *const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void,
    NewWeakGlobalRef: *const fn ([*c]JNIEnv, jobject) callconv(.C) jweak,
    DeleteWeakGlobalRef: *const fn ([*c]JNIEnv, jweak) callconv(.C) void,
    ExceptionCheck: *const fn ([*c]JNIEnv) callconv(.C) jboolean,
    NewDirectByteBuffer: *const fn ([*c]JNIEnv, ?*anyopaque, jlong) callconv(.C) jobject,
    GetDirectBufferAddress: *const fn ([*c]JNIEnv, jobject) callconv(.C) ?*anyopaque,
    GetDirectBufferCapacity: *const fn ([*c]JNIEnv, jobject) callconv(.C) jlong,
    GetObjectRefType: *const fn ([*c]JNIEnv, jobject) callconv(.C) jobjectRefType,
    GetModule: *const fn ([*c]JNIEnv, jclass) callconv(.C) jobject,
    IsVirtualThread: *const fn ([*c]JNIEnv, jobject) callconv(.C) jboolean,
};
