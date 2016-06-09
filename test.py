from brightness import foo
import numpy as np

x = np.arange(12, dtype=np.uint8).reshape((3, 4))
out = np.zeros_like(x)
print("Python side, input:")
print(x.__array_interface__)
print("Python side, output:")
print(out.__array_interface__)
print(foo(x, out, 3))
print("output:")
print(out)
