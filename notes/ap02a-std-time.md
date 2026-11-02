# ap02a — adopt std.time, retire src/clock (aspen#12, aspen#13)

Contract: `wolf/sprints/aspen/ap02a-std-time.md` (relaunched 2026-11-01,
Claude Opus 5.5, batch A), under `wolf/sprints/the-lane-rules-1031.md` and
`sprints/RULES.md` §1-§10. Base: aspen trunk `bb3d5647` (wolf 0.2.36,
lupin 0.1.58, wolf-std `78b9d3cb` bundled). Branch `ap02a`.

## 1. Forbidden

- tree 2.3.2 is a black box: its manual, `--help` and runs only, never
  its source; no other lister's source. C aspen at `aspen.pin` is read and
  cited (`file:line`); its `.docs/` is never read.
- No libc source: the C library's zone handling is measured through
  tree's and C aspen's output, never read.
- No merge, label, tag, release, or issue filed or closed. No CI wait.
  kasumi untouched. No attribution trailers.

## 2. Inputs, verified (2026-11-01)

- The pin: `wolf-toolchain.toml` at `bb3d5647`, staged by
  `tools/fetch-toolchain` on the Mac (aarch64-apple-darwin) and on hasu
  (x86_64-unknown-linux-gnu), each archive refused unless its sha256 is
  the pin's; `std/STD-REV` `78b9d3cbc41d51db44d18c40b6694403644d1c83`.
- std at the pin, `std/time/local.lu`: `local`, `local_in`, `offset_at`,
  `to_unix`, `format`; no zone handle; "No leap seconds, locale state or
  timezone cache. Each lookup reads anew" (its header); `:458` returns
  `zone` for a nonzero TZif leap count, and `local` (`:716-727`) turns
  `zone` into UTC.
- The leap fix: wolf-std#105 (filed by the first ap02a run, 2026-10-25)
  is closed by sc74's wolf-std#107, merged 2026-10-25T18:56Z, trunk
  `b6193f3`..`fad69dfe` (three commits under `std/time`).
  `git merge-base --is-ancestor fad69dfe 78b9d3cb` is false: 0.2.36
  (released 2026-10-28, the latest wolf) bundles the std of 2026-10-23,
  nine commits before the fix. No wolf release carries it.
- aspen#13's instant: Unix 1783000020 (2026-07-02 13:47:00 UTC), where
  `right/America/New_York` is 27 s behind the plain zone.
