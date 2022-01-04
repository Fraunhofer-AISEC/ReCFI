# Resilient CFI
This project is not maintained. It has been published as part of the following ICISC '21 conference paper:

>Oliver Braunsdorf, Stefan Sessinghaus and Julian Horsch. 2021. Resilient CFI: Compiler-based Attack Origin Tracking with
>Dynamic Taint Analysis. In Proceedings of the 24th International Conference on Information Security and Cryptology (ICISC 2021), 
>Seoul, South Korea, December 1–3, 2021

Note that this repository presents a **prototype** implementation for ReCFI
and are **not** to be used in production.

_Originally, we named our prototype "RCFI" and later had to rename it to "ReCFI". Therefore, the source code has some references to "RCFI"._

## Introduction
ReCFI is an approach for Control Flow Integrity (CFI) that is able to determine the origin of an attack using dynamic taint analysis.  
We implemented ReCFI as an extension of LLVM's Dataflow Sanitizer (DFSan).  
ReCFI has been developed and tested for programs written in the C language, compiled for x86_64 Linux. 

## Building and Testing
In the root directory, there are 2 scripts that can be used to build ReCFI
 - `./debug-build-with-docker.sh` for building ReCFI-enhanced LLVM with enabled debug symbols and assertions etc.
 - `./release-build-with-docker.sh` for building in release mode which builds a more performant compiler

The built ReCFI-enhanced clang compiler is located in `docker-build-debug/bin/clang` (respectively in docker-build-release).
To utilize ReCFI for securing your programs, use clang with the following flags
```
docker-build-debug/bin/clang -g -fsanitize=dataflow -mllvm -dfsan-rcfi-backward -mllvm -dfsan-rcfi-indirect-calls -mllvm -dfsan-rcfi-no-taint-allocas <program>.c -o <program_binary>
```
More flags and their explanation can be found in `llvm/lib/Transforms/Instrumentation/DataFlowSanitizer.cpp` (search for `dfsan-rcfi`).

There is also a collection of simple tests to show usage of ReCFI in the `rcfi-test`directory. They can be invoked using the script `./test-with-docker.sh`
