#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
python3 "$ROOT/scripts/test-english-ui.py"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
"${SWIFTC:-swiftc}" "$ROOT/Sources/MultiOutputVolume/SafeVolumeCore.swift" "$ROOT/Sources/MultiOutputVolume/AudioDevice.swift" "$ROOT/Sources/MultiOutputVolume/MusicVolumeCore.swift" "$ROOT/Tests/Portable/main.swift" -o "$TMP/volx-tests"
"$TMP/volx-tests"
