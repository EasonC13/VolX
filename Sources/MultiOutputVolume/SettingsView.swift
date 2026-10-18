import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: VolumeModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("VolX")
                .font(.title2.weight(.semibold))
            Text("Menu bar volume control. Use the native mute, volume down, and volume up keys.")
                .foregroundStyle(.secondary)
            Divider()
            Toggle("Use ⌘ + Volume Keys for Music", isOn: $model.commandMusicEnabled)
            Text("Controls Music app volume, including its AirPlay output. Does not change system volume or launch Music.")
                .font(.caption).foregroundStyle(.secondary)
            Toggle(
                "Launch at Login",
                isOn: Binding(
                    get: { model.launchAtLoginEnabled },
                    set: { model.setLaunchAtLogin($0) }
                )
            )
            Text(model.lastStatus)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(width: 420)
    }
}
