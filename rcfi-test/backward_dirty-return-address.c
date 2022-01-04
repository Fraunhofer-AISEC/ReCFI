//===----------------------------------------------------------------------===//
//
// This file is distributed under the Apache License v2.0
// Author: Oliver Braunsdorf, Fraunhofer AISEC
//
//===----------------------------------------------------------------------===//

#include <stdio.h>
#include <sanitizer/dfsan_interface.h>


void funA(){
  char buf[4000];
  dfsan_label label_buf = dfsan_create_label("buf", 0);
  dfsan_set_label(label_buf, buf, 4000);

  printf("funA(): The local buffer at %p sould be tainted now. \n", buf);
}


void funC(){
  printf("-----------------------------------\nfunC()\n");
}

void funB(){
  printf("-----------------------------------\nfunB()\n");

  funC();
}


int main (int argc, char ** argv){  
  funA();
  funB();

  return 0;
}
