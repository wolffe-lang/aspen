# Changelog

## 0.1.0 (unreleased) — ap01, the second light

The rest of C aspen's surface at `aspen.pin` (`944a398`), ported from its
`src/` (`docs/MAP.md`), on wolf 0.2.34.

- The formats: `-X` (XML), `-H baseHREF` with `-T`, `--nolinks`,
  `--hintro`, `--houtro` (HTML; DEVIATION D3's real percent-encoded byte,
  A7's own VERSION footer), `-i` and `--compress N` in every format,
  `--charset X` and `-S` with tree's whole charset table.
- The filters and trees: `--fromfile`, `--fromtabfile`, `--fflinks`,
  `--condense`, `--gitignore` and `--gitfile`, `--info` and `--infofile`,
  `--filelimit` (D1, D2, SR-2.12), `-l` with the sorted cycle set (D7),
  `-x`, `-R`'s `00Tree.html` files (D6, D8).
- The columns and sorts: `-u`/`-g` (`/etc/passwd`, `/etc/group`, and
  macOS's `id` for an account its files do not hold), `--inodes` and
  `--device` (D4), `--si`, `--timefmt` (aspen's own strftime), `-c`, `-v`
  and `--sort`, `-U`, `--filesfirst`, `-q`, `-N`, `-Q`, `--metafirst`,
  `--opt-toggle`.
- Colour: `-C`, `LS_COLORS`/`TREE_COLORS`/`CLICOLOR`/`CLICOLOR_FORCE`/
  `NO_COLOR`, the terminal check, `--hyperlink`, `--scheme`,
  `--authority`.
- C aspen's `--threads N`, `ASP_IO` and `ASP_TRACE_POOL` (its own
  golden scripts read them).
- Where C aspen differs from tree with no golden, the port follows tree
  (`docs/MAP.md` §5): `--gitignore` walks up to `/` or a `.git` directory;
  `--gitfile`/`--infofile` are loaded as parsed, every one kept, a missing
  one an error; an HTML root is typed and classed by its `lstat`, an
  entry's class by its target; `--hyperlink` links a root that exists but
  cannot be opened; a `-X` symlink root is `<link>`.
- The oracles: C aspen's color, pty, rerun, cyclic, threads and
  adversarial scripts join `tools/golden`; the fixture oracle's sets and
  fixtures cover every option; the fuzzer's pool is C aspen's whole one;
  `tools/collation` measures en_US.UTF-8's order.
- Speed: `-s` gated at 2x of C aspen beside the listing; the stat tasks
  build their own paths and format the bracket column, and the main
  thread stats a chunk itself; the entry is back to ap00's size.

## 0.1.0 (unreleased) — ap00, the first light

A port of tenseleyFlow/aspen (MIT, the maintainer's), itself written with
tree 2.3.2 (GPL-2.0-or-later) as reference; this repository
GPL-3.0-or-later (ruling #103).

- The repository: the toolchain pinned by digest (wolf 0.2.33, lupin
  0.1.55, wolf-std `e036bec`), C aspen pinned by commit (`aspen.pin`,
  `944a398`), tiered CI from the first commit (`ci/tiers.py`), a red
  nightly opens an issue.
- v1, ported from C aspen's `src/` (`docs/MAP.md` maps it file by file):
  the default listing, `-a -d -f -F -s -h -p -D -r -t -A -n -J`, `-L`,
  `-P`/`-I` with tree's wild cards, `--ignore-case`, `--matchdirs`,
  `--prune`, `--du`, `--dirsfirst`, `--noreport`, `-o FILE`; the ASCII,
  UTF-8 and ANSI line sets; tree's name escaping in the C and UTF-8
  locales; `--help` and tree's usage errors; C aspen's deviations D1, D2,
  D5 and A4-residual. Every other tree option is refused by name, exit 2.
- Three places where C aspen differs from tree and no golden covers it
  follow tree: a `-J` symlink root's type, a file root's size under
  `--du`, several roots' `--du` total (`docs/MAP.md` §5).
- The oracles, in a container of their own: C aspen's golden suite run as
  it is (`tools/golden`); tree against aspen on generated fixtures
  (`tools/oracle`, `tests/oracle/sets.tsv`); C aspen's fuzzer's trees over
  v1's flags (`tools/fuzz`); each harness seen red on a spoiled aspen
  (`tools/selftest`).
- Speed: the listing within 2x of C aspen on a 1,000-entry directory and
  a 100,000-file tree (`tools/perf`), with C aspen's stat-pool shape for
  big levels and a packed-key name sort.
- The static x86-64 build for PAX, built twice to one digest
  (`tools/mkaspen`).
