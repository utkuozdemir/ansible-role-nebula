#!/usr/bin/env bash
set -euo pipefail

if [ ! -f "$1" ]; then
    echo "File not found!"
    exit 1
fi

grep -w "changed=[1-9]" "$1" && echo "Idempotency check failed!" && exit 1

echo "Idempotency check passed..."
