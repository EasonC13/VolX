# Verification — 0.3.6-fixed.1

Environment: Linux; Swift 6.1.3 official Ubuntu 24.04 toolchain.

Executed successfully:

- `SWIFTC=/home/clawd/workspaces/volx-audit/toolchain/swift-6.1.3-RELEASE-ubuntu24.04/usr/bin/swiftc bash scripts/test-portable.sh` — all 35 checks passed against the application's actual `SafeVolumeCore.swift`.
- `swiftc -frontend -parse -swift-version 6 Sources/MultiOutputVolume/*.swift Tests/Mac/*.swift` — exit 0. Syntax parsing only, NOT SDK typechecking.
- `bash -n scripts/*.sh` — exit 0.
- `git diff --check` — exit 0.
- `swift package dump-package` — manifest accepted.
- Python plist parser — version is `0.3.6-fixed.1`.

The resumed baseline initially failed the saved per-device restore-level test because the controller initializer was empty. Implemented validated restoration and explicit positive hardware-level precedence, then reran successfully.

Mac-only XCTest coverage was added for read-only startup/switching, partial mute, independent restore, pair balance, persistence, DDC disablement, and real NSEvent/CGEvent dispatch. These tests have NOT run here. Some platform integration changes therefore have test coverage authored but no observed platform red/green cycle.

No macOS SDK typecheck, app build, signature validation, installer execution, physical media-key, CoreAudio device, sleep/wake, headphone hot-plug, or sound-output verification was possible. The source ZIP is not a verified Mac binary or installer. The README contains the Mac acceptance checklist and the one-command local build/install workflow. Installer requires macOS 26 SDK due to inherited NSGlassEffectView references, while deployment target remains macOS 14.
