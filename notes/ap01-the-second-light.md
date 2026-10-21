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
filed or closed (listed in the report); the repository stays private. No
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
