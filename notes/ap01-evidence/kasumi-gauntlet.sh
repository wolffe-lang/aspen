#!/bin/sh
# kasumi-gauntlet — every ap01 gate in order on kasumi, into one log: the
# record behind notes/ap01-the-second-light.md §6. Builds on the host
# (wolf's toolchain), every oracle, perf row, memory row and fixture in
# the oracle's container (tools/in-container), the static build in an
# Ubuntu 24.04 container (a baseline glibc).
#
#   sh notes/ap01-evidence/kasumi-gauntlet.sh   (from the repository root)
set -u
step() {
    echo
    echo "### $*"
    "$@"
    echo "### exit $?: $*"
}
echo "### kasumi gauntlet at $(cat .gauntlet-rev 2>/dev/null || git rev-parse HEAD) (uncommitted: $(cat .gauntlet-dirty 2>/dev/null | wc -l | tr -d " ") files), $(date -u +%Y-%m-%dT%H:%M:%SZ)"
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
step tools/in-container tools/golden --bin target/native/aspen
step tools/in-container tools/fuzz --bin target/release/aspen --n 2000
step tools/in-container "tools/aspdiff --bin $PWD/target/release/aspen --c-bin $PWD/.oracle/c-aspen/aspen"
step tools/in-container tools/collation --bin target/release/aspen
step tools/in-container tools/perf --bin target/release/aspen
step tools/in-container tools/perf --bin target/release/aspen
step tools/in-container tools/perf --bin target/release/aspen
step tools/in-container tools/mem --bin target/release/aspen
step podman run --rm --userns=keep-id -u 0 -v "$PWD:$PWD" -w "$PWD" docker.io/library/ubuntu:24.04 sh -c 'apt-get update -qq >/dev/null && apt-get install -y -qq gcc binutils clang lld >/dev/null 2>&1 && tools/mkaspen target/mkaspen && chown -R "$(stat -c %u:%g .)" target'
step tools/in-container tools/oracle --bin target/mkaspen/aspen
step tools/in-container tools/golden --bin target/mkaspen/aspen
step tools/in-container tools/selftest target/release/aspen
echo
echo "### done $(date -u +%Y-%m-%dT%H:%M:%SZ)"
