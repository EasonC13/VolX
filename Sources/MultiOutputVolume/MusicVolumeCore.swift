import Foundation

struct MusicVolumeKey {
    static func decode(type: UInt32, subtype: Int, data: Int, modifiers: UInt64, enabled: Bool) -> NativeVolumeKey? {
        // Device-independent modifiers, including Caps Lock/Fn/numeric-pad, must be exact Command.
        guard enabled, modifiers & 0xffff0000 == 1 << 20 else { return nil }
        return NativeVolumeKey.decode(type: type, subtype: subtype, data: data, modifiers: 0)
    }
}
protocol MusicVolumeBackend {
    func isRunning() -> Bool
    func read() throws -> Int
    func write(_ volume: Int) throws
}
enum MusicVolumeError: Error, LocalizedError {
    case unavailable, unconfirmed, automation, timeout
    var errorDescription: String? {
        switch self {
        case .unavailable: return "Music is not running (will not launch it)"
        case .unconfirmed: return "Music volume not confirmed"
        case .automation: return "Music automation failed: check System Settings > Privacy & Security > Automation"
        case .timeout: return "Music automation timed out"
        }
    }
}
// Confined to one serial worker; never changes system routing or playback.
final class MusicVolumeController: @unchecked Sendable {
    private let backend: MusicVolumeBackend
    private var restore = 0
    init(backend: MusicVolumeBackend) { self.backend = backend }
    func apply(_ action: VolumeKeyAction) throws -> Int {
        guard backend.isRunning() else { throw MusicVolumeError.unavailable }
        let current = try backend.read()
        guard (0...100).contains(current) else { throw MusicVolumeError.unconfirmed }
        let target: Int
        switch action {
        case .increase: target = min(100, current + 6)
        case .decrease: target = max(0, current - 6)
        case .mute:
            if current > 0 { restore = current; target = 0 }
            else { target = restore }
        }
        try backend.write(target)
        let actual = try backend.read()
        guard actual == target else { throw MusicVolumeError.unconfirmed }
        return actual
    }
}
