#===-- build.sh ------------------------------------------------------------===#
#
# This file is distributed under the Apache License v2.0
# Author: Oliver Braunsdorf, Fraunhofer AISEC
#
#===----------------------------------------------------------------------===#

BUILD_DIR="$1"
if [ ! -d "$BUILD_DIR" ]; then
    echo "Cannot find build directory \"$BUILD_DIR\"! Abort"
    exit 1
fi

TEST_RESULT_DIR="$2"
if [ ! -d "$TEST_RESULT_DIR" ]; then
    echo "Cannot find build directory \"$TEST_RESULT_DIR\"! Abort"
    exit 1
fi

export PATH=$PATH:$(readlink -f "$BUILD_DIR"/bin)
echo $PATH
cd "$TEST_RESULT_DIR"

echo "############### stack_bufferoverflow_indirect_jump (NO PROTECTION) ###############"
clang -g -DNO_DFSAN /home/builder/llvm-project/rcfi-test/stack_bufferoverflow_indirect_jump.c -o stack_bufferoverflow_indirect_jump && ./stack_bufferoverflow_indirect_jump $(python -c 'print "a"*9')
echo $?

echo "############### stack_bufferoverflow_indirect_jump (WITH RCFI) ###############"
clang -g -fsanitize=dataflow -mllvm -dfsan-rcfi-indirect-calls -mllvm -dfsan-rcfi-no-taint-allocas -mllvm -dfsan-rcfi-debug-stackframe /home/builder/llvm-project/rcfi-test/stack_bufferoverflow_indirect_jump.c -o stack_bufferoverflow_indirect_jump && ./stack_bufferoverflow_indirect_jump $(python -c 'print "a"*9')

STATUS=$?
if [ $STATUS == 177 ]; then
    echo "RCFI detected overflow"
else
    echo "RCFI did not detect the overflow"
    exit 1
fi






echo "############### stack_bufferoverflow_indirect_call (NO PROTECTION) ###############"
clang -g -DNO_DFSAN /home/builder/llvm-project/rcfi-test/stack_bufferoverflow_indirect_call.c -o stack_bufferoverflow_indirect_call && ./stack_bufferoverflow_indirect_call $(python -c 'print "a"*9')
echo $?

echo "############### stack_bufferoverflow_indirect_call (WITH RCFI) ###############"
clang -g -fsanitize=dataflow -S -emit-llvm -mllvm -dfsan-rcfi-indirect-calls -mllvm -dfsan-rcfi-no-taint-allocas -mllvm -dfsan-rcfi-debug-stackframe /home/builder/llvm-project/rcfi-test/stack_bufferoverflow_indirect_call.c -o stack_bufferoverflow_indirect_call.ll
clang -g -fsanitize=dataflow -mllvm -dfsan-rcfi-indirect-calls -mllvm -dfsan-rcfi-no-taint-allocas -mllvm -dfsan-rcfi-debug-stackframe /home/builder/llvm-project/rcfi-test/stack_bufferoverflow_indirect_call.c -o stack_bufferoverflow_indirect_call && ./stack_bufferoverflow_indirect_call $(python -c 'print "a"*9')
STATUS=$?
if [ $STATUS == 177 ]; then
    echo "RCFI detected overflow"
else
    echo "RCFI did not detect the overflow"
    exit 1
fi


echo "############### heap_bufferoverflow_indirect_call (NO PROTECTION) ###############"
clang -g -DNO_DFSAN /home/builder/llvm-project/rcfi-test/heap_bufferoverflow_indirect_call.c -o heap_bufferoverflow_indirect_call && ./heap_bufferoverflow_indirect_call $(python -c 'print "a"*9')
echo $?

echo "############### heap_bufferoverflow_indirect_call (WITH RCFI) ###############"
clang -g -fsanitize=dataflow -mllvm -dfsan-rcfi-indirect-calls -mllvm -dfsan-rcfi-no-taint-allocas -mllvm -dfsan-rcfi-debug-stackframe /home/builder/llvm-project/rcfi-test/heap_bufferoverflow_indirect_call.c -o heap_bufferoverflow_indirect_call && ./heap_bufferoverflow_indirect_call $(python -c 'print "a"*9')
STATUS=$?
if [ $STATUS == 177 ]; then
    echo "RCFI detected overflow"
else
    echo "RCFI did not detect the overflow"
    exit 1
fi







echo "############### backward_stack_bufferoverflow (NO PROTECTION) ###############"
clang -g -DNO_DFSAN /home/builder/llvm-project/rcfi-test/backward_stack_bufferoverflow.c -o backward_stack_bufferoverflow && ./backward_stack_bufferoverflow $(python -c 'print "a"*48')
echo $?

echo "############### backward_stack_bufferoverflow (WITH RCFI) ###############"
clang -g -fsanitize=dataflow -mllvm -dfsan-rcfi-backward -mllvm -dfsan-rcfi-no-taint-allocas -mllvm -dfsan-rcfi-debug-stackframe /home/builder/llvm-project/rcfi-test/backward_stack_bufferoverflow.c -o backward_stack_bufferoverflow && ./backward_stack_bufferoverflow $(python -c 'print "a"*80')
STATUS=$?
if [ $STATUS == 177 ]; then
    echo "RCFI detected overflow"
else
    echo "RCFI did not detect the overflow"
    exit 1
fi







echo "############### backward_dirty-return-address (WITH RCFI) ###############"
clang -g -fsanitize=dataflow -mllvm -dfsan-rcfi-backward -mllvm -dfsan-rcfi-no-taint-allocas -mllvm -dfsan-rcfi-debug-stackframe /home/builder/llvm-project/rcfi-test/backward_dirty-return-address.c -o backward_dirty-return-address && ./backward_dirty-return-address $(python -c 'print "a"*80')
STATUS=$?
if [ $STATUS == 0 ]; then
    echo "RCFI does not have problems with dirty return addresses"
else
    echo "RCFI has problems with dirty return addresses"
    exit 1
fi

