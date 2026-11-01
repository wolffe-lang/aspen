#!/usr/bin/env bash
# ap02a's gauntlet on hasu block A (CPUs 0-5) or B (6-11), at one commit: CI's linux
# job step for step (.github/workflows/ci.yml) in the oracle's container,
# then the TZ matrix against tree and against the trunk build, the whole
# oracle against the trunk build, and the right/ rows. Stops at the first
# nonzero step; every step prints `END <step> exit=N`. After the gauntlet,
# the -D cost rows (a measurement, not a gate).
#   gauntlet.sh SHA
set -u
L=/home/mfwolffe/lanes/ap02a
export PATH=$HOME/lanes/hasu-env/bin:$HOME/lanes/hasu-env/profile/bin:$PATH
P=$HOME/lanes/hasu-env/bin/podman
CPUS=6-11
FOUR=6-9
if [ "${AP02A_BLOCK:-B}" = A ]; then CPUS=0-5; FOUR=0-3; fi
SHA=${1:?sha}
# @FILE: the commit is read from FILE when the job starts (it is always a
# commit; the lane may name a corrected head while the job waits)
case "$SHA" in @*) SHA=$(cat "${SHA#@}") ;; esac
# one gauntlet per commit: a copy queued on the other block steps aside
mkdir -p "$L/logs"
if ! mkdir "$L/logs/gauntlet-$SHA.ran" 2>/dev/null; then
    echo "gauntlet: $SHA already ran or runs on the other block ($L/logs/gauntlet-$SHA.ran); nothing to do"
    exit 0
fi
echo "block ${AP02A_BLOCK:-B}" >"$L/logs/gauntlet-$SHA.ran/block"
BEFORE_SHA=bb3d5647158bb550a374c9f6fee1d8598c1cb6c0
say() { echo "=== $(date -u +%H:%M:%SZ) $*"; }
# step NAME CMD...: run, print END, stop the gauntlet on a nonzero exit
step() {
    name=$1
    shift
    say "step $name"
    "$@"
    rc=$?
    echo "END $name exit=$rc"
    if [ "$rc" != 0 ]; then
        say "gauntlet stopped at $name"
        exit "$rc"
    fi
}
cd "$L" || exit 2
[ -d aspen ] || git clone -q https://github.com/wolffe-lang/aspen.git aspen
git -C aspen fetch -q origin trunk ap02a
for sha in $BEFORE_SHA $SHA; do
    d=$L/wt-${sha:0:7}
    [ -d "$d" ] || git -C aspen worktree add -q --detach "$d" "$sha"
