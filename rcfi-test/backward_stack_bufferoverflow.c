//===----------------------------------------------------------------------===//
//
// This file is distributed under the Apache License v2.0
// Author: Oliver Braunsdorf, Fraunhofer AISEC
//
//===----------------------------------------------------------------------===//

#include <stdio.h>
#include <stdlib.h>
#include <sanitizer/dfsan_interface.h>
#include <string.h>

void secretFunction()
{
    printf("Congratulations!\n");
    printf("You have entered in the secret function!\n");
}

void copyAndPrint(char* src) {
    char buf[8];
    printf("Copying from program argument 1 \n");
    strcpy(buf, src);
    printf("Buffer=%s\n", buf);
}

int main (int argc, char** argv){
    if (argc != 2) {
        printf("Usage %s, payload\n", argv[0]);
        exit(1);
    }

    #ifndef NO_DFSAN
        dfsan_label label = dfsan_create_label(__FILE__, "empty");
        dfsan_set_label(label, argv[1], strlen(argv[1]));
    #endif

    copyAndPrint(argv[1]);
    return 0;
}