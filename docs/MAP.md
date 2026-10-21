# MAP — C aspen at `944a398`, and where each piece lives in wolf

aspen is a port of tenseleyFlow/aspen (MIT, the maintainer's), itself
written with tree 2.3.2 (GPL-2.0-or-later) as reference; this repository
GPL-3.0-or-later (ruling #103). This file is the port's map: the C's
files, the flag surface, the golden suite, the fuzzer and the bench, and
which part is v1 (ap00) and which is ap01's or later. It is yw00's shape
for yew.

The C is read at `aspen.pin` (`944a39821549…`) from a clone of the
maintainer's checkout: only git-tracked files. The maintainer's local,
untracked `.docs/` (planning, audits of tree's internals, and checkouts of
unix-tree and bfs) is never read beyond its file names (ruling #103,
limit 1).

## 1. Provenance

`git shortlog -sn --all` at the pin: 174 commits, every one `mfwolffe
<mfwolffe@outlook.com>`. C aspen was written with tree's source open, and
says so where it matters; these are recorded here as provenance and are
NOT links the port follows (ruling #103, limit 2). The `file:line` C aspen
cites in tree's source, by where it cites it:

| C aspen | cites tree's |
|---|---|
| `src/color.c:26` | `color.c:140` |
| `src/options.c:195` | `tree.c:112` |
| `src/options.c:208` | `tree.c:121` |
| `src/options.c:213` | `tree.c:122` |
| `src/options.c:240` | `tree.c:464` |
| `src/traverse.c:253` | `file.c:132` |
| `src/traverse.c:451` | `tree.c:898` |
| `src/traverse.c:681`, `:748` | `list.c:209` |
| `src/traverse.c:682` | `list.c:204` |
| `src/traverse.c:720`, `:993` | `list.c:148` |
| `tests/golden/patterns.sh:4` | `file.c:132` |
| `tests/golden/usage.sh:72` | `tree.c:464` |

And prose that names a tree function or file without a line ("faithful to
tree's html.c", "tree's patmatch()", "tree's printit()"): `src/charset.c`
1, `src/color.h` 1, `src/filter.h` 1, `src/fromfile.c` 1,
`src/fromfile.h` 2, `src/glob.c` 1 (its header: "Ported from tree's
patmatch()"), `src/info.h` 1, `src/render/html.c` 2, `src/render/html.h`
1, `src/render/json.h` 1, `src/render/name.h` 1, `src/render/unix.c` 1,
`src/traverse.c` 1.

## 2. The C, file by file (7,872 lines under `src/`)

| C file | lines | what it is | wolf | v1? |
|---|---:|---|---|---|
| `src/main.c` | 184 | entry, locale, `-o FILE`, renderer pick, `--asp-debug-walk` | `src/aspen.lu` | yes (`--asp-diff`: ap01) |
| `src/options.c`, `.h` | 422 + 87 | tree's command line, usage text | `src/opts` | yes: v1 flags parse, the rest refused by name |
| `src/traverse.c`, `.h` | 1,427 + 45 | the walk: read, filter, stat, descend; streaming and full-tree engines; `--prune`, `--du`, `--condense`, `--filelimit`, `--fromfile` | `src/walk` | yes but `--condense`, `--filelimit`, `--fromfile`, `-l`, `-x`, `-R`, `--gitignore`, `--info` |
| `src/sort.c`, `.h` | 288 + 32 | tree's comparators; MSD radix for names | `src/walk` (`order`) | name, `-t`, `-r`, `--dirsfirst` (`-v`, `-c`, `-U`, `--sort`, `--filesfirst`: ap01) |
| `src/glob.c`, `.h` | 115 + 15 | tree's patmatch | `src/glob` | yes |
| `src/charset.c`, `.h` | 157 + 35 | the line-drawing table | `src/lines` | yes, widest forms (`--compress`, `--charset`, `-S`: ap01) |
| `src/render/unix.c`, `.h` | 418 + 43 | the text renderer | `src/text` | yes but colour, hyperlinks, `--metafirst`, `-i`, `--info` comments |
| `src/render/name.c`, `.h` | 129 + 21 | name escaping (printit) | `src/name` | default branch (`-q`, `-N`, `-Q`: ap01) |
| `src/render/fileinfo.c`, `.h` | 130 + 28 | `[perm user group size date]` | `src/info`, `src/clock` | `-p`, `-s`, `-h`, `-D` (`-u`, `-g`, `--si`, `--inodes`, `--device`, `--timefmt`, `-c`: ap01) |
| `src/render/json.c`, `.h` | 349 + 25 | `-J` | `src/json` | yes but `-i`'s compact form, `--compress`, `--info` |
| `src/render/outbuf.c`, `.h`, `src/dstr.c`, `.h` | 33 + 23, 58 + 27 | buffered output | `src/out` | yes |
| `src/entry.c`, `.h` | 41 + 58 | one entry | `src/ent` | yes |
| `src/sys/dir.c`, `.h`, `src/sys/xstat.c`, `.h` | 227 + 45, 34 + 39 | getdents64 / fstatat | wolf-std's `fs_read_dir_entries`, `fs_lstat`, `fs_stat`, `fs_read_link` | yes (path-based, not fd-relative) |
| `src/pool.c`, `.h` | 224 + 34 | the parallel stat pool | `src/walk` (`stat_batch`: `scope`/`spawn`, same thresholds) | yes |
| `src/iouring.c`, `.h` | 134 + 34 | io_uring statx batches (`ASP_IO=uring`) | — | ap01+ (no wolf surface) |
| `src/render/xml.c`, `.h` | 325 + 24 | `-X` | — | ap01 |
| `src/render/html.c`, `.h`, `src/render/escape.c`, `.h` | 354 + 29, 51 + 20 | `-H`, `-T`, `--nolinks`, URL encoding | — | ap01 |
| `src/color.c`, `.h` | 249 + 41 | `-C`, LS_COLORS/TREE_COLORS | — | ap01 |
| `src/filter.c`, `.h` | 185 + 48 | `--gitignore`, `--gitfile` | — | ap01 |
| `src/info.c`, `.h` | 152 + 37 | `--info`, `--infofile` | — | ap01 |
| `src/fromfile.c`, `.h` | 299 + 41 | `--fromfile`, `--fromtabfile`, `--fflinks` | — | ap01 |
| `src/idcache.c`, `.h` | 76 + 17 | `-u`/`-g` name caches | — | ap01 (wolf-std `std.os.users`) |
| `src/verscmp.c`, `.h` | 68 + 22 | `-v` | — | ap01 |
| `src/hashtab.c`, `.h` | 82 + 24 | `-l` cycle set | — | ap01 |
| `src/diff.c`, `.h` | 384 + 31 | `--asp-diff` (aspen-only) | — | ap01+ |
| `src/arena.c`, `.h`, `src/util.c`, `.h`, `src/version.h` | 124 + 41, 67 + 22, 7 | allocation, helpers, the version | wolf's regions; `opts.version()` | — |

`asp` is the same binary under a second name (`Makefile:81–83`;
`make install` symlinks it, `:121`): v1 needs no second binary.

## 3. The flag surface

tree 2.3.2's flags (its `--help`, C aspen's `src/options.c:33`), by status
in aspen v1. A v2 flag is refused by name, exit 2
(`aspen: -X: not implemented in aspen v1 (tree's option, ap01's to port)`).

| v1 | v2 (refused by name; ap01's) |
|---|---|
| `-a -d -f -F -s -h -p -D -r -t -A -n -J`, `-L level`, `-P pattern`, `-I pattern`, `-o file`, `--ignore-case --matchdirs --prune --noreport --dirsfirst --du`, `--help --version --`; C aspen's test hook `--asp-debug-walk` | `-C -X -H -T -l -x -R -u -g -q -N -Q -S -c -v -U -i`, `--fromfile --fromtabfile --fflinks --filelimit --charset --sort --inodes --device --timefmt --si --filesfirst --metafirst --gitignore --gitfile --info --infofile --condense --compress --hyperlink --scheme --authority --opt-toggle --nolinks --hintro --houtro --acl --selinux`, C aspen's `--threads` |

`-A` is tree's ANSI (VT100 alternate character set) line set, not ASCII:
the manual says so ("-A Turn on ANSI line graphics hack"), and C aspen's
table carries it (`src/charset.c:73`). The plain ASCII set is the C
locale's default; the UTF-8 set is any installed UTF-8 locale's.

## 4. The golden suite (`tests/golden/`, the oracle of record)

A live differential, not recorded outputs: each script runs `./aspen` and a
tree 2.3.2 (`tests/.work/ref/tree-2.3.2`, which `build-ref.sh` would build
from tree's source; aspen's `tools/golden` puts the distribution's binary
there first, so nothing is cloned or built) and compares stdout, stderr
and exit status, normalising only the program name (`run.sh:350`) and the
two documented deviations' shapes (`run.sh:359`).

| script | what | v1's reading |
|---|---|---|
| `run.sh` | 286 flag sets over 14 generated fixtures (`mk*.sh`), in C, en_US.UTF-8 and C.UTF-8 | every case counted: v1 or not-yet by its flags |
| `walk.sh` | discovery against `tree -fiN` | v1 |
| `outfile.sh`, `fpath.sh`, `patterns.sh` | `-o`, `-f` roots, `-P`/`-I` paths | v1 but their `-X` rows |
| `usage.sh` | `--help`, bad command lines, missing arguments | v1 but the v2 options' rows |
| `deviations.sh` | the law where C aspen and tree disagree (D1–D8, A4, A7, SR-2.12) | D1 (`--du`/`--prune`/`--matchdirs`), D5, A4-residual are v1 |
| `structural.sh` | `-J`/`-X` well-formed | `-J` v1 |
| `fdlimit.sh` | a 250-deep chain under a low fd limit | v1 (wolf's walk is path-based: no fd per depth) |
| `fuzz.sh` | seeded random trees | its generator and normalisations, v1's flags: `tools/fuzz` |
| `color.sh`, `pty.sh`, `rerun.sh`, `cyclic.sh`, `threads.sh`, `adversarial.sh` | colour, `-R`, `-l`, `--threads`, `--gitignore`/`--fromfile`/`TREE_COLORS` inputs | ap01 |
| `flag_coverage.sh` | a lint over C aspen's own `options.c` | C aspen's |

The deviations v1 carries (C aspen's law, `tests/golden/deviations.sh`):
D1, exit 2 on an open error under `--du`/`--prune`/`--matchdirs` where tree
exits 0; D2, no empty `"contents":[ ]` after an error in `-J`; D5, `-Pfoo`
is `-P foo` and long options match exactly; A4-residual, under `--prune` a
`-P` that matches a directory's name gives it no special reveal unless
`--matchdirs`.

## 5. Where the port follows tree over C aspen

Three places where C aspen at the pin differs from tree 2.3.2, no golden
covers it, and no deviation documents it. The port follows tree, the
backstop oracle and C aspen's own invariant ("Parity is the floor",
README); each is an issue to file on tenseleyFlow/aspen (listed in the
lane's report, not filed):

1. `-J` on a root that is a symlink to a directory: tree types it
   `"link"`; C aspen says `"directory"` unless a metadata flag stat'ed the
   root (`src/render/json.c:294`).
2. `--du` with a root that is a file: tree counts its size in the report
   (`5 bytes used in 0 directories, 1 file`); C aspen reports 0
   (`src/traverse.c:1280` counts the file and adds no size).
3. `--du` with several roots: tree sums every root's total (`45 bytes`
   for a 5-byte file and an empty directory; 20,860 for `wide deny`); C
   aspen keeps the last root's (`tot->size = rs.size`,
   `src/traverse.c:1378`, `:1397`; 40 and 220).

## 6. Bench

C aspen's README (its measurements, warm cache, ~200k entries):
Linux x86-64 4.7× (flat), 5.2× (wide), 4.7× (mixed), 2.5× (deep) faster
than tree; macOS 2.8×, 3.4×, 2.7×, 1.6×; 1.3–1.5× when a flag stats every
entry. Its gate (`bench/gate.sh`): faster than tree.

ap00's row (`tools/perf`, the container on kasumi, `taskset -c 0-3`,
median of three, interleaved; the numbers are in
`notes/ap00-the-first-light.md` §4): the listing gated at 2× C aspen on a
1,000-entry directory and a 100,000-file tree; `-s` measured, not gated.

## 7. Gaps, named

- **Collation.** v1 sorts by byte in every locale. tree and C aspen use
  `strcoll` (`src/sort.c:244`); C and C.UTF-8 collate by byte, so they
  agree; a dictionary locale (en_US.UTF-8) can order differently (4 of the
  golden matrix's v1 cases, every one a dot-name order). ap01.
- **Locale detection** reads `LC_ALL`/`LC_CTYPE`/`LANG` and the installed
  locale files, since wolf has no `setlocale` (`src/locale`).
- **iswprint** is approximated (C0/C1 controls, DEL, U+2028/2029 are not
  printable; everything else is), where glibc also excludes unassigned
  code points (`src/name`).
- **Non-UTF-8 names** cannot be stat'ed or descended: wolf paths are `str`
  (wolf-lang#687). No golden or fuzzer name is one.
- **Speed under `-s`.** Both stat on a pool; aspen's main thread still
  does more per entry (a path string, a twenty-word `fs_lstat` answer),
  so `-s` is measured, not gated (ap01: the ratchet ruling).
- **Memory.** wolf's ambient region keeps every level's rows until the
  end: 86 MB for the 100,000-file listing against C aspen's 2.8 MB
  (`/usr/bin/time`, kasumi). A per-level region is ap01's.
- **Colour.** v1 never colours; a terminal with `LS_COLORS` set gets
  tree's colours from tree and none from aspen (`-C` is refused).
