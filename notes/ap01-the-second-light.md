# ap01 — the second light: the formats, the filters, the rest of tree's surface

Contract: `sprints/aspen/ap01-the-second-light.md` in the planning repo
(`wolf`, trunk `f98968c`, read from origin/trunk), adopted from ap00's
draft (`notes/ap00-the-first-light.md` §7). Rulings #102 and #103
(`sprints/aspen/index.md`). This file is the lane's record: §1 to §4 are
committed before the first change under `src/`, `tools/`, `tests/` or the
toolchain pin; §5 onward is filled in as the work lands.

## 1. Forbidden

As the contract, `sprints/RULES.md` and the track's rules, with ruling
#103's three limits: tree's source is never read directly; the
maintainer's untracked `.docs/` in his C aspen checkout is never read
beyond its file names; C aspen's citations of tree's source are
provenance (`docs/MAP.md` §1), never links followed. C aspen is read at
`944a398` from the lane's own clone (`git clone` of ap00's clone of the
maintainer's checkout: only tracked files); the maintainer's checkout is
never written. The goldens and `tests/golden/deviations.sh` are the law
and are never edited; a disagreement with a golden is a STOP with the
diff. No dependency but wolf-std. No build on nomad-1: builds and tests
on kasumi, and the oracle, the perf rows, the PTY and colour tests and
every fixture with a FIFO or a 0000 directory inside the lane's own
podman container (ap00's image was pruned; rebuilt from
`ci/oracle.Containerfile` unchanged, `localhost/aspen-oracle:c109ec9aa750`,
tree v2.3.2, run as uid 1000). No merge, no tag, no release, no issue
filed or closed (listed in the report); no public step (the maintainer
made the repository public on 2026-10-21, during this lane: his step,
not the lane's). No
attribution trailers. `setsid -f` with a pid file for long jobs; kill by
recorded pid only. `~/.claude` is not the lane's.

## 2. Inputs, verified (2026-10-21)

| input | contract says | measured | drift |
|---|---|---|---|
| planning trunk | `f98968c` | `f98968c` "aspen: ap01's contract, adopted from ap00's draft; index" | none |
| aspen trunk | after ap00's merge | `103ba46` "notes: the CI runs, the plants seen red, two claims corrected" | none |
| wolf | 0.2.34 (`v0.2.34` at `9da7bdcf`) | `gh release list`: v0.2.34 latest (2026-10-21); tag object `38ab81cb` -> `9da7bdcf`; release 419552903, its digests read twice, equal; the linux x86-64 archive hashed twice on kasumi (`88a9dd3d…`); `wolf 0.2.34 (wolfgang, pin 9da7bdc)`, "paired with lupin 0.1.55" | ap00's pin is 0.2.33: the bump is the first change (§4.1) |
| lupin | 0.1.55 | v0.1.55 still latest; tag `047184fb` -> `e642f263`; release 418932753 read twice, the digests the pin's | none |
| wolf-std | `e036bec` | 0.2.34's archive bundles `e036bec` (`std/STD-REV`): the pin and the bundle agree for the first time | none |
| tree | 2.3.2-1 (the container's, Homebrew's) | the rebuilt image: `tree v2.3.2 © 1996 - 2026 by Steve Baker, …`; `brew info tree`: stable 2.3.2 | none |
| C aspen | `944a398` (`aspen.pin`) | the lane's clone at `944a39821549…`; 6,817 lines of `.c` under `src/` | none |
| kasumi | | `/home` 26 GB free, load 14–17 on 16 cores (other lanes) | timing rows are interleaved medians, as ap00's |

Decided at launch (the orchestrator, recorded here): ap00's three rulings
as recommended. (1) The `-s` rows are this lane's ratchet: move the
column's formatting into the stat tasks, then gate `-s` and propose the
number. (2) Where C aspen differs from tree with no golden, the port
follows tree; the three known cases (`docs/MAP.md` §5) are the
maintainer's to file upstream. (3) Collation is measured here with a
number for a ruling, not decided.

## 3. What the surface needs that wolf does not have

Read from wolf 0.2.34's `spec/prelude.json` and wolf-std `e036bec`:

- **strftime** (`--timefmt`): none in wolf or wolf-std. aspen already
  reads TZif itself (`src/clock`, ap00); `--timefmt` adds aspen's own
  strftime over those fields, in the C locale (C aspen sets only
  `LC_CTYPE` and `LC_COLLATE`, `src/main.c:89`).
- **users** (`-u`, `-g`): wolf-std `std.os.users` parses `passwd(5)` and
  `group(5)` lines and asks no name service (its header, wolf-std#68). The
  port reads `/etc/passwd` and `/etc/group`; on macOS, where the directory
  service holds ordinary users, a uid the file does not name is asked of
  `/usr/bin/id -un UID`, the host's own tool, as the std header advises.
- **collation** (en_US.UTF-8's `strcoll`): no locale surface; measured
  (§4.6), not carried.
- **hostname** (`--hyperlink` without `--authority`, C aspen's
  `gethostname`, `src/render/unix.c:55`): no builtin. linux reads
  `/proc/sys/kernel/hostname`; macOS asks `/bin/hostname`.
- **realpath** (`--hyperlink`'s base, `src/render/unix.c:231`):
  `fs_realpath`, new in 0.2.34, so the bump is needed.
- **isatty** (colour's terminal check, `src/color.c:130`): `os_isatty`.
- **xattrs** (`--acl`, `--selinux`): none. tree 2.3.2 on linux accepts
  both (`--acl` prints a `+` after the permissions of a file with an ACL
  and a space otherwise; `--selinux` prints the security label, `(null)`
  for the root in the container); C aspen at the pin rejects both as an
  invalid argument (exit 1, `src/options.c:319`). Without `getxattr` the
  port cannot tell an ACL is present: they stay refused by name, a ruling
  asked (§9), and a wolf-lang issue listed.

## 4. Prediction (before the first change)

1. **The bump** (wolf 0.2.33 -> 0.2.34, std unchanged at `e036bec`)
   changes no output: the oracle 864 / 0 / 616, the golden suite
   308 / 0 / 616, the fuzzer 0 differences, the perf rows within ap00's
   bands. None of 0.2.34's seven new prelude names is a name aspen
   declares.
2. **The golden matrix's not-yet count falls by the contract's steps**
   (286 cases × 3 locales; 182 cases per locale need a v2 flag today):
   after the formats (`-X -H -T --nolinks --hintro --houtro -i
   --compress --charset -S`) 121 cases per locale remain not-yet (363);
   after the filters and trees (`--fromfile --fromtabfile --fflinks
   --condense --gitignore --gitfile --info --infofile --filelimit -l -x
   -R`) 46 (138); after the columns and sorts (`-u -g --inodes --device
   --si --timefmt -c -v --sort -U --filesfirst -q -N -Q --metafirst
   --opt-toggle`) 9 (27); after colour (`-C --hyperlink --scheme
   --authority`) none. Every newly counted case agrees in C and C.UTF-8;
   under en_US.UTF-8 the ones whose names collate differently from byte
   order (dot-names under `-a`, the `%V` version fixture's `1.0`/`10`
   and `foo.0`/`foo.009` neighbours, mixed case) stay not-yet as
   collation, so K at the end is collation alone plus whatever a ruling
   keeps (`--acl`, `--selinux` have no golden case). The other scripts'
   66 not-yet reports (usage 34, deviations 16, structural 12, outfile
   1, fpath 2, patterns 1) fall to 0, and `color.sh`, `pty.sh`,
   `rerun.sh`, `cyclic.sh`, `adversarial.sh` join `tools/golden` clean.
3. **What agrees at once**, once parsed and wired to what v1 already
   holds: `--charset X` and `-S` (`src/lines` has every set; the narrower
   widths and the comment glyphs are new), `-U`, `--filesfirst`, `-c`,
   `--si`, `--inodes`, `--device`, `-q`, `-N`, `-Q`, `--metafirst`,
   `--opt-toggle`, `-x`. The rest are new code: the XML and HTML
   renderers, colour, the gitignore and info stacks, the fromfile
   reader, `--condense`, `--filelimit`, `-l`'s cycle set, `-R`'s rerun,
   `-v`'s comparator, strftime.
4. **The hard ones**: `-R` (a second render of a subtree into
   `00Tree.html`, D6's standalone indentation, D8's no-op under `-J`/`-X`),
   `-l` (the sorted cycle set in both engines, D7, the `recursive, not
   followed` close indents in `-J`/`-X`), `--timefmt`'s 255-byte strftime
   limit (the golden's 300-`Z` case), and colour's PTY rows.
5. **The `-s` ratchet**: with each stat task formatting its chunk's
   bracket column (the bytes the text renderer prints) instead of
   answering words for the main thread to parse and format, `-s` on the
   100,000-file tree moves from 1.98–2.13× C aspen to within 1.5×, and
   the 1,000-entry directory from 1.23–1.30× to within 1.2×; the ruling
   asked is to gate `-s` at 1.5×.
6. **The memory**: a region per directory level in the streaming walk
   (the level's rows and entries die when its last entry is printed)
   takes the 100,000-file listing's peak RSS from 86 MB to under 10 MB
   (C aspen 2.8 MB); the full-tree modes keep the whole tree by design.
7. **Collation**: after every option is ported, the en_US.UTF-8 cases
   that differ only by order are counted and each is named; glibc's
   en_US collation is the locale's data (`/usr/share/i18n/locales`'s
   ISO 14651 table, the compiled `LC_COLLATE` in the archive), and the
   number put to the ruling is the cases it would move and the bytes it
   would carry.
8. **The extensions** (`--threads`, `--asp-diff`, `ASP_IO`): `--threads N`
   is small (the stat pool's worker count, 1 serial) and C aspen's own
   `threads.sh` and `cyclic.sh` need it, so it is ported and its ruling
   asked with that recommendation; `--asp-diff` (384 lines of C) and
   `ASP_IO` (io_uring, no wolf surface) are asked, not ported.

## 5. What landed, in the order the contract names it

All of C aspen's surface at the pin, ported from its `src/` (`docs/MAP.md`
§2 says where each file went); tree's options but two parse and act, and
C aspen's own `--threads`, `ASP_IO`, `ASP_TRACE_POOL` and `--asp-diff`
with them.

1. **The formats.** `-X` (`src/xml`), `-H` with `-T`, `--nolinks`,
   `--hintro`, `--houtro` (`src/html`; D3, A7), `-i` and `--compress N`
   in the text, JSON, XML and HTML renderers, `--charset X` and `-S` with
   tree's whole charset table and its missing-argument list (`src/lines`,
   `src/opts`).
2. **The filters and trees.** `--fromfile`, `--fromtabfile`, `--fflinks`
   (`src/fromfile`, nextpc's carried separator mirrored); `--condense`;
   `--gitignore`/`--gitfile` (`src/gitignore`) and `--info`/`--infofile`
   (`src/infofile`); `--filelimit` (D1, D2, SR-2.12); `-l` (D7, the
   recursive close indents); `-x`; `-R` (D6, D8). The walk carries C
   aspen's two renderer kinds, line (text, HTML) and nested (JSON, XML).
3. **The columns and sorts.** `-u`/`-g` (`/etc/passwd`, `/etc/group` by
   wolf-std `std.os.users`; macOS's `/usr/bin/id -un` for an account its
   files do not hold), `--inodes`/`--device` (D4), `--si` (its rounding
   of an inexact `double` quotient computed exactly), `--timefmt`
   (`src/tfmt`, aspen's own strftime in the host C library's dialect:
   glibc's on linux, its 254-byte cap measured; macOS's BSD one, whose
   flags, non-conversions and 255-byte cap differ, measured through its
   own `strftime` on nomad-1; both pinned by `src/tfmt_test.lu`),
   `-c`, `-v` (`src/vers`), `--sort`, `-U` (the host's order), the meta
   sorts, `-q`/`-N`/`-Q`, `--metafirst`, `--opt-toggle`.
4. **Colour.** `-C` and the environment's decision, tree's default map,
   the terminal check (`os_isatty`), `--hyperlink`/`--scheme`/
   `--authority` (`fs_realpath`, new in 0.2.34; the host name from
   `/proc/sys/kernel/hostname`, or `/bin/hostname` on macOS).
5. **The extensions** (C aspen's own): `--threads N` (the pool's worker
   count, strictly parsed), `ASP_IO=serial`, `ASP_IO=uring` (C aspen's
   own notice that io_uring is unavailable: wolf has no io_uring),
   `ASP_TRACE_POOL`; `--asp-diff A B` (two trees merged by name, the
   changes drawn), whose oracle is C aspen itself (`tools/aspdiff`).

Where C aspen differs from tree with no golden, the port follows tree,
each measured in the oracle's container: six places beyond ap00's three
(`docs/MAP.md` §5, items 4–9): `--gitignore`'s walk up, `--gitfile` and
`--infofile` loaded as parsed (every one kept, a missing one an error),
`-H`'s root typed and classed by its `lstat`, `-H -C`'s class of an
entry, `--hyperlink` on a root that exists but cannot be opened, `-X`'s
`<link>` root.

## 6. Evidence index

Every number was measured; where is named. The kasumi record is
`notes/ap01-evidence/kasumi-gauntlet.sh` and its log
`notes/ap01-evidence/kasumi-gauntlet.log` (every gate in order, an exit
status per step), run at `5c5bc72` exactly (the header's "2 files"
uncommitted are the sync's own `.gauntlet-rev` and `.gauntlet-dirty`,
which list nothing else). CI runs are §6.10.

### 6.1 The oracle of record: C aspen's golden suite

`tools/golden` now runs every script C aspen's own `tests/run.sh` runs
against its binary (but `flag_coverage.sh`, a lint of C aspen's own
options.c, and `fuzz.sh`, which is `tools/fuzz`), in its order, with
`color.sh`, `pty.sh`, `rerun.sh`, `cyclic.sh`, `threads.sh` and
`adversarial.sh` new; their four colour fixtures are made first by C
aspen's own generators (its runner makes only the corpus, so the colour
rows would list missing roots).

- `run.sh`, the matrix: **286 cases × 3 locales: 829 agree / 0 differ /
  29 not-yet.** Every case agrees in C and C.UTF-8 (572). The 29 are all
  under en_US.UTF-8, all by collation alone (§6.6).
- The other 15 scripts: **0 STOP reports, 0 skips**: walk, color, pty,
  outfile, rerun, cyclic (30 inode layouts), adversarial, patterns,
  fpath, usage, fdlimit, threads, deviations (every one of D1–D8, A4,
  A7, SR-2.12), structural.
- **Total: 829 agree / 0 differ / 29 not-yet** (ap00: 308 / 0 / 616), on
  kasumi on the native, release and static binaries and in CI on the
  release one; 0 skips, 0 reports of tree's undefined behaviour.
- macOS (CI, run 39669091691): **849 agree / 0 differ / 9 not-yet**, the
  9 the en_US.UTF-8 cases macOS's own byte-order collation still
  differs on, and the one report counted as tree's undefined behaviour
  (adversarial.sh's `fromfile-64k-line`, §9.6), printed with its diff.

Where tree 2.3.2 itself faults: only on C aspen's adversarial
`fromfile-64k-line` input, a `--fromfile` line of 65,535 bytes or more
(65,534 lists), `*** buffer overflow detected ***`, status 134, on every
golden pass (the fortified linux build). Its cores reached kasumi's host
store from inside the rootless container (the host's piped
`core_pattern` ignores the container's limit); `tools/in-container` now
runs every command under `ulimit -c 0`, and the runs since store none.
The port does not copy the fault: aspen lists the whole line as one
name, as tree does at every length it can read.

### 6.2 The fixture oracle

`tools/oracle`: 196 sets (66 of ap00's, 130 new: every option, and the
combinations each renderer meets) over eight roots (ap00's seven and
`extra`: two `.gitignore` levels, a `.info`, version names, condense
chains, link loops), the `--fromfile` sets over two input files, in C
and C.UTF-8: **2,904 agree / 0 differ / 32 not-yet**; the 32 are
`--acl` and `--selinux`, refused by name, status 2. It now carries the
law's normalisations the golden suite does (A7, D3, D4, D1 under
`--filelimit`/`--condense`); a set may name its own roots (SR-2.12's
`--du` root, kept out of a set it would trip), and no set pairs `-l`
with a full-tree mode (D7: tree's visited check there follows the
host's directory order). Native, release and static binaries.

### 6.3 The fuzzer

`tools/fuzz` with C aspen's whole flag pool (`-l -x -i -u -g -Q -N -q -C
-S -c -v -U --condense --compress …`, the classifier no longer cuts
any): **2,000 trees × 2 locales = 4,000 runs, 0 differences** on kasumi;
200 trees in every CI run. D1's status is now carried under
`--condense` and `--filelimit` too (the first 500-tree run differed only
there, `rc aspen 2, tree 0`, which deviations.sh asserts).

### 6.4 `--asp-diff` against C aspen

`tools/aspdiff`: a pair of trees differing in every way the merge tells
apart, an identical pair, an empty one against a full one, and the
error rows, under 22 flag sets in C and C.UTF-8: **44 runs, 0
differences.**

### 6.5 The unit tests

`tools/check-test`: six files (`src/tfmt_test.lu` new), each a `main` of
asserts, pass on the checked machine (no native fallback), natively, and
on lupin 0.1.55.
New rows: `--si`'s tie rounding (17 values, Python's `%.1f` as the
witness of glibc's), the 32-bit id cast, every value-taking long
option's wordings, `--opt-toggle`, `--threads`' strict parse, `atoi`'s
cut, `--gitfile`/`--infofile`'s loads, and strftime in both dialects (glibc's
and BSD's flags, widths and caps, measured with each libc's own
`strftime` through Python's ctypes as the witness).

### 6.6 Collation, the number for the ruling

`tools/collation` (in CI's linux job too): every one of the 286 cases
under `LC_ALL=en_US.UTF-8`; a case that differs from tree runs again
with tree under `LC_CTYPE=en_US.UTF-8 LC_COLLATE=C`. **29 of 286 differ,
29 of them by collation alone** (tree under byte order agrees, so names,
line set and everything else are right): the dot names under `-a`,
`%V`'s version names under `--compress`, `.info` files, mixed case.
What carrying it would take: glibc's en_US collation is its locale
data, ISO 14651's table `/usr/share/i18n/locales/iso14651_t1_common`,
**3,386,286 bytes, 85,612 lines, 30,677 collating elements**, compiled
into the 3,064,432-byte `locale-archive` (glibc's binary format, whose
reader is glibc's source, so out of bounds); macOS's en_US.UTF-8
collates by byte. The plant (§6.11) shows why the gate is a gate of its
own: under en_US the golden matrix counts every difference not-yet.

### 6.7 Speed: the `-s` ratchet

`tools/perf`, the container, `taskset -c 0-3`, median of three,
interleaved; `-s` is now gated at 2× C aspen beside the listing.

| row | tree | C aspen | aspen | aspen / C aspen | ap00's | gate |
|---|---:|---:|---:|---:|---:|---|
| wide1k, the listing | 2.5–2.7 ms | 1.8–1.9 ms | 2.1–2.3 ms | 1.10–1.23 | 1.07–1.13 | 2× |
| tree100k, the listing | 91.5–98.4 ms | 22.8–24.1 ms | 38.6–40.2 ms | 1.67–1.72 | 1.61–1.67 | 2× |
| wide1k, `-s` | 2.4–2.5 ms | 2.0–2.2 ms | 2.4–2.5 ms | 1.14–1.17 | 1.23–1.30 | 2× (new) |
| tree100k, `-s` | 96.5–100.5 ms | 44.2–44.7 ms | 70.4–72.1 ms | 1.58–1.63 | 1.98–2.13 | 2× (new) |

(The gauntlet's three passes at `5c5bc72`, kasumi at load 0.3; earlier
in the day at load 5–17 the same build read 1.75–1.83× and 1.63–1.90×
on the 100,000-file rows. CI's run at `5c5bc72`: 1.14×, 1.71×, 1.23×,
1.53×.) A probe of the costs underneath (`notes/ap01-evidence/probes/
spawn-and-lstat.lu`, the container): 400 scopes of four tasks cost 4–5
ms, 100,000 `fs_lstat` calls of one path 58 ms; the task's other work
per name (the path, the words, the column) was most of `-s`'s cost
until (1), (2) and (4) below.

What moved `-s`: (1) the stat tasks build their own paths from the
directory and a buffer of the chunk's names, (2) in the text format they
format the bracket column themselves and the main thread copies its
bytes (a column's place packed in one `int`), (3) the main thread stats
a chunk itself, as C aspen's submitting thread is a pool lane
(`src/pool.c:152`), (4) each name's path and twenty stat words die in a
`region` of their own, only the numbers kept, (5) the entry back to
ap00's size: the owners, the identity and the rare fields in side
tables. (5) mattered for the listing too: padding ap00's entry by the 13
words ap01 first added cost 15% of the 100,000-file listing (34.9 ms to
40.3 ms, kasumi's host). A level the host already lists in name order
(tmpfs, btrfs) is sorted in one pass. The prediction said 1.5×: the
100,000-file `-s` row misses it by a little (CI 1.53×, kasumi
1.58–1.63×), standing on the listing's own 1.67–1.72×; the ratchet asked
(§9) is 2× now.

### 6.8 Memory

`tools/mem`, peak RSS (`wait4` of a small helper's child) over the
100,000-file tree, the container:

| tree100k | aspen | C aspen | ap01's first build |
|---|---:|---:|---:|
| the listing | 59.9 MB | 2.6 MB | 82 MB |
| `-s` | 76.8 MB | 2.6 MB | 164 MB |
| `-J` | 129.1 MB | 12.7 MB | 171 MB |
| `--du` | 134.9 MB | 18.7 MB | 233 MB |
| `-pugsD` | 157.6 MB | 3.4 MB | 210 MB |

ap00 measured 86 MB for the listing (`/usr/bin/time`, kasumi's host;
the same tool there now says 64 MB). The contract's lever, a region per
directory level, does not compile: the region checker refuses a level
whose body pushes into the writer that outlives it (E1010, "`a` still
holds a value allocated in region `lv` when the region is freed"), even a
byte push, and even inside `in keep { }` for a first-class region the
writer was built in (the two probes,
`notes/ap01-evidence/probes/region-per-level.lu` and
`region-first-class.lu`, each refused with that error at 0.2.34). What
did land: a region per stat, the path and the twenty words dying with
each name (`-s` 131 to 77 MB, `--du` 190 to 137, `-pugsD` 210 to 157),
and the entry back to ap00's size (the listing 82 to 60 MB).

### 6.9 The static build

`tools/mkaspen` in an Ubuntu 24.04 container at `5c5bc72`: ET_EXEC, no
PT_INTERP, **built twice to one digest
`724f82f5cc209f73506cc42ce541836a3497b2afd9a3a2667b10a734cb0cf493`,
15,306,624 bytes; stripped 1,927,320 bytes** (under 2 MiB; ap00's
1,577,336: the renderers, colour, the filters, strftime). The oracle on
it 2,904 / 0 / 32, the golden suite 829 / 0 / 29. CI's own build (the
runner's clang and libc.a) reproduces its own digest, stripped
1,923,784 bytes.

### 6.10 CI runs

- PR #4's `tier pr` runs, every one green but 39658068654 (`06817db`),
  cancelled by the next push before it finished: 39656603754 (`ad23a3a`),
  39658829070 (`d9f1857`), 39661953386 (`e26c687`), 39667357973
  (`2e6a394`), 39669102889 (`83a00a4`), 39672434557 (`5c5bc72`: oracle
  2,904 / 0 / 32 native and release, golden 829 / 0 / 29, fuzz 400 runs 0 differences, aspdiff 44
  / 0, collation 29 / 29 by collation alone, perf 1.14× 1.71× 1.23×
  1.53×, the static build and its oracle, selftest).
- macOS, by partial dispatch (`-f jobs=macos`): 39662338385 (`e26c687`)
  found two things linux cannot: macOS's strftime is BSD's (the oracle's
  `timefmt-flags` set, 14 differences, and the golden's 270-`Z` case,
  where BSD fills all 255 bytes), fixed in `bab38e0`; and C aspen's
  adversarial 64 KiB row against tree's buffer overflow (§9.6).
  39667348534 (`2e6a394`): oracle 2,904 / 0 / 32, golden 849 / 1 / 9
  (that row; the 9 not-yet are en_US.UTF-8, where macOS collates `.info`
  fixture names differently too). 39669091691 (`83a00a4`): the macOS job
  green (oracle 2,904 / 0 / 32, golden 849 / 0 / 9 with the one UB
  report, fuzz 200 runs 0 differences, aspdiff 44 / 0); its `tier
  partial` verdict job failed with no steps and no log (GitHub's
  BlobNotFound), so it is no evidence either way: the full tier at the
  final head runs macOS again.
- The full tier at the final head: the run the hand-back names.

### 6.11 The plants

Each a draft PR on ap01's head `d9f1857`, closed unmerged, seen red in
its own pull-request run (RULES §7: on this repository the PR run
itself); `tier pr` red in every one:

- **The renderers**, PR #5 (`594a848`, `-X`'s indent unit three spaces):
  run 39658965501, job 119426701498: the oracle red on native, release
  and static (2,706 agree / 198 differ), the golden suite (755 / 59 /
  53), the fuzzer (10 differences in 190 runs) and the collation gate
  (25 en_US differences not collation).
- **Colour**, PR #6 (`a1cb8c8`, the default end code `00`): run
  39658971675, job 119426728436: the golden suite red on color.sh (6
  STOP reports) and pty.sh (3), everything else green.
- **`-R`**, PR #7 (`8ace0fc`, the files named `00tree.html`): run
  39658976118, job 119426737534: the golden suite red on rerun.sh (20
  STOP reports) and deviations.sh's D6, everything else green.
- **`--asp-diff`**, PR #8 (`50b86b6`, a modified entry marked `[*]`):
  run 39658981417, job 119426754254: tools/aspdiff red (28 differences
  in 44 runs), everything else green.
- **Collation**, PR #9 (`b22022c`, no report under en_US): run
  39658985648, job 119426790938: tools/collation red (274 differences, 0
  by collation alone) and threads.sh (its en_US rows, 9 STOP reports),
  while the golden matrix counted all 274 not-yet.
- **`-s`**, PR #10 (`29732f4`, every name stat'ed eight times): run
  39658991774, job 119426803926: the perf step red alone, `-s` at 3.48×
  C aspen on the 1,000-entry directory and 8.04× on the 100,000-file
  tree, the listing rows inside 2×.

## 7. Done-when

- [x] The refusal list: every option ported but `--acl` and `--selinux`
  (no extended-attribute call in wolf), whose ruling is asked (§9).
- [x] The golden matrix 829 / 0 / 29, K the en_US.UTF-8 cases alone, all
  by collation, whose ruling is asked; every other golden script 0
  STOP reports.
- [x] The fixture oracle 2,904 / 0 / 32 (K: `--acl`, `--selinux`); the
  fuzzer 4,000 runs, 0 differences; `--asp-diff` 44 runs, 0
  differences.
- [x] The perf rows within 2× of C aspen, the listing and `-s` (the
  ratchet asked).
- [x] Each new gate seen red in CI (§6.11).
- [x] PR #4 with the five sections; `tier pr` green and the
  `full-matrix` label at the final head (this note's commit) and the lane
  audit follow the commit, named in the hand-back.

## 8. Issues to file (none filed by the lane)

- **tenseleyFlow/aspen** (the maintainer's): ap00's three (`docs/MAP.md`
  §5 items 1–3) and ap01's six (items 4–9): the parent `.gitignore`
  walk-up its `src/filter.h:11` names "NOT YET"; `--gitfile`/`--infofile`
  load errors and multiples; `-H`'s root type and class (a non-directory
  root under `-C` reaches `e->type` through a NULL entry,
  `src/render/html.c:136`); `-H -C`'s class of an entry; `--hyperlink`
  on an unopenable root; `-X`'s symlink root; and its own
  `tests/golden/adversarial.sh` row `fromfile-64k-line`, which compares
  against tree's buffer overflow wherever tree survives it (§9.6).
- **wolf-lang**: no `getxattr`/`listxattr` (tree's `--acl` and
  `--selinux`); the region checker refuses a per-iteration region whose
  body pushes into a list that outlives it, even under `in r { }` for a
  first-class region (E1010; aspen's per-level region, with the probe);
  the release tier cannot compile a closure handed to another module's
  function ("a vtable slot `@main.cls0` outside this object's subset",
  the parser's file probe, worked around); `wolf fmt` is not idempotent
  on a multi-line `if` expression as a call argument (`out.\n s(`, worked
  around); no host-name builtin (`gethostname`); ap00's three (List bulk
  append and capacity, channel `List` payloads, the path-only fs
  surface) stand.
- **wolf-std**: a collation surface (`strcoll`), now with the number
  (§6.6); `localtime`/`strftime` (aspen carries its own, `src/clock`,
  `src/tfmt`).

## 9. Rulings asked (each recommendation implemented)

1. **`--acl` and `--selinux`**: refused by name, status 2, until wolf can
   read extended attributes. Recommendation: keep the refusal; the
   wolf-lang issue (§8).
2. **Collation** (the number, §6.6): 29 of 286 golden cases, en_US.UTF-8
   alone, every one by order; carrying it is a 3.4 MB ISO 14651 table and
   a multi-level comparison, or a wolf-std surface. Recommendation: keep
   byte order (macOS's en_US already collates so), K stays 29, the
   wolf-std issue.
3. **The `-s` ratchet**: gated at 2× of C aspen (CI 1.23×/1.53×,
   kasumi 1.14–1.17×/1.58–1.63× at `5c5bc72`).
   Recommendation: 2× now, 1.5× when the listing reaches it (its own
   1.67–1.72× on the 100,000-file tree is the floor `-s` stands on).
4. **C aspen's extensions**: carried: `--threads`, `ASP_IO`,
   `ASP_TRACE_POOL` (C aspen's threads.sh and cyclic.sh read them) and
   `--asp-diff` (tested against C aspen); `ASP_PREFETCH` (an opt-in
   cache warm-up that changes no output) is not. Recommendation: keep
   them, they are C aspen's surface.
5. **The memory**: reported, not gated (§6.8), the per-level region
   blocked by E1010. Recommendation: the wolf-lang issue; ap02 takes the
   region once the checker allows it.
6. **C aspen's adversarial.sh row `fromfile-64k-line` on macOS**: a
   disagreement with tree on a golden, which the rules make a STOP, so it
   is put here with the diff rather than passed: tree 2.3.2 overflows its
   own 64 KiB line buffer on that input (measured in the container: a
   65,534-byte line lists, a 65,535-byte one aborts the fortified linux
   build, `*** buffer overflow detected ***`, status 134, which the
   script skips as a crash), and Homebrew's macOS build survives the
   overflow printing an empty name and `a` (`├── ` / `└── a`) where aspen
   prints the 65,535-byte name and `a`, as linux's tree does for every
   length it can read. `tools/golden` counts that one report as tree's
   undefined behaviour, printed with its diff, not as a STOP.
   Recommendation: keep it so; the C aspen issue (its row compares
   against tree's overflow where tree does not crash).

## 10. ap02's contract, drafted

### ap02 — The third light (aspen: the ratchets and the last two options)

**Draft by ap01 for the orchestrator. Opus. Crawl 54 or later.** Rulings
#102 and #103 (`sprints/aspen/index.md`) and ap01's (its note §9). aspen
after ap01 (PR #4 on wolffe-lang/aspen) is byte-identical to tree 2.3.2
and to C aspen across tree's surface but `--acl` and `--selinux`, with C
aspen's own extensions; what is left is speed, memory, two options that
wait on wolf, and whatever the collation ruling says.

**1. The listing's speed.** The 100,000-file listing stands at 1.67–1.72×
C aspen (the 1,000-entry directory 1.1–1.2×), and `-s` on it: the rows
`fs_read_dir_entries` answers (one list per name, the runtime's
`list_from_bytes`), the indentation's byte pushes, the fresh pages the
arena faults in. Measure each with `perf` on kasumi, move what aspen's
own code can, file what the runtime must; the ruling ap01 asked sets the
`-s` gate at 2× now and 1.5× when the listing gets there.

**2. The memory.** The 100,000-file listing holds 60 MB (C aspen 2.6 MB),
`-s` 77, `-J` 129, `--du` 135: a region per directory level is refused by
the region checker (E1010) the moment the level pushes into the writer
that outlives it (ap01's probes, `notes/ap01-evidence/probes/`). When
wolf-lang answers that issue (or gives `List` a capacity and reuse
surface), the streaming walk takes a region per level; the full-tree
modes keep their tree by design.

**3. What waits on wolf.** `--acl` and `--selinux` once wolf can read
extended attributes (`getxattr`, `listxattr`; tree's `+` after the
permissions, the security label, `(null)` for the root in the
container); a name that is not UTF-8 once a path can be bytes
(wolf-lang#687).

**4. Collation**, as ruled: if carried, ISO 14651's multi-level order
from glibc's locale sources (`iso14651_t1_common`, data, not code) for
the 29 golden cases ap01 counted; if not, nothing.

**5. Gates.** As ap01's: every change counted in `tools/golden`
(829 / 0 / 29 at ap01), `tools/oracle` (2,904 / 0 / 32), `tools/fuzz`,
`tools/aspdiff`, `tools/collation`, `tools/perf`, `tools/mem` (gate it
when the region lands); a plant per new gate seen red in CI; `tier pr`
green and the `full-matrix` label at the final head.

## Forbidden / rules
As ap01's: `sprints/RULES.md`, the track's rules, ruling #103's three
limits; the goldens and `deviations.sh` are the law and never edited;
where C aspen differs from tree with no golden, follow tree and list the
C aspen issue; no dependency but wolf-std; no builds on nomad-1; every
oracle, perf row, memory row and fixture with a FIFO or a 0000
directory in the oracle's container.

## Inputs (re-derive)
aspen trunk after ap01's merge; C aspen `944a398`; tree 2.3.2-1; the
toolchain pin or the next release; ap01's note §6 (the rows) and §8 (the
issues, and which of them wolf-lang has answered).

## Prediction (write before the first change)
To be written by ap02: which of the listing's costs are aspen's to move
and which the runtime's, the rows after each step, whether wolf has
answered the region and xattr issues.

## Done-when
The perf rows within the ratchet the ruling sets; the memory row
measured against its prediction (gated if the region lands); the
refusal list empty or each remaining refusal ruled; the golden matrix
`N agree / 0 differ / K not-yet` with K only what a ruling keeps; PR
open per RULES §6.
