# lib-classify.sh — sourced by tools/golden and tools/fuzz; not executable.
#
# classify ARGS: "v1" when every option word in ARGS is one aspen v1
# implements, else "v2 FLAG" naming the first that is not. Words not
# starting with "-" are roots (or an option's argument); "--" ends the
# options. v1's short flags are a d f F s h p D r t A n J, and P I o L with
# their argument (glued or the next word); v1's long ones are --help
# --version --noreport --dirsfirst --du --prune --ignore-case --matchdirs.
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
        --help | --version | --noreport | --dirsfirst | --du | --prune | --ignore-case | --matchdirs) ;;
        --*) echo "v2 ${_w%%=*}"; return ;;
        -?*)
            _r=${_w#-}
            while [ -n "$_r" ]; do
                _c=${_r%"${_r#?}"}
                _r=${_r#?}
                case "$_c" in
                a | d | f | F | s | h | p | D | r | t | A | n | J) ;;
                P | I | o | L)
                    if [ -z "$_r" ] && [ $# -gt 0 ]; then shift; fi
                    _r=""
                    ;;
                *) echo "v2 -$_c"; return ;;
                esac
            done
            ;;
        esac
    done
    echo v1
}

# classify_report SCRIPT LINE: "ok" (a script's own pass line, a loud
# skip), "v1" (a failure on a v1 surface) or "v2" (a failure on a flag v1
# does not implement), for one line a C aspen golden script printed.
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
        *"[help]"* | *"[--help]"* | *"[bad-long]"* | *"[bad-short]"* | *"[bad-short-mid]"* | *"[missing-arg]"*) echo v1 ;;
        *"--version"*) echo v1 ;;
        *"["*) echo v2 ;;
        *) echo v1 ;;
        esac ;;
    deviations.sh)
        case "$_l" in
        *"all documented deviations hold"* | *"running as root"*) echo ok ;;
        "DEVIATIONS D1 ["*)
            _f=${_l#DEVIATIONS D1 \[}
            _f=${_f%%\]*}
            case "$_f" in
            *filelimit* | *root-overlimit* | *condense*) echo v2 ;;
            *) echo v1 ;;
            esac ;;
        "DEVIATIONS D5"* | "DEVIATIONS A4-residual"*) echo v1 ;;
        "DEVIATIONS D2"* | "DEVIATIONS D3"* | "DEVIATIONS D4"* | "DEVIATIONS D6"* | "DEVIATIONS D7"* | "DEVIATIONS D8"* | "DEVIATIONS A7"* | "DEVIATIONS SR-2.12"*) echo v2 ;;
        *) echo v1 ;;
        esac ;;
    structural.sh)
        case "$_l" in
        *"well-formed"*) echo ok ;;
        "STRUCT xml"*) echo v2 ;;
        *) echo v1 ;;
        esac ;;
    fdlimit.sh)
        case "$_l" in
        *"survives a low soft fd limit"* | *"skipping"*) echo ok ;;
        *) echo v1 ;;
        esac ;;
    *) echo v1 ;;
    esac
}
