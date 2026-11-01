#!/bin/bash
# ap02a's Mac gauntlet at one commit (CI's macOS job where the Mac can:
# no tree here, so the oracles run against the trunk build): stops at the
# first nonzero step; every step prints END <step> exit=N.
set -u
W=/Users/mfwolffe/lanes/ap02a/aspen-1101/.wolf-bin
export WOLF_BIN=$W/wolf LUPIN_BIN=$W/lupin WOLF_STD=$W/std CARGO_INCREMENTAL=0
cd "$1" || exit 2
echo "mac gauntlet at $(git rev-parse HEAD) on $(hostname)"
TRUNK=/Users/mfwolffe/lanes/ap02a/bin/before-mac-release
step() { n=$1; shift; echo "=== $(date -u +%H:%M:%SZ) step $n"; "$@"; rc=$?; echo "END $n exit=$rc"; [ "$rc" = 0 ] || exit "$rc"; }
step check-fmt tools/check-fmt
step build-all tools/build --all
step check-test tools/check-test
step oracle-trunk tools/oracle --bin target/release/aspen --ref "$TRUNK"
step tzoracle-trunk tools/tzoracle --bin target/release/aspen --ref "$TRUNK"
echo "mac gauntlet green"
cd /Users/mfwolffe/lanes/ap02a/probes && $WOLF_BIN build lit-width.lu -o lit-width-native >/dev/null 2>&1 && echo "MEASURE lit-width native: $(./lit-width-native)"
