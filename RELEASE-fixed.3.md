# v0.3.6-fixed.3 — external volume consumer-control modifier repair

The user confirms built-in MacBook Command + volume works in fixed.2; the failing control is a Cooler Master wireless keyboard rotary volume knob. Music backend, AppleScript, permissions and entitlements are unchanged.

Confirmed code defect: an NX volume event with empty flags and Command held in the global session/HID state fails exact-Command routing. Red macOS regression: https://github.com/EasonC13/VolX/actions/runs/39133845072 (three expected nil-versus-increase failures).

For recognized native volume events only, combine event flags with CGEventSource.flagsState(.combinedSessionState) and .hidSystemState. Union preserves other held modifiers so Command+Option/Control/Shift/Fn cannot become exact Command. No ordinary keyboard subscription or flagsChanged history is needed; cross-device global state avoids stale locally tracked modifier state. Event-only Command retains the working built-in path.

Copy Volume Key Diagnostics in the right-click menu copies only the last recognized volume event modifier masks, source category, toggle state, Accessibility/tap state and version. No ordinary keys, device names, track names or content are collected. If the knob emits no NX volume event, this repair cannot convert that different HID protocol; the diagnostic will say no native volume event received.

Tests cover empty-event flags plus session-only/HID-only Command, competing modifiers, built-in event-only Command, native NSEvent -> monitor -> Music action, and disabled opt-in passthrough. Physical Cooler Master knob and HomePod acceptance remain unverified remotely. No claim of hardware success.

The initial actual-backend CI probe (39133700069) failed with generic automation error on the hosted runner. It does not establish a user backend defect and was removed after the user's built-in-key success report. No speculative backend or TCC changes were made.

References: Apple CGEventFlags documentation and CGEventSource state semantics (global combined session versus HID hardware state); no third-party implementation was copied.

Signing: ad-hoc, not Developer ID signed or notarized. Requires macOS 14+; DMG is arm64.
