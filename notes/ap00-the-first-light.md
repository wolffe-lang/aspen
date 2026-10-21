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
| C aspen's golden suite | the oracle of record | live, not recorded: `tests/golden/run.sh` runs ~243 flag sets over 14 generated fixture trees in C, en_US.UTF-8 and C.UTF-8 against a tree 2.3.2 that `build-ref.sh` builds from tree's source; the lane pre-places the distribution's tree 2.3.2 binary at the path `build-ref.sh` checks first, so nothing clones or builds tree's source | the harness is per-binary, not per-option: the lane's `tools/oracle` runs its case list, fixtures and normalisations verbatim and classes each case v1 or not-yet |
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
