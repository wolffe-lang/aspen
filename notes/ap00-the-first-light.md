# ap00 — the first light: aspen, `tree` in wolf

Contract: `sprints/aspen/ap00-the-first-light.md` in the planning repo
(`wolf`, trunk `da5e609`, read from origin/trunk), with the coordinator's
change of shape (2026-10-21: the project is a port of the maintainer's C
aspen, its golden suite the oracle of record) and ruling #103 (B: read and
port C aspen's `src/`, citing `file:line`). This file is the lane's
record. §1 to §3 are committed before the first line under `src/`,
`tools/` or `tests/`; §4 (the evidence index) and §5 (done-when) are
filled in as the work lands.

## 1. Forbidden

As the contract, `sprints/RULES.md` and the track's rules (ruling #102),
with ruling #103's three limits: tree's source is never read directly;
the maintainer's untracked `.docs/` in his C aspen checkout (which holds
a unix-tree checkout, a bfs checkout and audits of tree's internals) is
never read beyond its file names; C aspen's citations of tree's source
are provenance recorded in `docs/MAP.md`, never links followed. C aspen
is read at `944a398` from the lane's own clone of the maintainer's
checkout (`git clone`, so only tracked files arrive; the maintainer's
checkout is never written). The goldens and `tests/golden/deviations.sh`
are the law and are never edited; a disagreement with a golden is a STOP
with the diff. No dependency but wolf-std. No build on nomad-1; builds,
tests, the oracle, the perf rows and every fixture with a FIFO or a
denied directory run on kasumi inside the lane's own podman container.
No merge, no tag, no release, no issue filed or closed (listed in the
report); the repository stays private. No attribution trailers.
`setsid -f` with a pid file for long jobs; kill by recorded pid only.
`~/.claude` is not the lane's.

## 2. Inputs, verified (2026-10-21)

| input | contract says | measured | drift |
|---|---|---|---|
| planning trunk | `da5e609` | `da5e609` "index, crawl-54: Track 14 aspen; ruling #102; ap00 launched" | none |
| wolf | 0.2.33, or 0.2.34 if published | `gh release list`: v0.2.33 latest (2026-10-19), no 0.2.34; tag object `56110e4f` -> `85dab5d7`; release 417610226; `wolf 0.2.33 (wolfgang, pin 85dab5d)` | none |
| lupin | 0.1.55 at `e642f26` | tag object `047184fb` -> `e642f263`; release 418932753 (2026-10-20); `lupin 0.1.55 (wolf-interp, reference interpreter at pin 294d626)`; wolf 0.2.33's own line 2 names lupin 0.1.54 as its pairing | the pair is wolf-std's (`df04a7a` vendors 0.1.55), not the driver's |
| digests | each read twice | the release API read twice, equal both times; the linux x86-64 pair hashed twice on kasumi after download: wolf `4f955e8d…`, lupin `1152abc0…` | none |
| wolf-std | `e036bec` | `e036bec318ad…` "findings: F-0155"; the wolf archive bundles `cceda63` (`std/STD-REV`), and `tools/fetch-toolchain` stages `e036bec` in its place | the archive's std is not the pin |
| tree on kasumi | v2.3.2 | `tree v2.3.2 © 1996 - 2026 by Steve Baker, …`; Arch `tree 2.3.2-1` (extra), GPL-2.0-or-later, installed 2026-10-20; the same package file is on archive.archlinux.org (44,562 bytes) | none |
| tree from Homebrew | (rule 4) | `brew info tree`: 2.3.2 | none |
| C aspen | `944a398` | the maintainer's checkout `tenseleyFlow/aspen`, head `944a398215…`; `git shortlog -sn --all`: 174 mfwolffe, every commit `mfwolffe <mfwolffe@outlook.com>`; 7,872 lines of C under `src/`; MIT | its `src/` cites tree's source by file and line (12 citations, `src/options.c:195`, `src/traverse.c:681`, …) and its local `.docs/` holds tree's and bfs's source: ruling #103 |
| `asp` | find out | `Makefile:81–83`: "asp is the same binary under a second name"; `make install` symlinks it (`Makefile:121`) | v1 needs no second binary |
| C aspen's golden suite | the oracle of record | live, not recorded: `tests/golden/run.sh` runs 286 flag sets over 14 generated fixture trees in C, en_US.UTF-8 and C.UTF-8 against a tree 2.3.2 that `build-ref.sh` builds from tree's source; the lane pre-places the distribution's tree 2.3.2 binary at the path `build-ref.sh` checks first, so nothing clones or builds tree's source | the harness is per-binary, not per-option: the lane's `tools/oracle` runs its case list, fixtures and normalisations verbatim and classes each case v1 or not-yet |
| kasumi | `/home` ~30 GB | 31 GB free, 16 cores, load ~2, podman 6.1.3, `archlinux:base-devel` present | none |

