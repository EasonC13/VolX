@preconcurrency import AppKit
import Foundation

final class AppleMusicBackend: MusicVolumeBackend {
    func isRunning() -> Bool {
        !NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Music").isEmpty
    }
    // Fixed script; only a validated integer is supplied as an argv value. No shell.
    private static let script = """
    on run argv
        if application "Music" is not running then error "Music unavailable" number -600
        with timeout of 3 seconds
            tell application "Music"
                if (count of argv) is 1 then set sound volume to (item 1 of argv as integer)
                return sound volume
            end tell
        end timeout
    end run
    """
    private func execute(_ arguments: [String]) throws -> Int {
        guard isRunning() else { throw MusicVolumeError.unavailable }
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        process.arguments = ["-e", Self.script] + arguments
        let output = Pipe()
        process.standardOutput = output
        process.standardError = FileHandle.nullDevice
        try process.run()
        let deadline = Date().addingTimeInterval(5)
        while process.isRunning && Date() < deadline { Thread.sleep(forTimeInterval: 0.02) }
        if process.isRunning {
            process.terminate()
            throw MusicVolumeError.timeout
        }
        guard process.terminationStatus == 0,
              let text = String(data: output.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8),
              let volume = Int(text.trimmingCharacters(in: .whitespacesAndNewlines)),
              (0...100).contains(volume) else { throw MusicVolumeError.automation }
        return volume
    }
    func read() throws -> Int { try execute([]) }
    func write(_ volume: Int) throws {
        guard (0...100).contains(volume) else { throw MusicVolumeError.unconfirmed }
        _ = try execute([String(volume)])
    }
}
