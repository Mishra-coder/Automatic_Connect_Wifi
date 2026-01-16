# homebrew-wifi-autologin

Homebrew tap for WiFi Auto-Login - Automatic WiFi portal login for macOS

## Installation

```bash
# Add the tap
brew tap devendramishra/wifi-autologin

# Install
brew install wifi-autologin
```

## Quick Start

```bash
# Setup your WiFi credentials
wifi-autologin setup

# Start the auto-login service
wifi-autologin start

# Check if it's running
wifi-autologin status
```

## Commands

| Command | Description |
|---------|-------------|
| `wifi-autologin setup` | Setup WiFi credentials (saved in macOS Keychain) |
| `wifi-autologin start` | Start auto-login background service |
| `wifi-autologin stop` | Stop the service |
| `wifi-autologin status` | Check if service is running |
| `wifi-autologin logs` | View recent activity logs |
| `wifi-autologin uninstall` | Completely remove WiFi Auto-Login |

## Features

✅ **Automatic Login** - No more manual portal login  
✅ **Secure** - Credentials stored in macOS Keychain  
✅ **Background Service** - Runs automatically on WiFi connect  
✅ **Easy Updates** - `brew upgrade wifi-autologin`  
✅ **Professional CLI** - Clean command-line interface  

## How It Works

1. Monitors WiFi connection in background
2. Detects captive portal login page
3. Automatically fills and submits credentials
4. Notifies on successful login

## Requirements

- macOS 10.14 or later
- Python 3.11+
- Homebrew

## Uninstallation

```bash
# Stop and remove everything
wifi-autologin uninstall

# Remove via Homebrew
brew uninstall wifi-autologin
brew untap devendramishra/wifi-autologin
```

## Source Code

Main repository: [github.com/devendramishra/wifi-autologin](https://github.com/devendramishra/wifi-autologin)

## License

MIT License

## Support

For issues and questions: [GitHub Issues](https://github.com/devendramishra/wifi-autologin/issues)
