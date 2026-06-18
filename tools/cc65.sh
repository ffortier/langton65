#!/usr/bin/env bash
# If you read this, it is not great. I have a custom, fully hermetic cc toolchain for cc65
# in another repo, I'm just being lazy now

die() {
    echo "$*" >&2
    exit 1
}

for file in "$@"
do
    out_file="${OUT?"missing out"}/${file##*/}"
    case "$file" in
        *.s) ca65 $SFLAGS -o "${out_file%.s}.o" "$file" || die "Failed to compile $file" ;;
        *.c) cl65 $CFLAGS -c -o "${out_file%.c}.o" "$file" || die "Failed to compile $file" ;;
        *) ;; # Ignore headers and shit
    esac
done
