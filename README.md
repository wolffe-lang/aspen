# aspen

`tree(1)` in [wolf](https://github.com/wolffe-lang/wolf-lang): a recursive
directory lister whose output is byte-identical to `tree` 2.3.2's.

The name is the maintainer's pick: in the Yellowstone trophic cascade the
wolves' return let the aspens recover. Track 14 of the wolffe-lang org
(ruling #102); lanes `apNN`. Public since 2026-10-21.

## What it is

A port of tenseleyFlow/aspen (MIT, the maintainer's), itself written with
tree 2.3.2 (GPL-2.0-or-later) as reference; this repository
GPL-3.0-or-later (ruling #103).

The C implementation ([tenseleyFlow/aspen](https://github.com/tenseleyFlow/aspen),
pinned in `aspen.pin`) is read and cited by `file:line`; the port has no
dependency but wolf-std and is built static for
[PAX](https://github.com/wolffe-lang/pax), where it is the system's
`tree`.

## The oracles

- **C aspen at `aspen.pin`**: its golden suite, byte for byte against a
  tree 2.3.2 on stdout, stderr and exit status, is the oracle of record;
  where C aspen records a deviation from tree (`tests/golden/deviations.sh`
  there), the deviation is the law. The goldens are never edited.
- **`tree` 2.3.2**, the distribution's package, run as a black box, the
  backstop: the same version on kasumi (Arch Linux `tree 2.3.2-1`), in
  CI's container, and from Homebrew on macOS. tree's source is never read
  directly.

In a container of its own (`ci/oracle.Containerfile`, as a non-root
user): `tools/golden` runs C aspen's golden suite as it is against this
binary; `tools/oracle` runs tree and aspen over generated fixtures
(`tests/fixtures/mkfixtures`) for every invocation in
`tests/oracle/sets.tsv`; `tools/fuzz` runs C aspen's fuzzer's random trees
over its whole flag pool; each prints `N agree / M differ / K not-yet`.
`tools/collation` measures what the dictionary locale's order changes.

## Status

Nothing is released. aspen is byte-identical to tree 2.3.2 and to C
aspen, in the C and C.UTF-8 locales, across tree's whole option surface
but two (ap00's v1, then ap01): the listing and its filters (`-a -d -l -f
-x -L -R -P -I --gitignore --gitfile --ignore-case --matchdirs --prune
--info --infofile --filelimit --condense --fromfile --fromtabfile
--fflinks --noreport --charset -o`), the columns (`-q -N -Q -p -u -g -s
-h --si --du -D --timefmt -F --inodes --device --metafirst`), the sorts
(`-v -t -c -U -r --dirsfirst --filesfirst --sort`), the graphics (`-i -A
-S -n -C --compress`, `LS_COLORS`/`TREE_COLORS`/`CLICOLOR`/`NO_COLOR`), and
the formats (`-X -J -H -T --nolinks --hintro --houtro --hyperlink --scheme
--authority`), with `--opt-toggle`, `--help`, C aspen's deviations and
its own `--threads` and `--asp-diff` (two trees compared, tested against
C aspen itself: `tools/aspdiff`). What it does not do, named:

- `--acl` and `--selinux` (tree's, on linux) are refused by name, status
  2: they read a file's extended attributes, which wolf has no call for;
- names sort by byte in every locale: tree uses the locale's collation,
  so a dictionary locale such as glibc's en_US.UTF-8 orders some names
  differently (29 of C aspen's 286 golden cases, every one by order
  alone: `tools/collation`); macOS's en_US.UTF-8 collates by byte;
- a name that is not UTF-8 cannot be opened or stat'ed (wolf-lang#687).

## Build

The toolchain is fetched by digest (`wolf-toolchain.toml`): wolf 0.2.35,
lupin 0.1.56, wolf-std `2386522e`.

```sh
tools/fetch-toolchain
tools/build --release              # target/release/aspen
tools/mkaspen target/mkaspen       # static x86-64 Linux, for PAX
tools/check-test                   # the unit tests on three lanes
tools/fetch-c-aspen                # C aspen at aspen.pin, for the oracles
tools/in-container tools/golden    # and the other harnesses, in podman or docker
```

## License

GPL-3.0-or-later (`LICENSE`), with the org's training-data permission
(`LICENSE-TRAINING-DATA`), as lope has it. aspen is a port of
tenseleyFlow/aspen (MIT, the maintainer's), which was itself written with
tree 2.3.2 (Steve Baker et al., GPL-2.0-or-later) as reference; tree is
also run here as a black-box oracle.
