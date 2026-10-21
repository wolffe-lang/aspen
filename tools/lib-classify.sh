# lib-classify.sh — sourced by tools/golden and tools/fuzz; not executable.
#
# classify ARGS: "v1" when every option word in ARGS is one aspen
# implements, else "v2 FLAG" naming the first that is not. Since ap01 that
# is every option of tree 2.3.2 and C aspen but three, which aspen refuses
# by name with status 2: tree's --acl and --selinux (they read extended
# attributes, which wolf has no call for) and C aspen's own --asp-diff
# (notes/ap01-the-second-light.md, the rulings asked). Words not starting
# with "-" are roots (or an option's argument); "--" ends the options.
# The short flags that take an argument (glued or the next word) are P I
# o L H T; the long ones that take one take it as --opt=V or the next word.
classify() {
    set -f
    # shellcheck disable=SC2086
    set -- $1
    set +f
    while [ $# -gt 0 ]; do
        _w=$1
        shift
        case "$_w" in
        --) echo v1; return ;;
        --acl | --selinux | --asp-diff) echo "v2 $_w"; return ;;
        --compress | --charset | --filelimit | --threads | --timefmt | --sort | --gitfile | --infofile | --hintro | --houtro | --scheme | --authority)
            [ $# -gt 0 ] && shift ;;
        --*) ;;
        -?*)
            _r=${_w#-}
            while [ -n "$_r" ]; do
                _c=${_r%"${_r#?}"}
                _r=${_r#?}
                case "$_c" in
                P | I | o | L | H | T)
                    if [ -z "$_r" ] && [ $# -gt 0 ]; then shift; fi
                    _r=""
                    ;;
                *) ;;
                esac
            done
            ;;
        esac
    done
    echo v1
}

# classify_report SCRIPT LINE: "ok" (a script's own pass line), "skip"
# (its loud skip, counted), "v1" (a failure on an implemented surface) or
# "v2" (a failure on a flag aspen refuses), for one line a C aspen golden
# script printed.
classify_report() {
    _s=$1
    _l=$2
    case "$_s" in
    walk.sh)
        case "$_l" in *"discovery matches"*) echo ok ;; *) echo v1 ;; esac ;;
    outfile.sh)
        case "$_l" in
        *"writes the file byte-identically"*) echo ok ;;
        *"for [default]"*) echo v1 ;;
        *"for ["*)
            _f=${_l#*for \[}
            _f=${_f%%\]*}
            classify "$_f" | sed 's/^\(v[12]\).*/\1/' ;;
        *) echo v1 ;;
        esac ;;
    fpath.sh)
        case "$_l" in
        "FPATH DIFF: "*) classify "${_l#FPATH DIFF: }" | sed 's/^\(v[12]\).*/\1/' ;;
        *"canonical == tree"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    patterns.sh)
        case "$_l" in
        "PATTERNS["*)
            _f=${_l#PATTERNS\[}
            _f=${_f%%\]*}
            classify "$_f" | sed 's/^\(v[12]\).*/\1/' ;;
        *"== tree 2.3.2"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    usage.sh)
        case "$_l" in
        *"byte-identical to tree"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    deviations.sh)
        case "$_l" in
        *"all documented deviations hold"* | *"running as root"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    structural.sh)
        case "$_l" in
        *"well-formed"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    fdlimit.sh)
        case "$_l" in
        *"survives a low soft fd limit"*) echo ok ;;
        *"skipping"*) echo skip ;;
        *) echo v1 ;;
        esac ;;
    color.sh)
        case "$_l" in
        "COLOR: matches tree"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    pty.sh)
        case "$_l" in
        "PTY: matches tree"*) echo ok ;;
        *"skipping"*) echo skip ;;
        *) echo v1 ;;
        esac ;;
    rerun.sh)
        case "$_l" in
        "RERUN: ok"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    cyclic.sh)
        case "$_l" in
        "CYCLIC: ok"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    threads.sh)
        case "$_l" in
        "THREADS: parallel stat deterministic"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    adversarial.sh)
        case "$_l" in
        "ADVERSARIAL: hostile inputs survive"* | *"robustness win, parity skipped"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    *) echo v1 ;;
    esac
}
