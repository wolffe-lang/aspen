#!/bin/sh
# kasumi-gauntlet — every ap00 gate in order on kasumi, into one log: the
# record behind notes/ap00-the-first-light.md §4. Builds on the host
# (wolf's toolchain), every oracle, perf row and fixture in the oracle's
# container (tools/in-container), the static build in an Ubuntu 24.04
# container (a baseline glibc).
#
#   sh notes/ap00-evidence/kasumi-gauntlet.sh   (from the repository root)
set -u
step() {
    echo
    echo "### $*"
    "$@"
    echo "### exit $?: $*"
}
echo "### kasumi gauntlet at $(git rev-parse HEAD 2>/dev/null || cat .gauntlet-rev), $(date -u +%Y-%m-%dT%H:%M:%SZ)"
uptime
step tools/fetch-toolchain
step tools/check-fmt
step tools/build --all
step tools/check-test
step tools/fetch-c-aspen
step tools/in-container 'tree --version; id; cd .oracle/c-aspen && ./configure >/dev/null && make -s && ./aspen --version'
step tools/in-container tools/oracle --bin target/native/aspen
step tools/in-container tools/oracle --bin target/release/aspen
step tools/in-container tools/golden --bin target/release/aspen
step tools/in-container tools/fuzz --bin target/release/aspen --n 2000
step tools/in-container tools/perf --bin target/release/aspen
step tools/in-container tools/perf --bin target/release/aspen
step tools/in-container tools/perf --bin target/release/aspen
step podman run --rm --userns=keep-id -u 0 -v "$PWD:$PWD" -w "$PWD" docker.io/library/ubuntu:24.04 sh -c 'apt-get update -qq >/dev/null && apt-get install -y -qq gcc binutils clang lld >/dev/null 2>&1 && tools/mkaspen target/mkaspen && chown -R "$(stat -c %u:%g .)" target'
step tools/in-container tools/oracle --bin target/mkaspen/aspen
step tools/in-container tools/selftest target/release/aspen
echo
echo "### done $(date -u +%Y-%m-%dT%H:%M:%SZ)"
