/* ap02a's taskset shim for the aspen oracle container on hasu: tools/perf
 * runs `taskset -c 0-3 PROG`, and rootless podman has no cpuset here, so
 * 0-3 would be block A's cores. This maps the list `0-3` to $AP02A_CPUS
 * (four of the lane's block), logs the translation to stderr once per
 * call, and execs the real /usr/bin/taskset with everything else as it
 * was. A C program, never a shell (hasu-env README). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char **argv) {
    const char *to = getenv("AP02A_CPUS");
    char **v = calloc((size_t)argc + 1, sizeof *v);
    if (!v) return 127;
    v[0] = "/usr/bin/taskset";
    for (int i = 1; i < argc; i++) {
        v[i] = argv[i];
        if (to && i > 1 && strcmp(argv[i - 1], "-c") == 0 && strcmp(argv[i], "0-3") == 0) {
            v[i] = (char *)to;
            fprintf(stderr, "taskset-shim: -c 0-3 -> -c %s\n", to);
        }
    }
    v[argc] = NULL;
    execv(v[0], v);
    perror("taskset-shim: execv /usr/bin/taskset");
    return 127;
}
