# Changelog

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
