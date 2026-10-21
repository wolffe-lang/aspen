# MAP — C aspen at `944a398`, and where each piece lives in wolf

aspen is a port of tenseleyFlow/aspen (MIT, the maintainer's), itself
written with tree 2.3.2 (GPL-2.0-or-later) as reference; this repository
GPL-3.0-or-later (ruling #103). This file is the port's map: the C's
files, the flag surface, the golden suite, the fuzzer and the bench, and
where each part landed: v1 (ap00) or ap01. It is yw00's shape for yew.

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

| C file | lines | what it is | wolf | ported |
|---|---:|---|---|---|
| `src/main.c` | 184 | entry, locale, `-o FILE`, colour's decision, renderer pick, `--asp-debug-walk` | `src/aspen.lu` | v1, ap01 (`--asp-diff` refused: a ruling) |
| `src/options.c`, `.h` | 422 + 87 | tree's command line, usage text | `src/opts` | v1, ap01 (all of it; `--acl`/`--selinux` refused by name) |
| `src/traverse.c`, `.h` | 1,427 + 45 | the walk: read, filter, stat, descend; streaming and full-tree engines; `--prune`, `--du`, `--condense`, `--filelimit`, `--fromfile`, `-l`, `-x`, `-R` | `src/walk` | v1, ap01 |
| `src/sort.c`, `.h` | 288 + 32 | tree's comparators; MSD radix for names | `src/walk` (`order`, `cmp`) | v1, ap01 (byte order in every locale) |
| `src/verscmp.c`, `.h` | 68 + 22 | `-v` | `src/vers` | ap01 |
| `src/glob.c`, `.h` | 115 + 15 | tree's patmatch | `src/glob` | v1 |
| `src/charset.c`, `.h` | 157 + 35 | the line-drawing table, three widths, comment glyphs | `src/lines` (the names in `src/opts`) | v1, ap01 |
| `src/render/unix.c`, `.h` | 418 + 43 | the text renderer | `src/text` | v1, ap01 |
| `src/render/name.c`, `.h` | 129 + 21 | name escaping (printit), `-q -N -Q` | `src/name` | v1, ap01 |
| `src/render/fileinfo.c`, `.h` | 130 + 28 | `[inode dev perm user group size date]` | `src/info`, `src/clock`, `src/tfmt` | v1, ap01 |
| `src/render/json.c`, `.h` | 349 + 25 | `-J` | `src/json` | v1, ap01 |
| `src/render/xml.c`, `.h` | 325 + 24 | `-X` | `src/xml` | ap01 |
| `src/render/html.c`, `.h`, `src/render/escape.c`, `.h` | 354 + 29, 51 + 20 | `-H`, `-T`, `--nolinks`, URL and HTML encoding | `src/html`, `src/text` (`url_encode`) | ap01 |
| `src/render/outbuf.c`, `.h`, `src/dstr.c`, `.h` | 33 + 23, 58 + 27 | buffered output | `src/out` | v1 |
| `src/entry.c`, `.h` | 41 + 58 | one entry | `src/ent` | v1, ap01 (side tables) |
| `src/sys/dir.c`, `.h`, `src/sys/xstat.c`, `.h` | 227 + 45, 34 + 39 | getdents64 / fstatat | wolf-std's `fs_read_dir_entries`, `fs_lstat`, `fs_stat`, `fs_read_link` | v1 (path-based, not fd-relative) |
| `src/pool.c`, `.h` | 224 + 34 | the parallel stat pool | `src/walk` (`stat_batch`, `stat_chunk`: `scope`/`spawn`, same thresholds, the caller a lane) | v1, ap01 |
| `src/iouring.c`, `.h` | 134 + 34 | io_uring statx batches (`ASP_IO=uring`) | `src/walk` (`pool_plan`: C aspen's own notice that io_uring is unavailable) | no wolf surface |
| `src/color.c`, `.h` | 249 + 41 | `-C`, LS_COLORS/TREE_COLORS | `src/color` | ap01 |
| `src/filter.c`, `.h` | 185 + 48 | `--gitignore`, `--gitfile` | `src/gitignore` (and the walk-up tree does, `src/walk`) | ap01 |
| `src/info.c`, `.h` | 152 + 37 | `--info`, `--infofile` | `src/infofile` | ap01 |
| `src/fromfile.c`, `.h` | 299 + 41 | `--fromfile`, `--fromtabfile`, `--fflinks` | `src/fromfile` | ap01 |
| `src/idcache.c`, `.h` | 76 + 17 | `-u`/`-g` name caches | `src/info` (`Cols`), wolf-std `std.os.users`, `src/host` | ap01 |
| `src/hashtab.c`, `.h` | 82 + 24 | `-l` cycle set | `src/walk` (`seen`, a map) | ap01 |
| `src/diff.c`, `.h` | 384 + 31 | `--asp-diff` (aspen-only) | — | refused by name (a ruling) |
| `src/arena.c`, `.h`, `src/util.c`, `.h`, `src/version.h` | 124 + 41, 67 + 22, 7 | allocation, helpers, the version | wolf's regions; `opts.version()` | — |

`asp` is the same binary under a second name (`Makefile:81–83`;
`make install` symlinks it, `:121`): v1 needs no second binary.

## 3. The flag surface

tree 2.3.2's flags (its `--help`, C aspen's `src/options.c:33`), all
parsed. Two of tree's linux options and one of C aspen's own are refused
by name, exit 2 (`aspen: --acl: not implemented in aspen (…)`):

| implemented | refused by name |
|---|---|
| every short flag of `-acdfghilnpqrstuvxACDFJQNSUX`, `-L level`, `-R`, `-H [-]baseHREF`, `-T title`, `-o file`, `-P pattern`, `-I pattern`; every long one of the usage text but two, with `--opt-toggle`; C aspen's `--threads N` and test hook `--asp-debug-walk` | `--acl`, `--selinux` (tree's: extended attributes, no wolf call); `--asp-diff` (C aspen's own) |

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
| `run.sh` | 286 flag sets over 14 generated fixtures (`mk*.sh`), in C, en_US.UTF-8 and C.UTF-8 | every case counted; under en_US.UTF-8 a case that differs is not-yet (collation, `tools/collation`) |
| `walk.sh` | discovery against `tree -fiN` | clean |
| `outfile.sh`, `fpath.sh`, `patterns.sh` | `-o`, `-f` roots, `-P`/`-I` paths | clean |
| `usage.sh` | `--help`, bad command lines, missing arguments | clean |
| `deviations.sh` | the law where C aspen and tree disagree (D1–D8, A4, A7, SR-2.12) | clean |
| `structural.sh` | `-J`/`-X` well-formed | clean |
| `fdlimit.sh` | a 250-deep chain under a low fd limit | clean (wolf's walk is path-based: no fd per depth) |
| `color.sh`, `pty.sh` | colour, piped and on a PTY the script starts | clean (`tools/golden` makes their four fixtures with C aspen's generators first; C aspen's runner makes only the corpus) |
| `rerun.sh`, `cyclic.sh`, `threads.sh`, `adversarial.sh` | `-R`'s files, `-l` over 30 inode layouts, `--threads`, hostile inputs | clean |
| `fuzz.sh` | seeded random trees | its generator and normalisations, its whole pool: `tools/fuzz` |
| `flag_coverage.sh` | a lint over C aspen's own `options.c` | C aspen's |

The deviations carried (C aspen's law, `tests/golden/deviations.sh`, all
of them): D1, exit 2 on an open or filelimit error in every mode where
tree's full-tree modes exit 0; D2, no empty `"contents":[ ]` after an
error in `-J`; D3, `-H`'s percent-encoding of the real byte; D4, a link's
own `--inodes`/`--device` under `-J`/`-X`; D5, `-Pfoo` is `-P foo` and
long options match exactly; D6, `-R`'s nested `00Tree.html` indented
standalone; D7, `-l`'s visited check in sorted order in every mode; D8,
`-R` a no-op under `-J`/`-X`; A4-residual, under `--prune` a `-P` that
matches a directory's name gives it no special reveal unless
`--matchdirs`; A7, `-H`'s own VERSION footer; SR-2.12, a root over
`--filelimit` is one directory with the marker.

## 5. Where the port follows tree over C aspen

Places where C aspen at the pin differs from tree 2.3.2, no golden covers
it, and no deviation documents it (1–3 ap00's, 4–9 ap01's, each measured
against tree in the oracle's container). The port follows tree, the
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
4. `--gitignore`: tree "attempts to walk up the directory tree from the
   given path(s) searching for .gitignore files as it goes, stopping at /
   or a directory containing a .git directory" and then adds
   `.git/info/exclude` (its manual); C aspen does not walk up
   (`src/filter.h:11`, "NOT YET"). Measured: the root itself is asked for
   a `.git` first; an ancestor's absolute patterns match nothing.
5. `--gitfile` and `--infofile`: tree loads each as it parses the option;
   a file it cannot load is `tree: Could not load gitignore file` (or
   `infofile`), status 1, before any output and before a later bad flag;
   every one given is used. C aspen keeps the last, and silently skips one
   it cannot open (`src/options.c:309`, `src/traverse.c:1320`); an
   absolute pattern in a `--gitfile` is not relative to the working
   directory in tree (`/r/c.c` does not hide `./r/c.c`).
6. `-H`'s root: tree types it by its `lstat` (a symlink root's href has no
   trailing `/`) and, under `-C`, classes it so (a symlink root is `EXEC`
   by its link's mode bits); C aspen types it a directory unless a flag
   stat'ed it and classes a non-directory root through a NULL entry
   (`src/render/html.c:280`, `:144`).
7. `-H -C`'s class of an entry: tree's is `DIR`, then `EXEC` for any
   execute bit (a fifo's or a socket's too), then the type, a link classed
   by its target; C aspen's uses `ENT_EXEC`, set for regular files alone
   (`src/render/html.c:122`).
8. `--hyperlink`: tree links a root that exists but cannot be opened (a
   file root); C aspen only an opened one (`src/render/unix.c:238`).
9. `-X` on a symlink root: tree's element is `<link>`, as `-J`'s type is
   "link" (item 1); C aspen's is `<directory>` unless a flag stat'ed the
   root (`src/render/xml.c:262`).

## 6. Bench

C aspen's README (its measurements, warm cache, ~200k entries):
Linux x86-64 4.7× (flat), 5.2× (wide), 4.7× (mixed), 2.5× (deep) faster
than tree; macOS 2.8×, 3.4×, 2.7×, 1.6×; 1.3–1.5× when a flag stats every
entry. Its gate (`bench/gate.sh`): faster than tree.

The port's rows (`tools/perf`, the container, `taskset -c 0-3`, median of
three, interleaved): the listing gated at 2× C aspen on a 1,000-entry
directory and a 100,000-file tree (ap00), and since ap01 `-s` on both
gated at 2× too; the numbers are in the notes (`notes/ap00-…` §4,
`notes/ap01-…` §6).

## 7. Gaps, named

- **Collation.** aspen sorts by byte in every locale. tree and C aspen
  use `strcoll` (`src/sort.c:244`); C and C.UTF-8 collate by byte, so they
  agree; glibc's en_US.UTF-8 orders 29 of the golden matrix's 286 cases
  differently, every one by order alone (`tools/collation`; ap01's
  ruling). macOS's en_US.UTF-8 collates by byte.
- **Locale detection** reads `LC_ALL`/`LC_CTYPE`/`LANG` and the installed
  locale files, since wolf has no `setlocale` (`src/locale`).
- **iswprint** is approximated (C0/C1 controls, DEL, U+2028/2029 are not
  printable; everything else is), where glibc also excludes unassigned
  code points (`src/name`).
- **Non-UTF-8 names** cannot be stat'ed or descended: wolf paths are `str`
  (wolf-lang#687). No golden or fuzzer name is one.
- **Extended attributes.** `--acl` and `--selinux` need `getxattr`, which
  wolf has no call for: refused by name.
- **Memory.** wolf's arena frees nothing a function's caller can still
  see before the program ends, and a region per directory level (ap01
  tried it) is refused by the region checker the moment the level pushes
  into the writer that outlives it (E1010); the 100,000-file listing
  holds 64 MB (C aspen 3 MB; ap00 86 MB), the measurement and the probes
  in `notes/ap01-the-second-light.md` §6.
