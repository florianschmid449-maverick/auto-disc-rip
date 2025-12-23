# 💿 Multi-Disc Automated DVD/Blu-ray Ripper

A robust Bash script designed to automate the process of creating bit-perfect ISO backups of your optical media collection. It uses `ddrescue` for error-tolerant reading (great for older, scratched discs) and supports a continuous loop for processing multiple discs in one sitting.

## ✨ Features

* **Auto-Detection:** Automatically detects if a disc is a DVD (iso9660) or Blu-ray to set the appropriate block size.
* **Error Recovery:** Uses `ddrescue` with a two-pass system (fast copy followed by a retry scrape) to handle damaged or scratched discs.
* **Safety Checks:**
* Checks for `ddrescue` installation and installs it if missing (Debian/Ubuntu).
* Verifies sufficient disk space on the Desktop before starting.
* Generates timestamped filenames to prevent overwriting previous rips.


* **Verification:** Calculates and displays the SHA256 checksum of the resulting ISO.
* **Convenience:**
* Automatically mounts the ISO after ripping for immediate verification.
* Ejects the disc upon completion.
* Loops to ask if you want to rip another disc immediately.



## 🛠️ Prerequisites

* **OS:** Linux (Designed for Debian/Ubuntu-based systems due to `apt` usage).
* **Hardware:** An internal or external DVD/Blu-ray drive.
* **Permissions:** `sudo` privileges are required for hardware access (`ddrescue`, `mount`, `eject`).

## 📥 Installation

1. Clone this repository or download the script:
```bash
git clone https://github.com/yourusername/repo-name.git
cd repo-name

```


2. Make the script executable:
```bash
chmod +x rip_script.sh

```



## 🚀 Usage

1. Run the script using sudo:
```bash
sudo ./rip_script.sh

```


2. **Insert a disc** when prompted. The script will:
* Detect the format.
* Check for free space.
* Begin the ripping process.
* Eject the disc when finished.


3. Type `y` to rip another disc, or `n` to exit.

## ⚙️ Configuration

By default, the script assumes your optical drive is located at `/dev/cdrom` and saves files to your `~/Desktop`.

To change this, open the script in a text editor and modify the top variables:

```bash
DVD_DEVICE="/dev/sr0"  # Change if your drive path is different
DESKTOP="/path/to/save/files"

```

## ⚠️ Legal Disclaimer

This script is provided for **archival and backup purposes only** of media you legally own. Circumventing copy protection (DRM) may be illegal in your jurisdiction. Please consult your local laws regarding format shifting and backup copies.

 like me to...

Add a section to the script that automatically runs **HandBrakeCLI** after the rip is finished to convert the ISO into an `.mp4` file?
