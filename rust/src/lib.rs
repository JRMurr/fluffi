#[no_mangle]
pub extern "C" fn rust_add(left: u64, right: u64) -> u64 {
    left + right
}
