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

typedef struct{
  char buf[8];
  void (*fnPtr)(void);
} somedata_t;

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
  void (*fnPtr)(void) = &publicFunction;
  printf("Address of function pointer %p\n", &fnPtr);

  char buf[8];
  printf("Address of buf %p\n", buf);

  #ifndef NO_DFSAN
    dfsan_label label = dfsan_create_label(__FILE__, "empty");
    dfsan_set_label(label, argv[1], strlen(argv[1]));
  #endif

  somedata_t *data = malloc(sizeof(somedata_t));
  data->fnPtr = &publicFunction;
  printf("writing %lu bytes to %p\n", strlen(argv[1]), data->buf);
  //heap overflow!
  memcpy(data->buf, argv[1], strlen(argv[1]));

  (*data->fnPtr)();

  return 0;
}
