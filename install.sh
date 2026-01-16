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

echo ""
echo "🔗 Creating global link..."

# Try to install to /usr/local/bin (Global path) - works for everyone immediately
INSTALLED_GLOBALLY=false

if [ -w "/usr/local/bin" ]; then
    ln -sf "$INSTALL_DIR/bin/wifi-autologin" "/usr/local/bin/wifi-autologin"
    INSTALLED_GLOBALLY=true
else
    echo "⚠️  Requesting permission to install globally (for immediate use)..."
    if sudo ln -sf "$INSTALL_DIR/bin/wifi-autologin" "/usr/local/bin/wifi-autologin"; then
         INSTALLED_GLOBALLY=true
    else
         echo "⚠️  Could not install globally. Falling back to local PATH."
    fi
fi

if [ "$INSTALLED_GLOBALLY" = true ]; then
    echo "✅ Installed globally! (No restart needed)"
else
    SHELL_RC="$HOME/.zshrc"
    if ! grep -q "wifi-autologin/bin" "$SHELL_RC" 2>/dev/null; then
        echo "" >> "$SHELL_RC"
        echo "# WiFi Auto-Login" >> "$SHELL_RC"
        echo "export PATH=\"\$HOME/wifi-autologin/bin:\$PATH\"" >> "$SHELL_RC"
        echo "✅ Added to config file ($SHELL_RC)"
    fi
fi

echo ""
echo "================================"
echo "✅ Installation Complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "  1. Run setup: wifi-autologin setup"
echo "  2. Run start: wifi-autologin start"
echo ""
if [ "$INSTALLED_GLOBALLY" = false ]; then
    echo "⚠️  If 'command not found', run this:"
    echo "   source ~/.zshrc"
    echo "   OR use direct path: ~/wifi-autologin/bin/wifi-autologin setup"
fi
echo ""