- The old prediction `600d80c6` (Sol, 2026-10-25) rebased once onto
  `bb3d5647` as `cc9bfca`, corrected at `04f9f27` and moved to
  `notes/ap02a-prediction.txt` (where r40p's prediction lives).

## 3. Prediction

`notes/ap02a-prediction.txt`, committed before the first change
(`cc9bfca`, `04f9f27`). How each row came out is in §4.

## 4. Evidence index

### 4.1 What landed

- `src/zone` (new, the call site of std.time): `spelling` reads `TZ` once
  (unset is `:/etc/localtime`, std's own `local`); `memo` resolves the
  zone once as glibc does (tree's answers, measured) and keeps the last
  lookup of 64 slots by the second; `refusal` names a leap-second zone.
- `src/tfmt` owns `Tm` (C's `struct tm`) and `tm_of`, the weekday and the
  day of the year counted from std's `to_unix`; its strftime is unchanged.
- `src/info`: the columns hold the memo; `date` is std's `format` for
  `%b %e` and `%R`, the year as its own digits.
- `src/aspen.lu`: a time column under a leap-second zone is refused
  before anything is written, status 2.
- `src/clock/` and `src/clock_test.lu` deleted (667 + 108 lines).
- The census `tests/clock-rows.tsv` + `tools/check-rows` (run by
  `tools/check-test`, so CI runs it): 13 rows kept at call sites, 8
  dropped for the std test named.
- The oracles: `tools/oracle --tz/--ref`, `tools/tzoracle`,
  `tests/oracle/tz.tsv` (classes v1, tree, ref, refuse), the fixtures'
  `times/` root.

### 4.2 The prediction against what was measured

| Prediction (`04f9f27`) | Measured |
|---|---|
| 1. tree and C aspen print `09:46:33 EDT -0400` and `[Jul  2 09:46]` under `right/America/New_York` at 1783000020 | Both, in the oracle's container on hasu (M1a, 2026-11-01 21:06Z); `right/UTC` `13:46:33`; `TZDIR=…/right TZ=America/New_York` `09:46:33` |
| 1. trunk aspen prints `09:47:00`, 27 s late | So: trunk's build prints `09:47:00 EDT -0400` there, 27 s late (hasu, `right-rows`) |
| 1. the pinned std refuses and `local` is UTC; std trunk answers `09:46:33` | So: at the pin `local_in` answers `zone` and `local` is `13:47:00 UTC +0000`; std trunk at `dee6206` answers `09:46:33 EDT -0400` (`notes/ap02a-evidence/stdtime.lu` built against each, hasu) |
| 1. aspen after: status 2, one line naming the zone, nothing on stdout; no time column, the listing unchanged | The unit rows: `zone_test` (refused by name; a v2 file's 64-bit leap records; not refused without them), green on nomad. In the real files on hasu: `right/America/New_York`, `/usr/share/zoneinfo/right/UTC` and `TZDIR=…/right TZ=America/New_York` each refused on 14 of 14 time sets, one line naming the zone and its file; with no time column each listing agrees with tree, 16 of 16, and exits 0 (`tzoracle-tree`, `right-rows`) |
| 2. every time set equal before and after, and equal to tree | Mac, against the trunk build: 1176 agree / 0 differ (10 counted skips); hasu: against tree 1546 agree / 0 differ / 0 skipped / 22 known (the `XST3XDT` row, class `ref`); against trunk 1322 agree / 0 differ / 6 skipped (class `tree`); the whole oracle against trunk 2904 / 0 / 32 |
| 3. a DST string with no rule: the old clock's US rule, std's UTC | So: `XST3XDT` gave 44 differences before the fix (`fd0879c`, the Mac). tree prints `11:47:00 XDT -0200` (glibc's default rule), so aspen adds `,M3.2.0,M11.1.0` (R-ap02a-5): 0 differences against trunk at `71a4001` |
| 3. `$TZDIR`: std reads it, the old clock did not | So: `TZDIR=/usr/share/zoneinfo/Asia TZ=Kolkata`: the head agrees with tree on 56 of 56, trunk on 2 of 56 |
| 3. TZ precedence (rule first): no visible difference for real names | So: `GMT0`, `UTC0`, `EST5EDT` agree before and after |
| 4. std re-reads the zone per call, 5-30 us | 14.6 us a call natively for New York's TZif, 75 ns for a POSIX rule (nomad, `notes/ap02a-evidence/stdtime.lu`); the memo (R-ap02a-2); hasu 7.0 us (the pin and std trunk alike) against 144 ns. The memo hides it where files share their times and not where they differ: the `-D` rows (§4.5) |
| 5. 25 rows kept or dropped | 21 rows, not 25 (`grep -c assert src/clock_test.lu`): 13 kept at call sites, 8 dropped for the std test named (`tests/clock-rows.tsv`) |
| 5. the plant red by the row's name | `MISSING [July is winter there]` (§4.3) |
| 6. glibc does not build C.UTF-8 in | So: with `/usr/lib/locale/C.utf8` removed, tree draws ASCII lines under `LANG=C.UTF-8` (M1a); `TREE_CHARSET=UTF-8` draws the UTF-8 set there; `LANG=de_DE.UTF-8` (not installed) is ASCII |
| Unpredicted | An unloadable zone: tree names it by the value's leading letters (`nonsense`, `Nowhere`, `times`, `ABC`) and a non-UTF-8 `TZ` by nothing; src/clock and std both say `UTC` (R-ap02a-6, -7). One or two letters, a quoted `<ABC>` and a lone `:` part from that rule (§4.5, issue 7) |

### 4.3 Red before green

- The census, red at `fd4bee5`: `check-rows: 0 kept / 8 dropped for std / 13
  missing, of 21 rows`, exit 1 (nomad;
  `notes/ap02a-evidence/census-red-fd4bee5.log`).
- The refusal, its rows committed with a stub at `433e8f3`: `wolf-trap:
  assert at src/zone_test.lu:136:5` ("a leap-second file is refused by
  name"), exit 134, native, nomad (snapshot `9613990`, the same tree).
- The memo's resolution, rows at `f2a698b`: `wolf-trap: assert at
  src/zone_test.lu:136:5` ("a DST rule without its dates is the US one"),
  exit 134, native, nomad (snapshot `d278fa1`, the same `src/`).
- The refuse rows of `tests/oracle/tz.tsv` against the trunk build:
  on hasu trunk refused none of the 14 time sets on any of the three
  rows (`NOT REFUSED`, status 0, the uncorrected time), and the whole
  matrix read 1410 agree / 136 differ: the refuse rows' 42, the five
  named rows' 40 (trunk named them UTC) and the `tzdir` row's 54
  (`MEASURE tzoracle-trunk-vs-tree`).
- **The plant**, `ap02a-plant-row` at `1a1021d` (#16, draft): the head
  `71a4001` with the row "July is winter there" deleted, one of the rows
  no std test covers. `tools/check-rows` there, on nomad: `check-rows:
  MISSING [July is winter there]: not in src/zone_test.lu (std cover: none
  (no std row for a southern rule in winter))`, `12 kept / 8 dropped for
  std / 1 missing`, exit 1. In CI it is the `the unit tests` step of #16's
  run 41355564822.

### 4.4 The gauntlet

Two gauntlets, each stopping at its first nonzero step and printing
`END <step> exit=N`.

**nomad** (`notes/ap02a-evidence/mac-gauntlet.sh`, `71a4001`, under the Mac build lock; no
tree on the Mac, so the oracles run against trunk's release build):

    END check-fmt exit=0
    END build-all exit=0
    END check-test exit=0
    END oracle-trunk exit=0
    END tzoracle-trunk exit=0

with `check-test: wolf test: 6 passed, 0 not passed`, every file native
and lupin `ok`, `check-rows: 13 kept / 8 dropped for std / 0 missing, of
21 rows`; `oracle: 2904 agree / 0 differ / 32 not-yet`; `tzoracle: 1176
agree / 0 differ / 10 skipped / 0 known`.

**hasu** (`notes/ap02a-evidence/gauntlet.sh`: CI's linux job step
for step, building in an Ubuntu 24.04 + clang 18 image as CI's runner
does and running the oracles in `ci/oracle.Containerfile`'s image; then
`tzoracle` against tree and against trunk, the whole oracle against
trunk, and the `right/` rows), at `324d6cf` (the code of `71a4001`),
block A, 23:24-23:33Z, exit 0 (`notes/ap02a-evidence/hasu-gauntlet-324d6cf.log`;
its copy queued on block B stepped aside, `-g2.log`):

    END images exit=0
    END fetch-toolchain exit=0
    END check-fmt exit=0
    END build-all exit=0
    END check-test exit=0
    END fetch-c-aspen exit=0
    END c-aspen-build exit=0
    END oracle-native exit=0
    END oracle-release exit=0
    END golden exit=0
    END fuzz exit=0
    END aspdiff exit=0
    END collation exit=0
    END perf exit=0
    END mkaspen exit=0
    END oracle-static exit=0
    END selftest exit=0
    END build-trunk exit=0
    END tzoracle-tree exit=0
    END tzoracle-trunk exit=0
    END oracle-trunk exit=0
    END right-rows exit=0

with check-test 6 passed and the census 13 / 8 / 0; the oracle 2904
agree / 0 differ / 32 not-yet on the native, release and static
binaries; the golden matrix 829 / 0 / 29 (en_US.UTF-8 collation); fuzz
400 runs, 0 differences; aspdiff 44 runs, 0; collation 29 of 286, all by
collation; perf aspen/C 1.13 and 1.15 (wide1k), 1.79 and 1.68
(tree100k), each within 2x; tzoracle against tree 1546 / 0 / 0 skipped
/ 22 known, against trunk 1322 / 0 / 6 skipped; the whole oracle against
trunk 2904 / 0 / 32. After it, not gates: `MEASURE names exit=0`,
`MEASURE tzoracle-trunk-vs-tree exit=1` (trunk's reds, as designed),
`MEASURE probes-build exit=0`, `MEASURE probes-run exit=0`, and the cost
rows.

### 4.5 Measurements

- **std.time's cost a call** (nomad, `notes/ap02a-evidence/stdtime.lu`, release tier):
  `TZ=America/New_York`, 10,000 calls 146 ms (14,623 ns a call), 100,000
  calls 15,334 ns a call; `TZ=UTC0`, 75 ns a call; unset (the Mac's
  `/etc/localtime`, New York), 13,680 ns. hasu (the Arch container): New York 7,017 ns a call at the pin and 6,888 ns at std trunk; `UTC0` 144 ns.
- **The `-D` listing**, 100,000 files (100 directories of 1,000), hasu,
  `TZ=America/New_York`, `taskset` on four cores of block A, three runs:

  | ms | C aspen | trunk (`src/clock`) | head (std.time + memo) |
  |---|---|---|---|
  | times shared, `-D` | 59 | 106 | 127 |
  | times shared, `--timefmt=%T` | 59 | 108 | 106 |
  | times distinct, `-D` | 53 | 97 | 435 |
  | times distinct, `--timefmt=%T` | 55 | 101 | 434 |

  With every file's time distinct, a `-D` listing is 4.5x trunk and 8.2x
  C aspen: 338 ms more over 100,000 entries, 3.4 us an entry, where
  std's zone file read costs 7 us a call (the stat pool formats the
  column on several lanes at once). tools/perf gates the listing and `-s`, not
  `-D`, so no gate saw it. wolf-std#112 (a parsed zone handle) removes it.
- **The Mac, against the trunk build** (`bb3d5647`'s release binary, no
  tree on the Mac): the whole `tests/oracle/sets.tsv`, TZ=UTC, 2904 agree
  / 0 differ / 32 not-yet; `tools/tzoracle --ref`, 1176 agree / 0 differ /
  10 skipped (five rows whose files macOS has not, five `tree` rows) at
  `71a4001`. At `fd0879c`, before R-ap02a-5, the same run read 1244 agree /
  44 differ, every difference the `XST3XDT` row.
- **The line glyphs**, nomad, the trunk binary (`od` of the first branch
  line): `LANG` unset `|--`; `LANG=en_US.UTF-8` and `LANG=C.UTF-8`
  `├──`; `LC_ALL=C LANG=en_US.UTF-8` `|--`; `TREE_CHARSET=UTF-8` `├──`;
  `LANG=en_US.UTF-8 TREE_CHARSET=ascii` `|--` (macOS has
  `/usr/share/locale/C.UTF-8`). The container (M1a, tree 2.3.2, glibc
  2.44): `LANG` unset `|--`; `LANG=C.UTF-8`, `LC_ALL=C.UTF-8`,
  `LANG=en_US.UTF-8` `├──`; `LANG=de_DE.UTF-8` (not installed) `|--`;
  `TREE_CHARSET=UTF-8` `├──`; `LANG=C.UTF-8 TREE_CHARSET=ascii` `|--`;
  with `/usr/lib/locale/C.utf8` removed, `LANG=C.UTF-8` `|--` and
  `TREE_CHARSET=UTF-8` `├──`.
- **tree's answers for zones** (the container, `--timefmt '%F %T [%Z] %z'`
  at 1783000020): `nonsense` `[nonsense] +0000`; `Nowhere/City`
  `[Nowhere]`; `:times/leap` `[times]`; `ABC` `[ABC]`; empty and unset
  (no `/etc/localtime` there) `[UTC]`; a non-UTF-8 byte `[]`; `XST3XDT`
  `11:47:00 [XDT] -0200`; `EST5EDT4` `09:47:00 [EDT] -0400`. `XST3XDT` at
  2026-03-08 06:59:59 and 07:00:00 UTC is `XST -0300` both (glibc's
  posixrules edges, not `M3.2.0`'s 05:00 UTC), and at 2100-07-01
  `20:00:00 [EDT] -0400`. More values (hasu, `MEASURE names`): `AB`, `A`, `X1`, `Ab_cd`
  `[]` (fewer than three leading letters is no name); `<ABC>junk` and
  `<ABC>` `[ABC]` (a quoted name); `abc def`, `ABC+`, `abc,def` `[abc]`
  / `[ABC]`; `1234`, `-x`, `/no/such/file`, `:/no/such/file` `[]`; `:`
  `[UTC]`; `nonsense9` is a rule, `[nonsense] -0900`. `lead_name` agrees
  for three letters or more and for the empty cases; it differs for one
  or two letters (it names them), a quoted name (it gives none) and a lone
  `:` (it gives none, tree `UTC`): an issue (§4.8), no tz.tsv row holds
  them.
- **The container's tmpfs keeps times from -2^31**: `lmt` (1883) reads as
  1901-12-13 20:45:52 UTC on both sides.

### 4.6 The evidence files

`notes/ap02a-evidence/`: `m1a-hasu-baseline.log` (the container's facts,
tree's and C aspen's `right/` rows, tree's zone and locale rows),
`mac-gauntlet-71a4001.log`, `mac-tzoracle-fd0879c.log` (the 44 `XST3XDT`
differences before R-ap02a-5), the four red logs, the three witness
programs, and the scripts that ran them (`gauntlet.sh`,
`build.Containerfile`, `taskset-shim.c`, `mac-gauntlet.sh`).

### 4.7 Rulings recommended (each implemented)

- **R-ap02a-1** (aspen#13 at this pin): (A) refuse a leap-second zone by
  name, status 2, when a time column is asked; (B) apply the TZif leap
  table in aspen, which re-does std trunk's fix in aspen; (C) stage std
  trunk at or past `fad69dfe` in place of the bundled std
  (`fetch-toolchain` can, as ap00's first pin did), which is a pin change
  (`cross-cutting`) to a std no wolf release has tested. **A**, implemented.
  C at the first wolf release that bundles `fad69dfe`; that re-pin deletes
  `zone.refusal` and turns tz.tsv's refuse rows into v1.
- **R-ap02a-2** (std reads the zone file on every lookup): (A) a 64-slot
  direct-mapped memo by the second, exact, and cheap for the stat pool's
  per-task copy of the columns; (B) a map of every second seen (unbounded,
  and the pool copies it); (C) no memo. **A**, implemented, and a std
  issue for a parsed zone handle (wolf-std#112). Measured after: it
  keeps a listing whose files share their times near trunk (127 ms
  against 106), and does nothing for distinct times (435 against 97,
  §4.5): the remedy is #112, then a `-D` row in tools/perf.
- **R-ap02a-3** (`--timefmt`): (A) keep aspen's strftime, `src/tfmt`, fed
  std's fields through `tm_of`; (B) std's `format`, which has 28
  conversions, none of glibc's `%U %W %V %G %g %r %h %k %l %P %E %O`, no
  `^ #` flags, no 255-byte cap, and no BSD dialect. **A**, implemented.
- **R-ap02a-4** (`-D`'s default form): (A) std's `format` for `%b %e` and
  `%R`, the year as its own digits; (B) std's `%Y`, which pads to four
  (`0999` where glibc prints `999`); (C) aspen's own month table, as
  before. **A**, implemented (rows "the year 1000", "a three-digit year").
- **R-ap02a-5** (a DST rule given without its dates, `XST3XDT`): (A) add
  `,M3.2.0,M11.1.0`, as src/clock did; (B) UTC, std's choice ("no host's
  undocumented default US rule is guessed"); (C) copy glibc's use of its
  posixrules file, which moves the edges' hours and past 2037 prints that
  file's zone (`EDT -0400` in 2100). **A**, implemented: equal to trunk;
  equal to tree mid-season; tz.tsv class `ref` against tree.
- **R-ap02a-6** (a zone nothing loads): (A) UTC named by the value's
  leading letters, one colon dropped, as tree names it; (B) `UTC`, as
  src/clock and std do. **A**, implemented (class `tree`).
- **R-ap02a-7** (`TZ` not UTF-8): (A) UTC with no name, as tree prints it
  (spelled `?` inside aspen); (B) as unset, `/etc/localtime`, as
  src/clock did. **A**, implemented.
- **R-ap02a-8** (the TZ matrix in CI): (A) `tools/tzoracle` stays a lane
  tool here and a step joins CI's linux job in a `cross-cutting`
  follow-up; (B) the step here, which makes this PR cross-cutting.
  **A**, implemented (an issue to file).
- **R-ap02a-9** (where the census runs): (A) `tools/check-test` runs
  `tools/check-rows`, so both CI jobs run it with no workflow change; (B)
  a step of its own (`cross-cutting`). **A**, implemented.
- **R-ap02a-10** (the old prediction's place): (A) `notes/`, beside
  r40p's; (B) left in `tests/`. **A**, implemented.
- **R-ap02a-11** (pax#184's fix, `LANG=C.UTF-8` in PAX's login): (A) tell
  pax#184 that the variable alone changes nothing while PAX ships no
  `/usr/lib/locale/C.utf8` (glibc and aspen alike need it), with
  `TREE_CHARSET=UTF-8` meanwhile; (B) aspen treats `C.UTF-8` as always
  installed, which departs from glibc and tree. **A**, written into the
  README; the comment on pax#184 is the orchestrator's to make.

### 4.8 Issues to file (none filed by the lane)

Filed by the orchestrator on 2026-11-01: 1 is wolf-std#112, 2 wolf-std#113,
3 wolf-interp#316, 4 aspen#17, 6 a comment on pax#184. 7 and 8 are new.

1. **wolf-std**: a parsed zone handle (`time.zone(name)` and a lookup over
   it), so a consumer reads a zone file once. Witness: `notes/ap02a-evidence/stdtime.lu`
   `cost`: 14,623 ns a call for New York's TZif against
   75 ns for a POSIX rule (nomad, wolf 0.2.36).
2. **wolf-std**: `time.format`'s `%Y` pads to four digits, `0999`, where
   glibc's strftime prints `999` (aspen's tfmt rows measured glibc).
   Witness: `notes/ap02a-evidence/year-pad.lu`, lupin 0.1.58: `0999|Jan  1  0999`.
3. **wolf-interp** (lupin): `var k = -800000; twice(k * 86400)` with
   `twice(t: int)` traps `*` overflow "outside `i32`" in lupin 0.1.58; the
   native tier and the checked machine take `k` as `int` and print
   `-138240000000`. Witness: `notes/ap02a-evidence/lit-width.lu`. (`src/tfmt_test.lu`
   annotates `var k: int` for it.)
4. **aspen**: `tools/in-container tools/tzoracle` as a step of CI's linux
   job (`cross-cutting`, R-ap02a-8).
5. **wolf-lang** (or the next pin lane): a release bundling wolf-std at or
   past `fad69dfe`; aspen#13's correction is that re-pin (R-ap02a-1).
   wolf-std#105 itself is closed and fixed on std trunk: `stdtime.lu`
   at std `dee6206` reads `09:46:33 EDT -0400` (§4.2).
6. **pax#184** (a comment, not an issue): `LANG=C.UTF-8` needs
   `/usr/lib/locale/C.utf8` on PAX (R-ap02a-11).
7. **aspen**: the name of a zone nothing loads, where `lead_name` and
   tree part (§4.5, `MEASURE names`): one or two leading letters (tree:
   none), a quoted `<ABC>` (tree: `ABC`), a lone `:` (tree: `UTC`). Rows
   for tz.tsv and a fix in `zone.lead_name`.
8. **aspen**: `-D` over files of distinct times is 4.5x trunk (435 ms
   against 97 on 100,000 files, §4.5) until wolf-std#112; then a `-D` row
   in tools/perf.

To close at the merge: aspen#12. aspen#13 stays open (recommended) until
the re-pin applies the correction; this PR only refuses.

## 5. Done-when

- The PR (#15) has the five sections, the commits, the test checklist and
  `Footprint: module` (no CI file, pin or spec path in the diff).
- The plant (#16, draft) is red by name, locally and in CI (run
  41355564822: `check-rows: MISSING [July is winter there]`).
- The gauntlets green: nomad at `71a4001`, hasu at `324d6cf` (§4.4).
- `tier pr` green at `324d6cf` (run 41360810210); the run at this head
  is the orchestrator's watch.