## 3. Prediction (before the first change)

1. **The v1 options agree byte for byte** with tree 2.3.2 and with C
   aspen on every golden case in the C and C.UTF-8 locales, once three
   things the C does are carried exactly: the name escaping (octal
   escapes and `\ ` for a space in the C locale, `src/render/name.c:20`;
   UTF-8 printed as is in a UTF-8 locale), the UTF-8 line set's two
   no-break spaces (`src/charset.c:96`), and the root counted as a
   directory only when its listing is non-empty (`src/traverse.c:1403`,
   `:1414`).
2. **en_US.UTF-8 is not-yet for v1**: tree and C aspen sort with
   `strcoll`/`strxfrm` there (`src/sort.c:244`), a collation wolf has no
   surface for. Every case whose names sort the same by byte will still
   agree; the rest differ by order alone, and are counted, not hidden.
3. **`-J` is the hardest v1 surface** (escaping, the error `contents`,
   D2's dropped empty array, the report object), and **-h rounds half to
   even** on the exact quotient (`src/render/fileinfo.c:43`'s `%3.1f` of
   a value exact in binary), which integer arithmetic reproduces.
4. **`-D` needs a calendar of aspen's own**: wolf-std has no
   `localtime`, so the date is computed from the epoch with the zone
   from `TZ` or `/etc/localtime`; in the oracle's container `TZ` is UTC
   and the result is exact.
5. **Non-UTF-8 names** cannot be stat'ed or descended (paths are `str`,
   wolf-lang#687); every golden and fuzzer name is UTF-8, so no case
   moves, and the gap is named where a reader meets it.
6. **Speed.** C aspen is 3–5× faster than tree on the README's corpora;
   the wolf port, with `d_type` from `fs.entries` (no `lstat` on the
   default path), a buffered writer and an O(n log n) byte sort, lands
   within 2× of C aspen on the 1,000-entry directory and the 100,000-file
   tree for the default listing, and further behind (but within 2× of
   tree) where every entry is stat'ed (`-s`, `-p`, `-D`), because
   `fs.lstat` returns twenty words per call.
7. **The static binary** links with `cc -static` (lope's `tools/mkstatic`
   shape), is ET_EXEC with no PT_INTERP, reproduces its digest when built
   twice, and is under 2 MiB stripped.

## 4. Evidence index

Every number below was measured; where is named. The kasumi record is
`notes/ap00-evidence/kasumi-gauntlet.sh`, its log
`notes/ap00-evidence/kasumi-gauntlet.log` (at `0db8d10`, every gate in
order, exit status per step). CI runs are §4.9.

### 4.1 The oracle of record: C aspen's golden suite

`tools/golden` copies C aspen at `944a398` (its files unedited; the
checkout's `git status` clean before every run), puts the wolf aspen at
`./aspen` and the container's tree 2.3.2 at `tests/.work/ref/tree-2.3.2`,
and runs its scripts as they are.

- `run.sh`, the matrix: **286 cases × 3 locales (C, en_US.UTF-8,
  C.UTF-8): 308 agree / 0 differ / 550 not-yet.** Its own self-test
  (tree against tree) 0 diffs in each locale. 104 of the 286 cases use
  only v1 flags; every one agrees in C and C.UTF-8 (208); in en_US.UTF-8
  100 agree and 4 differ by order alone (`-a %C`, `-aF %C`, `-aP .h* %C`,
  `-n -a %C`: `strcoll` sorts `.hidden` as `hidden`), counted not-yet.
  The other 182 cases per locale need a v2 flag (by the first one:
  `-X` 27, `-H` 24, `--fromfile` 16, `--condense` 13, `--charset` 12,
  `--gitignore` 9, `--compress` 9, `--hyperlink` 7, `-u` 6, `--info` 6,
  `--filelimit` 6, `-l` 5, `--inodes` 4, `--fromtabfile` 4, `--sort` 3,
  `-Q` 3, and 2 or 1 each for `-v --si -R -q --opt-toggle -N -i --fflinks
  -c -x -U --timefmt -S --metafirst --infofile --gitfile -g --filesfirst
  --device`).
- `walk.sh` clean; `fdlimit.sh` clean; `outfile.sh`, `fpath.sh`,
  `patterns.sh`, `usage.sh`, `deviations.sh`, `structural.sh`: **0 v1
  reports**, and 1, 2, 1, 34, 16, 12 not-yet reports (their `-X`, v2
  option and `-H`/`-R`/`-l`/`--filelimit`/`--inodes`/`--condense` rows).
- **Total: 308 agree / 0 differ / 616 not-yet**: on kasumi on the
  native, release and static binaries; in CI on the release tier (linux,
  in the container). On macOS against Homebrew's tree: 312 / 0 / 612
  (macOS's en_US.UTF-8 collates by byte, so the four order cases agree).

### 4.2 The fixture oracle

`tools/oracle`: 66 v1 sets and 44 v2 sets (`tests/oracle/sets.tsv`) over
seven roots (`main wide deny empty afile lnkroot /no/such/root`,
`tests/fixtures/mkfixtures`) in C and C.UTF-8: **864 agree / 0 differ /
616 not-yet**, every v2 set refused by name with status 2. The same on
the native, release and static binaries.

### 4.3 The fuzzer

`tools/fuzz` (C aspen's generator and normalisations, v1's pool `-a -d
-f -s -h -p -D -F -n -A -t -r --du --prune --dirsfirst --noreport
--matchdirs --ignore-case -J -L1 -L2 -L3`): **2,000 trees × 2 locales =
4,000 runs, 0 differences** on kasumi; 200 trees in every CI run.

### 4.4 Deviations and where the port follows tree

C aspen's law, carried and asserted by its `deviations.sh` (0 v1
reports): D1, D2, D5, A4-residual (`docs/MAP.md` §4). The three places C
aspen differs from tree with no golden or deviation (a `-J` symlink root's
type, a file root's `--du` size, several roots' `--du` total) follow tree
(`docs/MAP.md` §5, commit `6748ea3`).

### 4.5 The unit tests

`tools/check-test`: five files (`src/glob_test.lu`, `info_test`,
`clock_test`, `opts_test`, `name_test`), each a `main` of asserts: pass on
the checked machine (`wolf test --json`: every detail `exit(0)`, **no
native fallback**, so no rerun on `conform-run` was needed), as native
binaries, and on lupin 0.1.55.

### 4.6 Speed

`tools/perf` in the container on kasumi (`taskset -c 0-3`, LC_ALL=C,
median of three, interleaved; kasumi load 4–7 from other lanes), three
passes in the gauntlet:

| row | tree | C aspen | aspen | aspen / C aspen | aspen / tree |
|---|---:|---:|---:|---:|---:|
| wide1k, the listing (gated) | 2.5–2.9 ms | 1.9–2.0 ms | 2.0–2.2 ms | 1.07–1.13 | 0.77–0.82 |
| tree100k, the listing (gated) | 92.5–96.1 ms | 23.8–25.3 ms | 39.7–40.7 ms | 1.61–1.67 | 0.42–0.43 |
| wide1k, `-s` (reported) | 2.6–2.7 ms | 2.1–2.2 ms | 2.6–2.9 ms | 1.23–1.30 | 1.00–1.08 |
| tree100k, `-s` (reported) | 99.6–102.1 ms | 46.1–48.9 ms | 96.7–98.1 ms | 1.98–2.13 | 0.95–0.98 |

On kasumi's host (`perf stat -r 7`): the listing 45.7 ms against C
aspen's 30.0 (1.53×); `-s` 90.8 against 52.7 (1.72×); C aspen with
`--threads 1` 87 ms for `-s`. What moved the listing from 2.2× to 1.5×:
the packed seven-byte sort key (`0bd0b15`; the struct-reading radix was
slower), one indentation prefix per directory, no per-entry strings in
the columns, and no empty lists per entry (two allocations an entry, 47
ns, measured by a probe). `-s` stats big levels on `scope` tasks with C
aspen's thresholds; a task's answer is one text message per chunk,
because a channel carries no list (E1102) and a tuple per entry costs
0.7 µs (measured: 100,000 sends in 66–78 ms).

### 4.7 The static build

`tools/mkaspen` in an Ubuntu 24.04 container (glibc 2.39, clang 18.1.3)
at the gauntlet's head: ET_EXEC, no PT_INTERP, **built twice to one
digest `b34106b5bf15252e1024d1bd67839044008b5e5f4f4ae483b75821a329cda384`,
14,497,536 bytes; stripped 1,577,336 bytes** (under 2 MiB, the
prediction). The oracle on it: 864 / 0 / 616.

### 4.8 The harnesses see a difference

`tools/selftest` against aspens spoiled one way each (a corner glyph, a
report count, 50 ms late): the oracle twice, golden, fuzz and perf each
exit 1, in every CI run and on kasumi.

### 4.9 CI runs

- Trunk `5f99a37`: push 39537470014 (`tier full`, green); nightly
  39576928271 (green).
- A partial dispatch on `618f140` (`-f jobs="linux macos"`, before the
  PR existed): 39609891049, **green on both hosts**. Linux, in the
  container: oracle 864 / 0 / 616 on native, release and static; golden
  308 / 0 / 616; fuzz 400 runs, 0 differences; perf 1.10× and 1.61× (the
  listing), `-s` 1.23× and 1.72×; static `9bd08d6d7114…`, 14,257,992
  bytes, stripped 1,571,400, built twice to one digest (the runner's clang
  and libc.a, so not kasumi's container's digest: each builder reproduces
  its own); selftest five reds. macOS arm64 against Homebrew's tree
  2.3.2: unit tests on three lanes, oracle 864 / 0 / 616, golden 312 / 0
  / 612, fuzz 200 runs, 0 differences.
- PR #1 at `5a88baa`: 39611478087, `tier pr` green.

### 4.10 The plants

Each a draft PR on top of ap00's head `5a88baa`, closed unmerged, seen red
in its own pull-request run (RULES §7: on a new repository the PR run
itself):

- **The oracle**, PR #2 (`153b026`, branch `ap00-plant-oracle`): the
  ASCII corner drawn `'--` instead of `` `-- ``. Run 39611570451, job
  119261569696, went red on the oracle (native, release, static: 682
  agree / 182 differ, the first `|   '-- beta` for `` |   `-- beta ``), the
  golden suite (243 agree / 81 differ) and the fuzzer (10 differences in
  26 runs) (steps 9, 10, 11, 12, 15); `tier pr` red.
- **The perf row**, PR #3 (`99dad82`, branch `ap00-plant-perf`): the
  name sort by selection, n²/2 comparisons on every input, the same
  order. Run 39611577042, job 119261578036, went red on the perf step
  alone (step 13): the 100,000-file listing at 2.96× C aspen (106.8 ms
  against 36.1), while the oracle (864 / 0 / 616), the golden suite
  (308 / 0 / 616) and the fuzzer (0 differences) stayed green; `tier pr`
  red. A first version of the plant, an insertion sort, did not go red on
  kasumi: tmpfs hands the names over already sorted once `read_level`
  takes them from the end, and insertion sort is linear there.

## 5. Done-when

- [x] The repository at its first trunk (`5f99a37`: the toolchain pin,
  README, CHANGELOG, licences, the planner, a tiered `ci.yml`), its first
  runs green: push 39537470014 (`tier full`), nightly 39576928271.
- [x] v1 byte-identical: C aspen's goldens 308 / 0 / 616, the fixture
  oracle 864 / 0 / 616, the fuzzer 4,000 runs 0 differences, with the
  not-yet list (§6).
- [x] The perf row: the listing within 2× of C aspen on the 1,000-entry
  directory (1.07–1.13×) and the 100,000-file tree (1.61–1.67×); `-s`
  measured (up to 2.13×), not gated.
- [x] `tools/mkaspen` static, built twice, one digest (§4.7).
- [x] The plants seen red: PR #2, run 39611570451 (the oracle); PR #3,
  run 39611577042 (the perf row); both closed unmerged (§4.10).
- [ ] PR open with the five sections, shas as bullets, a test checklist;
  `tier pr` green and the `full-matrix` label at the final head; the
  lane audit (§4.9).

## 6. The v2 options, and tree's answer to each

Every option below is refused by name, status 2. tree's answer on the
`main/` fixture, C locale (status, stdout bytes, lines; `main/` holds a
0000 directory, so tree's status is 2 wherever it reports the error),
from `tools/oracle`, and the golden matrix's not-yet cases each first
needs (§4.1):

| option | tree on main/ | golden cases |
|---|---|---:|
| `-C` | 2, 676 B, 42 lines | (color.sh) |
| `-H .` | 2, 4,041 B, 81 | 24 |
| `-X` | 2, 1,969 B, 56 | 27 |
| `-l` | 2, 728 B, 45 | 5 |
| `-x` | 2, 676 B, 42 | 1 |
| `--fromfile` | 0, 49 B, 3 | 16 |
| `--fromtabfile` | 0, 49 B, 3 | 4 |
| `--fflinks` | 2, 676 B, 42 | 2 |
| `--filelimit 3` | 0, 76 B, 3 (the root over the limit) | 6 |
| `--charset=ascii` | 2, 676 B, 42 | 12 |
| `-S` | 2, 676 B, 42 | 1 |
| `-v` | 2, 676 B, 42 | 2 |
| `--sort=size` | 2, 676 B, 42 | 3 |
| `-u` | 2, 1,156 B, 42 | 6 |
| `-g` | 2, 1,156 B, 42 | 1 |
| `--inodes` | 2, 1,116 B, 42 | 4 |
| `--device` | 2, 956 B, 42 | 1 |
| `-q` | 2, 619 B, 42 | 2 |
| `-N` | 2, 615 B, 42 | 2 |
| `-Q` | 2, 762 B, 42 | 3 |
| `--timefmt %F` | 2, 1,236 B, 42 | 1 |
| `-R` | 2, 676 B, 42 | 2 |
| `-i` | 2, 452 B, 42 | 2 |
| `-c` | 2, 676 B, 42 | 2 |
| `-U` | 2, 676 B, 42 | 1 |
| `--filesfirst` | 2, 676 B, 42 | 1 |
| `--si` | 2, 996 B, 42 | 2 |
| `--metafirst` | 2, 676 B, 42 | 1 |
| `--gitignore` | 2, 676 B, 42 | 9 |
| `--gitfile=.gitignore` | 1, 0 B (no such file) | 1 |
| `--info` | 2, 676 B, 42 | 6 |
| `--infofile=x` | 1, 0 B (no such file) | 1 |
| `--condense` | **0**, 676 B, 42 (D1: a full-tree mode) | 13 |
| `--compress 2` | 2, 620 B, 42 | 9 |
| `--hyperlink` | 2, 4,282 B, 42 | 7 |
| `--scheme`, `--authority` | 2, 676 B, 42 | — |
| `--opt-toggle` | 2, 676 B, 42 | 2 |
| `-T x`, `--nolinks`, `--hintro`, `--houtro` | 2, 676 B, 42 (no `-H`: no effect) | — |
| `--acl` | 2, 1,276 B, 42 | — |
| `--selinux` | 2, 842 B, 42 | — |

## 7. ap01's contract, drafted in full

### ap01 — The second light (aspen: the formats, the filters, the rest of tree's surface)

**Draft by ap00 for the orchestrator. Opus. Crawl 54 or later.** Rulings
#102 and #103 (`sprints/aspen/index.md`). aspen v1 (ap00, PR #1 on
wolffe-lang/aspen) is byte-identical to tree 2.3.2 and to C aspen on the
v1 options and refuses every other option by name with status 2. ap01
ports the rest of C aspen at `aspen.pin` (`944a398`), largest share of
the golden matrix first, each option leaving the refusal list only when
C aspen's goldens and the fixture oracle both agree on it.

**1. The formats.** `-X` (C aspen `src/render/xml.c`, 27 of the golden
matrix's 182 not-yet cases per locale); `-H baseHREF`, `-T`, `--nolinks`,
`--hintro`, `--houtro` (`src/render/html.c`, `src/render/escape.c`; 24
cases), with deviations D3 (the real percent-encoded byte) and A7 (aspen's
own VERSION footer) carried as `tests/golden/deviations.sh` asserts them;
`-i` and `--compress N` across text, `-J`, `-X` (`src/charset.c`'s
narrower forms, `src/render/outbuf.c:27`; 11 cases); `--charset X` and
`-S` (the table `src/lines` already holds; 13 cases, and `--charset`'s
missing-argument list, `usage.sh`).

**2. The filters and trees.** `--fromfile`, `--fromtabfile`, `--fflinks`
(`src/fromfile.c`; 22 cases); `--condense` (`src/traverse.c:911`; 13);
`--gitignore`, `--gitfile` (`src/filter.c`; 10); `--info`, `--infofile`
(`src/info.c`; 7); `--filelimit N` with D1 and D2 and SR-2.12's root
(`src/traverse.c:824`; 6); `-l` with the sorted cycle set and D7
(`src/hashtab.c`, `src/traverse.c:646`; 5); `-x` (1); `-R` with D6 and D8
(2, and `tests/golden/rerun.sh`).

**3. The columns and sorts.** `-u`/`-g` (`src/idcache.c`; wolf-std
`std.os.users`, whose header says what macOS's directory service hides),
`--inodes` and `--device` with D4 (the link's own numbers), `--si`,
`--timefmt` (strftime, aspen's own: wolf has none), `-c`; `-v` and
`--sort=version` (`src/verscmp.c`), `--sort`, `-U` (the host's order: v1
reverses it while reading, `src/walk`), `--filesfirst`; `-q`, `-N`, `-Q`
(`src/render/name.c`'s other branches); `--metafirst`; `--opt-toggle`.

**4. Colour.** `-C`, `LS_COLORS`/`TREE_COLORS`/`CLICOLOR`/`NO_COLOR`, the
terminal check (`src/color.c`; std's `io.is_terminal`), `--hyperlink`,
`--scheme`, `--authority` (`src/render/unix.c:62`); C aspen's
`tests/golden/color.sh` and `pty.sh` (a PTY the test starts).

**5. What v1 named and left.** The dictionary-locale collation (en_US.UTF-8
sorts with `strcoll`; v1 sorts by byte; 4 golden cases): measure what
wolf can carry (glibc's collation tables are the locale's data, not
code) and ask a ruling with the number. The `-s` speed (v1: ~1.7–2.1x C
aspen, measured not gated): move the column's formatting into the stat
tasks, then gate `-s` and ask the ratchet ruling. The memory (86 MB for
the 100,000-file listing, C aspen 2.8 MB): a region per directory level.
`--asp-diff` (C aspen's `src/diff.c`), `--threads`, `ASP_IO`: ask whether
aspen carries C aspen's own extensions.

**6. Gates.** Every option leaves the refusal list with its golden cases
counted in `tools/golden` (the matrix's not-yet count falls by exactly
those), its fixture sets in `tests/oracle/sets.tsv` moved from v2 to v1,
the fuzz pool widened to it (`tools/fuzz`'s cut is
`tools/lib-classify.sh`), unit rows where it has logic of its own, and a
plant per new gate seen red in CI. `tier pr` green and the `full-matrix`
label at the final head; the macOS job against Homebrew's tree.

## Forbidden / rules
`sprints/RULES.md`, the track's rules, ruling #103's three limits (never
tree's source directly; never the maintainer's untracked `.docs/`; C
aspen's tree citations are provenance, `docs/MAP.md` §1, not links). The
goldens and `deviations.sh` are the law and never edited; a disagreement
is a STOP with the diff. Where C aspen differs from tree and no golden
covers it, follow tree and list the C aspen issue (ap00 found three,
`docs/MAP.md` §5). No dependency but wolf-std; no builds on nomad-1;
every oracle, perf row and fixture with a FIFO or a 0000 directory in
the oracle's container.

## Inputs (re-derive)
aspen trunk after ap00's merge; C aspen `944a398` (`aspen.pin`); tree
2.3.2-1 (the container's, Homebrew's); the toolchain pin, or the next
release if one is out (re-read `gh release list`); ap00's
`notes/ap00-the-first-light.md` (§4's v2 table: tree's status, bytes and
lines for every v2 option on the main fixture).

## Prediction (write before the first change)
To be written by ap01: which options agree at once, which need wolf-std
surfaces that do not exist (strftime, users, collation), the golden
not-yet count after each step.

## Done-when
The refusal list empty or each remaining refusal ruled; the golden matrix
`N agree / 0 differ / K not-yet` with K only what a ruling keeps; the
fixture oracle and the fuzzer 0 differ; the perf rows within the ratchet
the ruling sets; PR open per RULES §6.

## 8. Issues to file (none filed by the lane)

- **tenseleyFlow/aspen** (the maintainer's): three tree-parity bugs no
  golden covers (`docs/MAP.md` §5): (1) `-J` types a symlink-to-directory
  root `"directory"` without a metadata flag, tree `"link"`
  (`src/render/json.c:294`); (2) `--du` drops a file root's size from the
  total (`src/traverse.c:1280`); (3) `--du` with several roots reports
  the last root's total, tree sums them (`src/traverse.c:1378`, `:1397`).
- **wolf-lang**: no bulk append or capacity on `List` (aspen's writer
  pushes byte by byte; `std.list.extend` and `truncate` are loops); a
  channel refuses `List` payloads (E1102), so a task's results cross as
  text; the fs surface is path-only (no `openat`/`fstatat`), so each stat
  builds a path string, and `fs_lstat` answers twenty words in a fresh
  list every call.
- **wolf-std**: no `localtime`/`strftime` (aspen reads TZif itself,
  `src/clock`); no locale or collation surface (`strcoll`).
- **wolf (planning)**: `tools/lane-audit.sh` does not know `aspen` (its
  sibling list and TIERED; the orchestrator adds it at hand-back).

## 9. Rulings asked

1. **The `-s` perf rows**: reported, not gated (up to 2.13× C aspen,
   whose stat pool and C-speed main thread aspen's tasks match only on
   the stats). Recommendation: keep the gate on the listing (the
   contract's row) and make `-s` ap01's ratchet, after the column's
   formatting moves into the stat tasks.
2. **C aspen's three parity bugs** (§8): the port follows tree.
   Recommendation: keep tree's answers and file them on tenseleyFlow/aspen.
3. **en_US.UTF-8**: v1 sorts by byte in every locale (4 golden cases
   differ by order). Recommendation: ap01 measures what collation wolf
   can carry; until then the README names the gap.
