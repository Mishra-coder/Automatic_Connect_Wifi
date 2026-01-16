#!/bin/bash

echo "================================"
echo "WiFi Auto-Login Installer"
echo "================================"
echo ""

INSTALL_DIR="$HOME/wifi-autologin"

echo "📥 Downloading files..."
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  Already installed. Updating..."
    cd "$INSTALL_DIR" || exit
    git pull
else
    git clone https://github.com/Mishra-coder/Automatic_Connect_Wifi.git "$INSTALL_DIR"
    cd "$INSTALL_DIR" || exit
fi

echo ""
echo "📦 Installing dependencies..."
python3 -m pip install --user -q -r requirements.txt

chmod +x bin/wifi-autologin

SHELL_RC="$HOME/.zshrc"
if ! grep -q "wifi-autologin/bin" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# WiFi Auto-Login" >> "$SHELL_RC"
    echo "export PATH=\"\$HOME/wifi-autologin/bin:\$PATH\"" >> "$SHELL_RC"
    echo "✅ Added to PATH"
fi

echo ""
echo "================================"
echo "✅ Installation Complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "  1. Restart terminal (or run: source ~/.zshrc)"
echo "  2. Setup: wifi-autologin setup"
echo "  3. Start: wifi-autologin start"
echo ""
echo "Help: wifi-autologin --help"
echo ""
