# WiFi Auto-Login 🚀

**Frustrated with College WiFi (Newton Portal)?**
No need to login again and again! This tool will automatically login for you. 😎

---

## 🛠️ Step 1: How to Install

Just copy-paste this **one line** in Terminal and press Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/Mishra-coder/Automatic_Connect_Wifi/main/install.sh | bash
```

That's it, installed! 🎉

---

## ⚙️ Step 2: Setup (Once Only)

Now you need to save your account and password (it is secure, saved in macOS Keychain).

Type in Terminal:
```bash
wifi-autologin setup
```
- Enter your WiFi account.
- Enter your WiFi password.

---

## ▶️ Step 3: Start Service

To start the service, type:
```bash
wifi-autologin start
```

**That's it! Now your Mac will automatically login.** ✅
Whenever you come to college and WiFi connects, it will automatically login.

---

## 🔍 Commands Cheat Sheet

| Task | Command |
|------|---------|
| Check status | `wifi-autologin status` |
| View logs | `wifi-autologin logs` |
| Stop service | `wifi-autologin stop` |
| Uninstall | `wifi-autologin uninstall` |

---

## ❓ Common Questions

**Q: Command not found error?**
A: Restart your terminal.
If it still doesn't work, try running this command directly:
```bash
~/wifi-autologin/bin/wifi-autologin setup
```

**Q: Is this safe?**
A: Yes, absolutely! Your password is saved encrypted in macOS Keychain (just like Safari saves passwords).

**Q: Will it run after restart?**
A: Yes, it runs in the background.

**Q: If I need to change password?**
A: Just run `wifi-autologin setup` again.

---

**Made for Friends **
