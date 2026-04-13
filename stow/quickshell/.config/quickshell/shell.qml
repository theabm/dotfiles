import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

ShellRoot {
    id: root

    readonly property color base: "#161210"
    readonly property color panel: "#1f1917"
    readonly property color panelSoft: "#28211e"
    readonly property color border: "#43352f"
    readonly property color text: "#f3e7dc"
    readonly property color textMuted: "#c5b1a2"
    readonly property color textDim: "#8b776d"
    readonly property color accent: "#e7a45c"
    readonly property color accentText: "#20140d"
    readonly property color active: "#354955"
    readonly property color activeBorder: "#84aabc"
    readonly property color occupied: "#342b27"
    readonly property color urgent: "#d96b6b"

    property string audioLabel: "0%"
    property string micLabel: ""
    property string micTitle: "live"
    property string networkLabel: ""
    property string batteryLabel: " AC"
    property string batteryVisualState: "ac"
    property bool specialWorkspaceOpen: false

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    StdioCollector {
        id: volumeCollector
        waitForEnd: true
    }

    StdioCollector {
        id: micCollector
        waitForEnd: true
    }

    StdioCollector {
        id: batteryCollector
        waitForEnd: true
    }

    StdioCollector {
        id: networkCollector
        waitForEnd: true
    }

    StdioCollector {
        id: specialWorkspaceCollector
        waitForEnd: true
    }

    Process {
        id: volumeProcess
        command: [
            "bash",
            "-lc",
            "if wpctl inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -qiE '(^|[[:space:]])mute:[[:space:]]*true'; then echo MUTED; else wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $2}'; fi"
        ]
        stdout: volumeCollector

        onExited: {
            const output = volumeCollector.text.trim()

            if (output === "MUTED") {
                root.audioLabel = "🔇"
                return
            }

            const match = output.match(/([0-9]*\.?[0-9]+)/)
            if (!match) {
                root.audioLabel = "0%"
                return
            }

            const percent = Math.round(Number(match[1]) * 100)
            root.audioLabel = isFinite(percent) ? percent + "%" : "0%"
        }
    }

    Process {
        id: micProcess
        command: [
            "bash",
            "-lc",
            "if wpctl status 2>/dev/null | grep -q MUTED; then echo MUTED; else echo LIVE; fi"
        ]
        stdout: micCollector

        onExited: {
            const output = micCollector.text.trim()
            const muted = output === "MUTED"
            root.micLabel = muted ? "" : ""
            root.micTitle = muted ? "muted" : "mic"
        }
    }

    Process {
        id: batteryProcess
        command: [
            "bash",
            "-lc",
            "battery_dir=$(find /sys/class/power_supply -maxdepth 1 -name 'BAT*' | head -n1); if [ -z \"$battery_dir\" ]; then echo 'ac|  AC'; exit 0; fi; capacity=$(cat \"$battery_dir/capacity\" 2>/dev/null || echo 0); status=$(cat \"$battery_dir/status\" 2>/dev/null || echo Unknown); if [ \"$capacity\" -lt 20 ]; then icon=''; elif [ \"$capacity\" -lt 40 ]; then icon=''; elif [ \"$capacity\" -lt 60 ]; then icon=''; elif [ \"$capacity\" -lt 80 ]; then icon=''; else icon=''; fi; if [ \"$status\" = 'Charging' ]; then echo \"charging|  ${capacity}%\"; elif [ \"$status\" = 'Full' ]; then echo \"normal|  ${capacity}%\"; elif [ \"$capacity\" -le 20 ]; then echo \"critical|${icon}  ${capacity}%\"; elif [ \"$capacity\" -le 30 ]; then echo \"warning|${icon}  ${capacity}%\"; else echo \"normal|${icon}  ${capacity}%\"; fi"
        ]
        stdout: batteryCollector

        onExited: {
            const output = batteryCollector.text.trim()
            const parts = output.split("|")
            if (parts.length >= 2) {
                root.batteryVisualState = parts[0]
                root.batteryLabel = parts.slice(1).join("|")
            } else {
                root.batteryVisualState = "ac"
                root.batteryLabel = " AC"
            }
        }
    }

    Process {
        id: networkProcess
        command: [
            "bash",
            "-c",
            "if ! command -v nmcli >/dev/null 2>&1; then echo ''; exit 0; fi; wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:' | head -n1); if [ -n \"$wifi\" ]; then echo ''; exit 0; fi; wired=$(nmcli -t -f TYPE,STATE,CONNECTION dev status 2>/dev/null | awk -F: '$1==\"ethernet\" && $2==\"connected\" {print $3; exit}'); if [ -n \"$wired\" ]; then echo ''; else echo ''; fi"
        ]
        stdout: networkCollector

        onExited: {
            const output = networkCollector.text.trim()
            root.networkLabel = output.length > 0 ? output : ""
        }
    }

    Process {
        id: specialWorkspaceProcess
        command: [
            "bash",
            "-lc",
            "if hyprctl monitors -j 2>/dev/null | tr -d '\\n' | grep -q 'special:magic'; then echo OPEN; else echo CLOSED; fi"
        ]
        stdout: specialWorkspaceCollector

        onExited: {
            root.specialWorkspaceOpen = specialWorkspaceCollector.text.trim() === "OPEN"
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (!volumeProcess.running) {
                volumeProcess.running = true
            }
            if (!micProcess.running) {
                micProcess.running = true
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (!batteryProcess.running) {
                batteryProcess.running = true
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (!networkProcess.running) {
                networkProcess.running = true
            }
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (!specialWorkspaceProcess.running) {
                specialWorkspaceProcess.running = true
            }
        }
    }

    function workspaceById(id) {
        const workspaces = Hyprland.workspaces.values
        for (let i = 0; i < workspaces.length; i++) {
            if (workspaces[i].id === id) {
                return workspaces[i]
            }
        }
        return null
    }

    function specialWorkspaceVisible() {
        return specialWorkspaceOpen
    }

    function workspaceState(id) {
        const workspace = workspaceById(id)
        if (!workspace) {
            return "inactive"
        }
        if (workspace.urgent) {
            return "urgent"
        }
        if (workspace.focused) {
            return "focused"
        }
        if (workspace.active) {
            return "active"
        }
        if (workspace.toplevels && workspace.toplevels.values.length > 0) {
            return "occupied"
        }
        return "inactive"
    }

    function workspaceLabel(id) {
        return id < 10 ? "0" + id : String(id)
    }

    function switchToWorkspace(id) {
        Quickshell.execDetached(["hyprctl", "dispatch", "workspace", String(id)])
    }

    function toggleSpecialWorkspace() {
        Quickshell.execDetached(["hyprctl", "dispatch", "togglespecialworkspace", "magic"])
    }

    function volumeText() {
        return audioLabel
    }

    function micMuted() {
        return micTitle === "muted"
    }

    function micFillColor() {
        return micMuted() ? "#341d1d" : root.panelSoft
    }

    function micStrokeColor() {
        return micMuted() ? root.urgent : root.border
    }

    function micTextColor() {
        return micMuted() ? root.urgent : root.text
    }

    function batteryText() {
        return batteryLabel
    }

    function batteryState() {
        return batteryVisualState
    }

    function batteryTextColor() {
        switch (batteryState()) {
        case "charging":
            return root.accent
        case "warning":
            return "#f1b26f"
        case "critical":
            return root.urgent
        default:
            return root.text
        }
    }

    function batteryStrokeColor() {
        switch (batteryState()) {
        case "charging":
            return root.accent
        case "warning":
            return "#9a6a3a"
        case "critical":
            return root.urgent
        default:
            return root.border
        }
    }

    function batteryFillColor() {
        switch (batteryState()) {
        case "charging":
            return "#2c221a"
        case "warning":
            return "#33251c"
        case "critical":
            return "#341d1d"
        default:
            return root.panelSoft
        }
    }

    component Capsule: Rectangle {
        id: capsule

        required property string overline
        required property string label
        property bool clickable: false
        property var onActivate: null
        property color fill: root.panelSoft
        property color stroke: root.border
        property color textColor: root.text
        property color overlineColor: root.textDim
        property int labelSize: 13
        property int overlineSize: 9
        property int horizontalPadding: 14
        readonly property bool hasOverline: overline.length > 0

        height: 40
        radius: 12
        color: fill
        border.width: 1
        border.color: stroke
        implicitWidth: textBlock.implicitWidth + horizontalPadding * 2

        Behavior on color {
            ColorAnimation { duration: 160 }
        }

        Behavior on border.color {
            ColorAnimation { duration: 160 }
        }

        MouseArea {
            anchors.fill: parent
            enabled: capsule.clickable
            cursorShape: capsule.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: {
                if (capsule.onActivate) {
                    capsule.onActivate()
                }
            }
        }

        Column {
            id: textBlock
            anchors.centerIn: parent
            spacing: capsule.hasOverline ? -1 : 0

            Text {
                visible: capsule.hasOverline
                anchors.horizontalCenter: parent.horizontalCenter
                text: capsule.overline.toUpperCase()
                color: capsule.overlineColor
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: capsule.overlineSize
                font.letterSpacing: 1.8
                renderType: Text.NativeRendering
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: capsule.label
                color: capsule.textColor
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: capsule.labelSize
                renderType: Text.NativeRendering
            }
        }
    }

    component IconCapsule: Rectangle {
        id: iconCapsule

        required property string icon
        property bool clickable: false
        property var onActivate: null
        property color fill: root.panelSoft
        property color stroke: root.border
        property color iconColor: root.text
        property int iconSize: 15

        width: 40
        height: 40
        radius: 12
        color: fill
        border.width: 1
        border.color: stroke

        Behavior on color {
            ColorAnimation { duration: 160 }
        }

        Behavior on border.color {
            ColorAnimation { duration: 160 }
        }

        MouseArea {
            anchors.fill: parent
            enabled: iconCapsule.clickable
            cursorShape: iconCapsule.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: {
                if (iconCapsule.onActivate) {
                    iconCapsule.onActivate()
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: iconCapsule.icon
            color: iconCapsule.iconColor
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: iconCapsule.iconSize
            renderType: Text.NativeRendering
        }
    }

    component WorkspaceButton: Rectangle {
        id: workspaceButton

        required property int workspaceId
        readonly property string state: root.workspaceState(workspaceId)
        readonly property bool hovered: mouseArea.containsMouse

        width: 52
        height: 36
        radius: 10
        border.width: 1
        border.color: {
            switch (state) {
            case "urgent":
                return root.urgent
            case "active":
                return root.activeBorder
            case "occupied":
                return root.border
            default:
                return hovered ? root.textMuted : root.border
            }
        }
        color: {
            switch (state) {
            case "focused":
                return root.accent
            case "urgent":
                return Qt.rgba(0.85, 0.42, 0.42, 0.20)
            case "active":
                return root.active
            case "occupied":
                return root.occupied
            default:
                return hovered ? "#312825" : "transparent"
            }
        }

        Behavior on color {
            ColorAnimation { duration: 160 }
        }

        Behavior on border.color {
            ColorAnimation { duration: 160 }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.switchToWorkspace(workspaceButton.workspaceId)
        }

        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.workspaceLabel(workspaceButton.workspaceId)
                color: workspaceButton.state === "focused" ? root.accentText : root.text
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                font.bold: workspaceButton.state === "focused"
                renderType: Text.NativeRendering
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: workspaceButton.state === "focused" ? 18 : 6
                height: 3
                radius: 2
                color: {
                    switch (workspaceButton.state) {
                    case "focused":
                        return root.accentText
                    case "urgent":
                        return root.urgent
                    case "active":
                        return root.activeBorder
                    case "occupied":
                        return root.textMuted
                    default:
                        return root.textDim
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 160
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }

    component SpecialWorkspaceButton: Rectangle {
        id: specialWorkspaceButton

        width: 52
        height: 36
        radius: 10
        color: "#eb34db"
        border.width: 1
        border.color: "#f7a0ef"
        visible: root.specialWorkspaceVisible()

        Behavior on color {
            ColorAnimation { duration: 160 }
        }

        Behavior on border.color {
            ColorAnimation { duration: 160 }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.toggleSpecialWorkspace()
        }

        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "S"
                color: "#2a0726"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                font.bold: true
                renderType: Text.NativeRendering
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 18
                height: 3
                radius: 2
                color: "#2a0726"
            }
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            required property ShellScreen modelData

            screen: modelData
            color: "transparent"
            aboveWindows: true
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: 60

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: 14
                left: 18
                right: 18
            }

            implicitHeight: 54
            height: 54

            Rectangle {
                anchors.fill: parent
                radius: 18
                color: root.panel
                border.width: 1
                border.color: root.border
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 17
                color: "transparent"
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.04)
            }

            Item {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                Item {
                    id: leftZone
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: 360
                    height: parent.height

                    Row {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Capsule {
                            overline: "launch"
                            label: "menu"
                            clickable: true
                            fill: root.panelSoft
                            stroke: root.border
                            textColor: root.text
                            overlineColor: root.accent
                            onActivate: function() {
                                Quickshell.execDetached(["fuzzel"])
                            }
                        }

                        IconCapsule {
                            icon: root.networkLabel
                            clickable: true
                            fill: root.panelSoft
                            stroke: root.border
                            iconColor: root.text
                            onActivate: function() {
                                Quickshell.execDetached([
                                    "bash",
                                    "-lc",
                                    "if command -v nm-connection-editor >/dev/null 2>&1; then nm-connection-editor; elif command -v kitty >/dev/null 2>&1 && command -v nmtui >/dev/null 2>&1; then kitty -e nmtui; fi"
                                ])
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.centerIn: parent
                    width: workspaceRow.implicitWidth
                    height: 36
                    radius: 10
                    color: root.panelSoft
                    border.width: 1
                    border.color: root.border

                    Row {
                        id: workspaceRow
                        anchors.centerIn: parent
                        spacing: 4

                        WorkspaceButton { workspaceId: 1 }
                        WorkspaceButton { workspaceId: 2 }
                        WorkspaceButton { workspaceId: 3 }
                        WorkspaceButton { workspaceId: 4 }
                        WorkspaceButton { workspaceId: 5 }
                        WorkspaceButton { workspaceId: 6 }
                        SpecialWorkspaceButton {}
                    }
                }

                Item {
                    id: rightZone
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 360
                    height: parent.height

                    Row {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Capsule {
                            overline: "volume"
                            label: root.volumeText()
                            clickable: true
                            onActivate: function() {
                                Quickshell.execDetached(["pavucontrol"])
                            }
                        }

                        Capsule {
                            overline: root.micTitle
                            label: root.micLabel
                            clickable: true
                            labelSize: 15
                            horizontalPadding: 12
                            fill: root.micFillColor()
                            stroke: root.micStrokeColor()
                            textColor: root.micTextColor()
                            onActivate: function() {
                                Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"])
                            }
                        }

                        Capsule {
                            overline: "battery"
                            label: root.batteryText()
                            fill: root.batteryFillColor()
                            stroke: root.batteryStrokeColor()
                            textColor: root.batteryTextColor()
                        }

                        Capsule {
                            overline: Qt.formatDateTime(clock.date, "ddd")
                            label: Qt.formatDateTime(clock.date, "HH:mm")
                        }

                        Capsule {
                            overline: "power"
                            label: ""
                            clickable: true
                            labelSize: 15
                            horizontalPadding: 12
                            onActivate: function() {
                                Quickshell.execDetached(["wlogout"])
                            }
                        }
                    }
                }
            }
        }
    }
}