done
B=$L/wt-${BEFORE_SHA:0:7}
H=$L/wt-${SHA:0:7}
say "gauntlet at $(git -C "$H" rev-parse HEAD) ($(git -C "$H" log -1 --format=%s))"
sum=$(sha256sum "$H/ci/oracle.Containerfile" | cut -c1-12)
IMG=localhost/ap02a-aspen-oracle:$sum
SIMG=localhost/ap02a-aspen-oracle-shim:$sum
BIMG=localhost/ap02a-build:$(sha256sum "$L/build.Containerfile" | cut -c1-12)
images() {
    $P image inspect "$BIMG" >/dev/null 2>&1 || $P build -q -t "$BIMG" -f "$L/build.Containerfile" "$L" || return 1
    $P image inspect "$IMG" >/dev/null 2>&1 || $P build -q -t "$IMG" -f "$H/ci/oracle.Containerfile" "$H/ci" || return 1
    if ! $P image inspect "$SIMG" >/dev/null 2>&1; then
        ctx=$L/shim-ctx
        mkdir -p "$ctx" && cp "$L/taskset-shim.c" "$ctx/" || return 1
        printf 'FROM %s\nCOPY taskset-shim.c /tmp/taskset-shim.c\nRUN gcc -O2 -Wall -o /usr/local/bin/taskset /tmp/taskset-shim.c && rm /tmp/taskset-shim.c\n' "$IMG" >"$ctx/Containerfile"
        $P build -q -t "$SIMG" -f "$ctx/Containerfile" "$ctx" || return 1
    fi
    $P run --rm "$SIMG" sh -c 'command -v taskset; tree --version'
}
# ctr DIR CMD: CMD in the oracle's container as this user at DIR, on the
# block, as tools/in-container runs it (TZ=UTC, a private /tmp, no cores)
ctr() {
    $P run --rm --userns=keep-id --memory 12g -v "$L:$L" -w "$1" \
        --tmpfs /tmp:rw,exec,size=4g -e TZ=UTC -e HOME=/tmp -e TMPDIR=/tmp -e AP02A_CPUS=$FOUR \
        "$SIMG" taskset -c $CPUS sh -c "ulimit -c 0; $2"
}
# bld DIR CMD: CMD in the build image (Ubuntu 24.04, clang 18: CI's
# runner), where wolf's release tier links; the binaries run in the
# oracle's container as CI's do
bld() {
    $P run --rm --userns=keep-id --memory 12g -v "$L:$L" -w "$1" \
        --tmpfs /tmp:rw,exec,size=4g -e TZ=UTC -e HOME=/tmp -e TMPDIR=/tmp \
        "$BIMG" taskset -c $CPUS sh -c "ulimit -c 0; $2"
}
W=$H/.wolf-bin
step images images
say "tree's names for zones nothing loads, beyond tz.tsv (a measurement, not a gate)"
ctr "$H" '
mkdir -p /tmp/r && printf x >/tmp/r/leap && touch -d @1783000020 /tmp/r/leap
for z in AB A X1 1234 "<ABC>junk" "<ABC>" "abc def" Ab_cd nonsense9 "ABC+" ":" ":/no/such/file" "/no/such/file" "-x" ":Nowhere/City" "abc,def"; do
  printf "%-20s %s\n" "TZ=[$z]" "$(TZ=$z tree -n --timefmt "[%Z] %z %T" /tmp/r | grep leap)"
done'
echo "MEASURE names exit=$? (a measurement, not a gauntlet step)"
step fetch-toolchain sh -c "cd '$H' && tools/fetch-toolchain"
step check-fmt bld "$H" "tools/check-fmt"
step build-all bld "$H" "tools/build --all"
step check-test bld "$H" "tools/check-test"
step fetch-c-aspen sh -c "cd '$H' && tools/fetch-c-aspen && test -z \"\$(git -C .oracle/c-aspen status --porcelain --untracked-files=no)\""
step c-aspen-build ctr "$H/.oracle/c-aspen" "./configure >/dev/null && make -s && ./aspen --version"
step oracle-native ctr "$H" "tools/oracle --bin target/native/aspen"
step oracle-release ctr "$H" "tools/oracle --bin target/release/aspen"
step golden ctr "$H" "tools/golden --bin target/release/aspen"
step fuzz ctr "$H" "tools/fuzz --bin target/release/aspen --n 200"
step aspdiff ctr "$H" "tools/aspdiff --bin $H/target/release/aspen --c-bin $H/.oracle/c-aspen/aspen"
step collation ctr "$H" "tools/collation --bin target/release/aspen"
step perf ctr "$H" "tools/perf --bin target/release/aspen"
step mkaspen bld "$H" "tools/mkaspen target/mkaspen"
step oracle-static ctr "$H" "tools/oracle --bin target/mkaspen/aspen"
step selftest ctr "$H" "tools/selftest target/release/aspen"
step build-trunk bld "$B" "WOLF_BIN=$W/wolf LUPIN_BIN=$W/lupin WOLF_STD=$W/std tools/build --release && cp target/release/aspen $L/bin/before-linux-release"
step tzoracle-tree ctr "$H" "tools/tzoracle --bin target/release/aspen"
step tzoracle-trunk ctr "$H" "tools/tzoracle --bin target/release/aspen --ref $L/bin/before-linux-release"
step oracle-trunk ctr "$H" "tools/oracle --bin target/release/aspen --ref $L/bin/before-linux-release"
right_rows() {
    ctr "$H" "
mkdir -p /tmp/r && printf x >/tmp/r/leap && touch -d @1783000020 /tmp/r/leap
for z in America/New_York right/America/New_York; do
  for p in tree $H/.oracle/c-aspen/aspen $L/bin/before-linux-release $H/target/release/aspen; do
    a=\$(TZ=\$z \$p -n --timefmt '%F %T %Z %z' /tmp/r 2>&1 | grep -E 'leap|aspen:'); ra=\$?
    echo \"\$z | \$p | \$a\"
  done
done
TZ=right/America/New_York $H/target/release/aspen -n -D /tmp/r; rc=\$?
echo \"after, -D under right/: exit \$rc\"
[ \$rc = 2 ] || exit 1
TZ=right/America/New_York $H/target/release/aspen -n /tmp/r; rc=\$?
echo \"after, no time column under right/: exit \$rc\"
[ \$rc = 0 ]"
}
step right-rows right_rows
say "gauntlet green"

