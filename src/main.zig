const std = @import("std");
const c = @cImport({
    @cDefine("WIN32_LEAN_AND_MEAN", "1");
    @cInclude("tensorflow/lite/c/c_api.h");
    @cInclude("tensorflow/lite/delegates/xnnpack/xnnpack_delegate.h");
    @cInclude("string.h");
});

pub fn XNNPACK(num_threads: i32) *c.TfLiteDelegate {
    var options = c.TfLiteXNNPackDelegateOptionsDefault();
    options.num_threads = num_threads;
    return c.TfLiteXNNPackDelegateCreate(&options);
}

test "test delegate" {
    _ = XNNPACK(0);
}
