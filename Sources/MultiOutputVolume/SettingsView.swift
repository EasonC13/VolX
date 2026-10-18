import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: VolumeModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("VolX")
                .font(.title2.weight(.semibold))
            Text("菜单栏统一音量工具。F10 静音，F11 减小，F12 增大。")
                .foregroundStyle(.secondary)
            Divider()
            Toggle("Command＋音量鍵控制 Music", isOn: $model.commandMusicEnabled)
            Text("仅控制 Music 应用音量（含其 AirPlay 输出），不会更改系统音量或启动 Music。")
                .font(.caption).foregroundStyle(.secondary)
            Toggle(
                "登录时启动",
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
