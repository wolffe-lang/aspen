# aspen

`tree(1)` in [wolf](https://github.com/wolffe-lang/wolf-lang): a recursive
directory lister whose output is byte-identical to `tree` 2.3.2's.

The name is the maintainer's pick: in the Yellowstone trophic cascade the
wolves' return let the aspens recover. Track 14 of the wolffe-lang org
(ruling #102); lanes `apNN`.

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
over v1's flags; each prints `N agree / M differ / K not-yet`.

## Status

Nothing is released. v1 (ap00) is byte-identical to tree 2.3.2 and to C
aspen, in the C and C.UTF-8 locales, for: the default listing, `-a`, `-d`,
`-L N`, `-f`, `-F`, `-p`, `-s`, `-h`, `-D`, `--dirsfirst`, `-r`, `-t`,
`-I`/`-P` (tree's wild cards, `--ignore-case`, `--matchdirs`),
`--noreport`, `-A` (ANSI lines), the ASCII and UTF-8 line sets, `-o FILE`,
`-J`, `--prune`, `--du`, the report line, `[error opening dir]`, missing
and several roots. Every other tree option is refused by name with status
2 (`docs/MAP.md` §3); they are ap01's. What v1 does not do yet, named:

- names sort by byte in every locale (tree uses the locale's collation, so
  a dictionary locale such as en_US.UTF-8 can order dot names differently);
- no colour, ever (tree colours a terminal when `LS_COLORS` is set);
- a name that is not UTF-8 cannot be opened or stat'ed (wolf-lang#687).

## Build

The toolchain is fetched by digest (`wolf-toolchain.toml`): wolf 0.2.33,
lupin 0.1.55, wolf-std `e036bec`.

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
