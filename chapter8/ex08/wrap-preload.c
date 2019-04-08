#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>

/* Override the exit function: this function returns 7 */
void exit(int status)
{
	fprintf(stderr,"exit() was called with status = %d\n",status);
	void (*orig_exit)(int status) = dlsym(RTLD_NEXT, "exit");
	orig_exit(7);
	for(;;);
}
