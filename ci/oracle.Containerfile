# The oracle's container: tree 2.3.2 exactly, and the tools the harness and
# C aspen's golden suite need. Built by tools/oracle-image (podman on
# kasumi, docker in CI) and run as a NON-ROOT user, so a 0000 directory is
# really unreadable (RULES §5: FIFOs and denied directories only in here).
#
# The base is pinned by digest (Arch Linux `base-devel`: gcc, make, diff,
# python3, taskset, mkfifo, locale-gen, glibc 2.44). tree is the Arch
# package `tree 2.3.2-1` (GPL-2.0-or-later), fetched from the Arch Linux
# Archive by its exact file name and refused unless its sha256 is the pin;
# it is the same file kasumi installed (/var/cache/pacman/pkg). en_US.UTF-8
# is generated so the golden suite's dictionary-locale phase runs.
FROM docker.io/library/archlinux:base-devel@sha256:8185e444e45ba166146b244b41f1cba2d7d91f3eddce533a839cc9591e0fa785

ARG TREE_PKG=tree-2.3.2-1-x86_64.pkg.tar.zst
ARG TREE_SHA256=8a6230468cc31a2c984a41c092035dd16bf97e737ec3241490724a5419903739

RUN curl -sSfL --retry 5 --retry-delay 5 -o /tmp/$TREE_PKG \
        https://archive.archlinux.org/packages/t/tree/$TREE_PKG \
    && echo "$TREE_SHA256  /tmp/$TREE_PKG" | sha256sum -c - \
    && pacman -U --noconfirm --needed /tmp/$TREE_PKG \
    && rm -f /tmp/$TREE_PKG \
    && sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && tree --version
