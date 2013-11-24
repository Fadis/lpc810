#include "cmsis.h"
#include <sys/types.h>
#include <errno.h>

extern "C" {

int  main(void);
void exit(int ErrorCode);

static void *heap_pointer = NULL;

extern "C"
int _kill(int pid, int sig) {
    errno = EINVAL;
    return -1;
}

extern "C"
void _exit(int status) {
    exit(status);
}

extern "C"
int _getpid(void) {
    return 1;
}

extern "C"
void *_sbrk(unsigned int incr) {
  return NULL;
}

}