say "the trunk build against tree under tz.tsv (the baseline; its refuse rows are red by design)"
ctr "$H" "tools/tzoracle --bin $L/bin/before-linux-release"
echo "MEASURE tzoracle-trunk-vs-tree exit=$? (a measurement, not a gauntlet step)"

say "the std witness (aspen#13): std.time at the pin and at std trunk, a right/ zone"
[ -d "$L/wolf-std-trunk" ] || git clone -q --depth 1 https://github.com/wolffe-lang/wolf-std.git "$L/wolf-std-trunk"
echo "std trunk at $(git -C "$L/wolf-std-trunk" rev-parse HEAD)"
bld "$L/probes" "WOLF_STD=$W/std $W/wolf build --release stdtime.lu -o stdtime-pin && WOLF_STD=$L/wolf-std-trunk/std $W/wolf build --release stdtime.lu -o stdtime-trunk"
echo "MEASURE probes-build exit=$?"
ctr "$L/probes" '
for z in America/New_York right/America/New_York; do
  for p in ./stdtime-pin ./stdtime-trunk; do
    echo "--- $p TZ=$z"
    TZ=$z $p show $z 1783000020
  done
done
TZ=America/New_York ./stdtime-pin cost 100000 1783000020
TZ=America/New_York ./stdtime-trunk cost 100000 1783000020
TZ=UTC0 ./stdtime-pin cost 100000 1783000020'
echo "MEASURE probes-run exit=$?"

say "the -D cost rows (a measurement): tree100k, the files' times shared, then distinct"
ctr "$H" "
python3 -I - /tmp/w <<'PYEOF'
import os, sys
w = sys.argv[1]
for name, distinct in (('same', False), ('distinct', True)):
    t = os.path.join(w, name)
    for i in range(100):
        s = os.path.join(t, 'd%03d' % i)
        os.makedirs(s)
        for j in range(1000):
            p = os.path.join(s, 'f%04d' % j)
            open(p, 'w').close()
            if distinct:
                v = 1700000000 + (i * 1000 + j) * 61
                os.utime(p, (v, v))
PYEOF
for wl in same distinct; do
  for p in $H/.oracle/c-aspen/aspen $L/bin/before-linux-release $H/target/release/aspen; do
    for fl in -D --timefmt=%T; do
      LC_ALL=C TZ=America/New_York taskset -c 0-3 \$p \$fl /tmp/w/\$wl >/dev/null 2>&1
      best=
      for k in 1 2 3; do
        t0=\$(date +%s%N); LC_ALL=C TZ=America/New_York taskset -c 0-3 \$p \$fl /tmp/w/\$wl >/dev/null 2>&1; t1=\$(date +%s%N)
        ms=\$(( (t1 - t0) / 1000000 )); best=\"\$best \$ms\"
      done
      echo \"cost \$wl \$fl \$(basename \$(dirname \$p))/\$(basename \$p): ms\$best\"
    done
  done
done"
say "done"
