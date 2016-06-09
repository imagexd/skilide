cimport numpy as cnp
import numpy as np

from libc.stdint cimport uint8_t, int32_t, uint64_t

cdef extern from "h_brightness_compiled.h":
     struct buffer_t:
         uint64_t dev
         uint8_t *host
         int32_t[4] extent
         int32_t[4] stride
         int32_t[4] min
         int32_t elem_size
     int h_brightness_compiled(buffer_t *_input_buffer,
                               uint8_t _offset,
                               buffer_t *_brighter_buffer)

def foo(uint8_t[:, ::1] arr, uint8_t[:, ::1] out, uint8_t n):
    cdef buffer_t b_in
    cdef buffer_t b_out

    b_in.min = [0, 0, 0, 0]
    b_out.min = [0, 0, 0, 0]

    b_in.dev = 0;
    b_out.dev = 0;

    b_in.host = &arr[0, 0]
    b_out.host = &out[0, 0]

#    b_in.stride[0] = arr.strides[0]
#    b_in.stride[1] = arr.strides[1]

    b_in.stride[0] = arr.strides[0]
    b_in.stride[1] = arr.strides[1]

    b_out.stride[0] = out.strides[0]
    b_out.stride[1] = out.strides[1]

    b_in.extent[0] = arr.shape[0]
    b_in.extent[1] = arr.shape[1]
    b_out.extent[0] = out.shape[0]
    b_out.extent[1] = out.shape[1]

    b_in.elem_size = arr.itemsize
    b_out.elem_size = arr.itemsize

    print("C side, input:")
    print("%l", <uint64_t>b_in.host)
    print("C side, output:")
    print("%l", <uint64_t>b_out.host)

    print("b_in")
    print(b_in)
    print("---")
    print("b_out")
    print(b_out)

    h_brightness_compiled(&b_in, n, &b_out)

    return out
