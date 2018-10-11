# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=3 -timeline -register-file-stats < %s | FileCheck %s

xor %rax, %rax
mov %rax, %rbx
mov %rbx, %rcx
mov %rcx, %rdx
mov %rdx, %rax

# CHECK:      Iterations:        3
# CHECK-NEXT: Instructions:      15
# CHECK-NEXT: Total Cycles:      12
# CHECK-NEXT: Total uOps:        15

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    1.25
# CHECK-NEXT: IPC:               1.25
# CHECK-NEXT: Block RThroughput: 2.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      0     0.50                        xorq	%rax, %rax
# CHECK-NEXT:  1      1     0.50                        movq	%rax, %rbx
# CHECK-NEXT:  1      1     0.50                        movq	%rbx, %rcx
# CHECK-NEXT:  1      1     0.50                        movq	%rcx, %rdx
# CHECK-NEXT:  1      1     0.50                        movq	%rdx, %rax

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    12
# CHECK-NEXT: Max number of mappings used:         7

# CHECK:      *  Register File #1 -- JFpuPRF:
# CHECK-NEXT:    Number of physical registers:     72
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      *  Register File #2 -- JIntegerPRF:
# CHECK-NEXT:    Number of physical registers:     64
# CHECK-NEXT:    Total number of mappings created: 12
# CHECK-NEXT:    Max number of mappings used:      7

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 2.00   2.00    -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     xorq	%rax, %rax
# CHECK-NEXT: 0.33   0.67    -      -      -      -      -      -      -      -      -      -      -      -     movq	%rax, %rbx
# CHECK-NEXT: 1.00    -      -      -      -      -      -      -      -      -      -      -      -      -     movq	%rbx, %rcx
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -      -      -      -      -      -      -     movq	%rcx, %rdx
# CHECK-NEXT: 0.67   0.33    -      -      -      -      -      -      -      -      -      -      -      -     movq	%rdx, %rax

# CHECK:      Timeline view:
# CHECK-NEXT:                     01
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DR   .    ..   xorq	%rax, %rax
# CHECK-NEXT: [0,1]     DeER .    ..   movq	%rax, %rbx
# CHECK-NEXT: [0,2]     .DeER.    ..   movq	%rbx, %rcx
# CHECK-NEXT: [0,3]     .D=eER    ..   movq	%rcx, %rdx
# CHECK-NEXT: [0,4]     . D=eER   ..   movq	%rdx, %rax
# CHECK-NEXT: [1,0]     . D---R   ..   xorq	%rax, %rax
# CHECK-NEXT: [1,1]     .  DeE-R  ..   movq	%rax, %rbx
# CHECK-NEXT: [1,2]     .  D=eER  ..   movq	%rbx, %rcx
# CHECK-NEXT: [1,3]     .   D=eER ..   movq	%rcx, %rdx
# CHECK-NEXT: [1,4]     .   D==eER..   movq	%rdx, %rax
# CHECK-NEXT: [2,0]     .    D---R..   xorq	%rax, %rax
# CHECK-NEXT: [2,1]     .    DeE--R.   movq	%rax, %rbx
# CHECK-NEXT: [2,2]     .    .DeE-R.   movq	%rbx, %rcx
# CHECK-NEXT: [2,3]     .    .D=eE-R   movq	%rcx, %rdx
# CHECK-NEXT: [2,4]     .    . D=eER   movq	%rdx, %rax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     0.0    0.0    2.0       xorq	%rax, %rax
# CHECK-NEXT: 1.     3     1.0    1.0    1.0       movq	%rax, %rbx
# CHECK-NEXT: 2.     3     1.3    0.0    0.3       movq	%rbx, %rcx
# CHECK-NEXT: 3.     3     2.0    0.0    0.3       movq	%rcx, %rdx
# CHECK-NEXT: 4.     3     2.3    0.0    0.0       movq	%rdx, %rax