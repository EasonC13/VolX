# VolX 0.3.6-fixed.2 — Music shortcuts and English UI

- Full English application UI: menus, settings, panel, HUD, accessibility labels, statuses, errors, and privacy usage descriptions. Device and user-provided names remain unchanged.
- Right-click the VolX menu bar icon and enable **Use ⌘ + Volume Keys for Music**. Off by default; persisted across launches.
- Exact Command + native volume media keys adjust Apple Music's app `sound volume`, including Music's existing AirPlay/HomePod playback. Normal native keys keep the existing system/multi-output behavior. Control, mixed modifiers and ordinary F keys are not captured for Music.
- Music is never intentionally launched, played, or rerouted. Open Music yourself and select its AirPlay destination there. Grant Automation permission when prompted.
- Serial background automation uses a fixed AppleScript and validated integer arguments, bounded execution, 0–100 clamping, readback confirmation, and mute restore. Repeating mute events do not repeatedly toggle. Errors/unavailable state do not display a fabricated level.

## Trust and validation

Apple Silicon (arm64), macOS 14+. Built on a GitHub macOS runner with Xcode 26.3. Ad-hoc signed; **not Developer ID signed or notarized**. Gatekeeper may require explicit approval in Privacy & Security. No GPL implementation was copied.

CI verifies portable production-core checks, macOS XCTest, compilation, code signature, DMG integrity and mounted app contents. Physical keyboard, Automation consent dialogs, Music/AirPlay/HomePod audio and actual system-volume independence require local hardware acceptance and could not be exercised here. This controls Music's app volume, not an independently selected HomePod device or its direct hardware volume. DDC remains disabled.
