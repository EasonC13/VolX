import Foundation

struct HotKeyEventRecord: Identifiable {
    let id = UUID()
    let date: Date
    let action: VolumeKeyAction
    let source: VolumeKeySource
    let volume: Float
    let muted: Bool
    let result: String

    var displayText: String {
        let actionText: String
        switch action {
        case .mute:
            actionText = muted ? "F10 Muted" : "F10 Unmute"
        case .decrease:
            actionText = "F11 Down"
        case .increase:
            actionText = "F12 Up"
        }
        let percent = Int((volume * 100).rounded())
        return "\(timeText)  \(actionText)  \(percent)%  \(source.rawValue)  \(result)"
    }

    private var timeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
