# ap02a's build image on hasu: what CI's ubuntu-latest runner gives wolf's
# release tier (clang 18, a cc, python3 for tools/check-test), so a binary
# links against a baseline glibc and runs in the Arch oracle container.
FROM docker.io/library/ubuntu:24.04
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
        clang lld gcc libc6-dev make python3 ca-certificates git >/dev/null \
    && rm -rf /var/lib/apt/lists/* && clang --version | head -1 && python3 --version
