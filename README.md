# RotAway

> A lightweight macOS menu bar utility that automatically purges your trash after a customizable countdown.

RotAway lives silently in your system menu bar and ensures your digital waste bin rots away entirely on your own terms—whether that is every 5 seconds for absolute testing or every 30 days for routine maintenance.

---

## Features

* **Granular Control:** Choose custom intervals down to seconds, minutes, or days.
* **Smart Onboarding:** Detects first-time launches and assists with necessary permissions.
* **Ultra Lightweight:** Runs silently as a background agent with zero dock clutter.
* **Native Design:** Built purely in Swift and SwiftUI to match modern macOS aesthetics.

---

## Installation & Setup

Because RotAway securely deletes files globally from your system Trash directory, macOS requires a quick one-time permission clearance during its first launch:

1. Head over to the **Releases** tab and download the latest `RotAway.app.zip`.
2. Unzip the file and drag `RotAway.app` into your **Applications** folder.
3. Double-click `RotAway.app` to open the app. 
4. Go to your menu bar to access the welcome screen.
5. Click **Grant Permission** to automatically jump to your Mac's security settings.
6. Turn the toggle **ON** for RotAway under **System Settings > Privacy & Security > Full Disk Access**.
7. Click **I've Granted It - Start App** to unlock your control board!

---

## Requirements

* macOS 13.0 (Ventura) or later
* Xcode 14+ (only if compiling directly from source code)

---

## License

Distributed under the GNU General Public License v3.0 (GPL-3.0). See the accompanying `LICENSE` file for more details.
