#include <stdlib.h>

__attribute__((constructor))
static void ForceTXM(void) {
    setenv("HAS_TXM", "1", 1);
}
