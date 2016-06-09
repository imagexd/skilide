from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy

import os
from os.path import expanduser as usr
from os.path import join as pjoin

import subprocess

HALIDE_PATH = usr('~/src/halide-binary')

os.environ['LD_LIBRARY_PATH'] = pjoin(HALIDE_PATH, 'bin')

cmd = 'g++ h_brightness.cpp -g -std=c++11 ' \
      '-I {} -L {} -lHalide -lpthread -ldl -o h_brightness'
cmd = cmd.format(pjoin(HALIDE_PATH, 'include'),
                 pjoin(HALIDE_PATH, 'bin'))

print(cmd)
#subprocess.call(cmd.split())
#subprocess.call('./h_brightness')

ext_modules = cythonize(
    ["brightness.pyx", "h_brightness.cpp"],
    language="c++",
    )

setup(ext_modules=ext_modules)

subprocess.call('x86_64-linux-gnu-g++ -pthread -shared -Wl,-O1 -Wl,-Bsymbolic-functions -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-Bsymbolic-functions -Wl,-z,relro -g -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 h_brightness_compiled.o build/temp.linux-x86_64-3.5/brightness.o'.split())
