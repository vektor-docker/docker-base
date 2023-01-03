#!/bin/bash -e

function build() {
    local release="verify"
    local downstream="no"

    while getopts ":rh" opt; do
        case $opt in
            r)
                release="deploy"
                ;;
            h)
                cat <<EOF
usage: build [OPTION]... [-- [docker build opts]]
  -h        show this help.
  -r        push resulting image.
EOF
                return 0;
                ;;
            :)
                echo "$0: option requires an argument -- '$OPTARG'" 1>&2
                return 1
                ;;
            *)
                echo "$0: invalid option -- '$OPTARG'" 1>&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND-1))

    mvn -B ${release}
}

CURRENT_DIR=$(pwd)

if [ -d ${CURRENT_DIR}/tmp ]; then
    rm -rf ${CURRENT_DIR}/tmp
fi

trap "exit 1" INT TERM QUIT

build "$@"
