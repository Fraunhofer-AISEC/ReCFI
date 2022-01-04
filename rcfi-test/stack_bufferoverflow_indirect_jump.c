//===----------------------------------------------------------------------===//
//
// This file is distributed under the Apache License v2.0
// Author: Oliver Braunsdorf, Fraunhofer AISEC
//
//===----------------------------------------------------------------------===//

#include <stdio.h>
#include <sanitizer/dfsan_interface.h>
#include <string.h>
#include <stdlib.h>

void secretFunction() {
  printf("Access Granted\n");
}

void publicFunction (){
  printf("This function is accessible without access restrictions\n");
}

int main (int argc, char** argv){
  if (argc != 2){
    printf("Usage %s, payload\n", argv[0]);
    exit(-1);
  }

  void* jumpTarget;

  char buf[8];
  printf("Address of buf %p\n", buf);

  jumpTarget = &&succ;

  #ifndef NO_DFSAN
    dfsan_label label = dfsan_create_label(__FILE__, "empty");
    dfsan_set_label(label, argv[1], strlen(argv[1]));
  #endif
  strcpy(buf, argv[1]);
  printf("Vulnerable strcpy done \n");

  goto *jumpTarget;

  printf("this instruction should be unreachable");

  succ:
    printf("execution jumps here in case of program success\n");
    return 0;

  err:
    printf("execution jumps here in case of an expected error.\n");
    return 1;
}
