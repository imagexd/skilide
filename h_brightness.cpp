// Halide tutorial lesson 11: Cross-compilation

// This lesson demonstrates how to use Halide as a cross-compiler to
// generate code for any platform from any platform.

// On linux, you can compile and run it like so:
// g++ lesson_11*.cpp -g -std=c++11 -I ../include -L ../bin -lHalide -lpthread -ldl -o lesson_11
// LD_LIBRARY_PATH=../bin ./lesson_11

// On os x:
// g++ lesson_11*.cpp -g -std=c++11 -I ../include -L ../bin -lHalide -o lesson_11
// DYLD_LIBRARY_PATH=../bin ./lesson_11

// If you have the entire Halide source tree, you can also build it by
// running:
//    make tutorial_lesson_11_cross_compilation
// in a shell with the current directory at the top of the halide
// source tree.

#include "Halide.h"
#include <stdio.h>
using namespace Halide;

int main(int argc, char **argv) {

    // We'll define the simple one-stage pipeline that we used in lesson 10.
    Func brighter;
    Var x, y;

    // Declare the arguments.
    Param<uint8_t> offset;
    ImageParam input(type_of<uint8_t>(), 2);

    std::vector<Argument> args(2);
    args[0] = input;
    args[1] = offset;

    // Define the Func.
    brighter(x, y) = input(x, y) + offset;

    // Schedule it.
    brighter.vectorize(x, 16).parallel(y);

    // The following line is what we did in lesson 10. It compiles an
    // object file suitable for the system that you're running this
    // program on.  For example, if you compile and run this file on
    // 64-bit linux on an x86 cpu with sse4.1, then the generated code
    // will be suitable for 64-bit linux on x86 with sse4.1.
    brighter.compile_to_file("h_brightness_compiled", args);

    printf("Success!\n");
    return 0;
}
