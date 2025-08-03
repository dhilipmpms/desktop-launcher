# Desktop Launcher

A lightweight utility to launch desktop applications via a simple **CLI** or **GUI** interface on Linux.

---

## 📦 Installation

### 🔹 Method 1: Download and Install `.deb` Package (Recommended for Beginners)

1. [Download the latest `.deb` file](https://github.com/dhilipmpms/desktop-launcher/releases) from the **Releases** section.
2. Install it using:

```bash
sudo dpkg -i desktop-launcher_*.deb
sudo apt install -f  # To fix dependencies if any

Launch the GUI manager:
bash:
desktop-launcher-manager

🔹 Method 2: Manual Installation from Source
git clone https://github.com/dhilipmpms/desktop-launcher.git
cd desktop-launcher
chmod +x *

Run CLI:
./desktop-launcher-cli.sh

Run GUI:
./desktop-launcher-manager.sh

🧰 Requirements
sudo apt install zenity wmctrl x11-utils libnotify-bin

📤 Contributing

Pull requests and issue reports are welcome!


📝 License

Free and Open Source. See LICENSE for more details.


