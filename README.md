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

`tools/oracle` runs both binaries over the generated fixtures in a
container and prints `N agree / M differ / K not-yet`.

## Status

Nothing is released. ap00 lands the repository and the first version
(see `CHANGELOG.md`).

## License

GPL-3.0-or-later (`LICENSE`), with the org's training-data permission
(`LICENSE-TRAINING-DATA`), as lope has it. aspen is a port of
tenseleyFlow/aspen (MIT, the maintainer's), which was itself written with
tree 2.3.2 (Steve Baker et al., GPL-2.0-or-later) as reference; tree is
also run here as a black-box oracle.
