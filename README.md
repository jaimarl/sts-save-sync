# Slay The Spire Save Sync Tool

A **Bash script** designed to synchronize your *Slay The Spire* progress (preferences, saves, and runs) between your Linux PC (Steam) and an Android device using **ADB**.

---

## 🛠️ Prerequisites

* **ADB (Android Debug Bridge):** Must be installed on your PC.
* **USB Debugging:** Enabled in **Developer Options** on your Android device.
* **File Transfer Mode:** Ensure your phone is connected via USB and set to **File Transfer** mode.

---

## ⚠️ CRITICAL: First-Time Setup (PC to Phone)

To ensure that the script can successfully transfer saves from your PC to your phone, you must follow these steps:

1. **Uninstall** *Slay The Spire* from your Android device (if installed).
1. **Reinstall** the game from the Play Store.
1. **Launch** the game.
1. **Close** the game immediately after the developer logo appears.
1. Now you can run the `to_phone` command.

> [!Important]
> Without this, save files will not be transferred due to how Android handles app data permissions.

---

## ⚙️ Functionality

The script synchronizes the following directories:

* `preferences` (Unlock progress, settings)
* `saves` (Active runs)
* `runs` (History of past runs)

Before every transfer, the script automatically creates a **local backup** on the target device to prevent data loss.

---

## 🚀 Usage

Run the script from your terminal with one of the following arguments:

1. Syncing Data
* `./sts-sync.sh to_pc`: **Pulls** saves from your Phone and moves them to your PC.
* `./sts-sync.sh to_phone`: **Pushes** saves from your PC to your Phone.

2. Restoring from Backup
* `./sts-sync.sh restore pc`: Restores the PC save files from the `sync_backup` folder.
* `./sts-sync.sh restore phone`: Restores the Android save files from the internal `sync_backup` folder.

---

## 📂 Technical Details

* **PC Path:** `~/.local/share/Steam/steamapps/common/SlayTheSpire`
* **Android Path:** `/storage/emulated/0/Android/data/com.humble.SlayTheSpire`

> [!NOTE]
> If you are using a different Steam library path, make sure to update the `PC_DIR` variable in the script.
