import AppKit
import XCTest
@testable import MultiOutputVolume

final class MusicTests: XCTestCase {
    func testExactCommandRouting() {
        XCTAssertNil(MusicVolumeKey.decode(type: 14, subtype: 8, data: 0x0a00, modifiers: 1 << 20, enabled: false))
        XCTAssertEqual(MusicVolumeKey.decode(type: 14, subtype: 8, data: 0x0a00, modifiers: 1 << 20, enabled: true)?.action, .increase)
        for flags: UInt64 in [0, 1 << 18, (1 << 20) | (1 << 17), (1 << 20) | (1 << 19)] {
            XCTAssertNil(MusicVolumeKey.decode(type: 14, subtype: 8, data: 0x0a00, modifiers: flags, enabled: true))
        }
        XCTAssertNil(MusicVolumeKey.decode(type: 10, subtype: 8, data: 0x0a00, modifiers: 1 << 20, enabled: true))
        XCTAssertNil(MusicVolumeKey.decode(type: 14, subtype: 8, data: 0x70a01, modifiers: 1 << 20, enabled: true)?.action)
    }
    func testReadbackClampMuteRestoreAndFailure() throws {
        let backend = FakeMusic()
        let controller = MusicVolumeController(backend: backend)
        XCTAssertEqual(try controller.apply(.increase), 100)
        XCTAssertEqual(try controller.apply(.mute), 0)
        XCTAssertEqual(try controller.apply(.mute), 100)
        backend.reject = true
        XCTAssertThrowsError(try controller.apply(.decrease))
        backend.running = false
        let before = backend.reads
        XCTAssertThrowsError(try controller.apply(.increase))
        XCTAssertEqual(backend.reads, before)
    }
    @MainActor func testNativeToggleAndPersistence() async throws {
        let monitor = MediaKeyMonitor()
        let event = try XCTUnwrap(NSEvent.otherEvent(with: .systemDefined, location: .zero,
            modifierFlags: [.command], timestamp: 0, windowNumber: 0, context: nil,
            subtype: 8, data1: 0x0a00, data2: -1)?.cgEvent)
        XCTAssertNotNil(monitor.handle(event: event, type: CGEventType(rawValue: 14)!))
        monitor.musicEnabled = true
        let done = expectation(description: "Music action")
        monitor.onMusicAction = { action in XCTAssertEqual(action, .increase); done.fulfill() }
        XCTAssertNil(monitor.handle(event: event, type: CGEventType(rawValue: 14)!))
        await fulfillment(of: [done], timeout: 1)
        let defaults = try XCTUnwrap(UserDefaults(suiteName: UUID().uuidString))
        let model = VolumeModel(defaults: defaults)
        XCTAssertFalse(model.commandMusicEnabled)
        model.commandMusicEnabled = true
        XCTAssertTrue(VolumeModel(defaults: defaults).commandMusicEnabled)
    }
}
private final class FakeMusic: MusicVolumeBackend {
    var running = true
    var value = 98
    var reject = false
    var reads = 0
    func isRunning() -> Bool { running }
    func read() throws -> Int { reads += 1; return value }
    func write(_ volume: Int) throws { if !reject { value = volume } }
}
