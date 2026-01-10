# VibeClaude 🎧

<a href="https://dfklabs.vercel.app" target="_blank"><img src="https://img.shields.io/badge/VibeClaude-by%20DFKlabs-blue?style=for-the-badge" alt="VibeClaude"></a>
<a href="LICENSE" target="_blank"><img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge" alt="License: MIT"></a>
<a href="https://www.apple.com/macos" target="_blank"><img src="https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="macOS"></a>
![Claude](https://img.shields.io/badge/Claude-Anthropic-orange?style=for-the-badge)

Monitor for Claude in Xcode - Get notified when Claude finishes generating.

```
  ╦  ╦╦╔╗ ╔═╗╔═╗╦  ╔═╗╦ ╦╔╦╗╔═╗╔╦╗
  ╚╗╔╝║╠╩╗║╣ ║  ║  ╠═╣║ ║ ║║║╣  ║║
   ╚╝ ╩╚═╝╚═╝╚═╝╩═╝╩ ╩╚═╝═╩╝╚═╝═╩╝
```

## Features

- 🔔 Sound notification when Claude finishes
- 🪟 Brings Xcode to foreground automatically
- ⌘R **Auto-Run** - Automatically triggers build & run when Claude finishes
- 📊 Real-time status display with animated spinner
- 🚀 Auto-opens Xcode if not running
- ⏱️ 5-minute idle timeout notification
- ⏸️ Pause/resume monitoring
- 🪶 Lightweight - sleeps when idle

## Installation

```bash
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/vibeclaude/main/xcode.sh
chmod +x xcode.sh
```

## Usage

```bash
./xcode.sh
```

| Key | Action |
|-----|--------|
| `1` | Start monitoring (opens Xcode if needed) |
| `2` | Pause |
| `3` | Exit |
| `0` | Toggle Auto-Run (⌘R) |

### Auto-Run Mode

When Auto-Run is **ON** (enabled by default), VibeClaude will automatically:
1. Play notification sound
2. Bring Xcode to foreground
3. Trigger ⌘R to build and run your project

Toggle with `0` to switch between notification-only and auto-run modes.

## Requirements

- macOS
- Xcode with Claude extension
- Accessibility permissions for Terminal

> **Note:** First run will ask for Accessibility permissions in *System Settings → Privacy & Security → Accessibility*

## License

MIT License - see [LICENSE](LICENSE) for details.

---

Made with ❤️ by <a href="https://dfklabs.vercel.app" target="_blank">DFKlabs</a>
