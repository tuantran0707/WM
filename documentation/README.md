# End-of-Line (EOL) Factory Documentation

This repository contains End-of-Line (EOL) factory documentation, tools, firmware links, and procedures used for on-site manufacturing, testing, and validation of NubeIO devices.

The content is based on onsite factory activities in China (15 Dec) and is intended for factory engineers, QA, and developers.

##  Generate Google Docs Version

### Design Specifications

All generated documentation uses company template styling:
- **Primary Color:** `#329a9b` (Teal/Turquoise)
- **Font:** Roboto
- **Professional Layout:** Based on company template
- **Automatic Table of Contents**

 Company template applied from: `GoogleDocs-Output/reference-document/MicroEdge Flashing and Testing_v1.0.1.docx`

See [STYLING-SETUP.md](STYLING-SETUP.md) for details.

### Generate All Documentation

To convert all markdown documentation files (including this README) to Google Docs format (.docx) with custom styling:

```bash
./generate-all-docs.sh
```

This will generate styled .docx files for:
- Main README  `GoogleDocs-Output/EOL_Factory_Documentation.docx`
- All DUT device documentation  `GoogleDocs-Output/Gen1/` and `GoogleDocs-Output/Gen2/`
- Support board documentation  `GoogleDocs-Output/SupportBoards/`

### Generate Individual Files

To convert a specific markdown file to .docx format with custom styling:

```bash
# Main README
pandoc README.md --reference-doc=reference-document.docx --toc \
  -o "GoogleDocs-Output/EOL_Factory_Documentation.docx"

# Example: MicroEdge documentation
pandoc DUT/GEN1/MicroEdge/MicroEdge_Flashing_and_Testing_v1.0.1.md \
  --reference-doc=reference-document.docx --toc \
  -o GoogleDocs-Output/Gen1/MicroEdge/MicroEdge_Flashing_and_Testing_v1.0.1.docx
```

After generating .docx files, upload them to Google Drive where they will automatically convert to Google Docs format.

See [GoogleDocs-Output/README.md](GoogleDocs-Output/README.md) for detailed instructions.

##  Scope

This documentation covers:

- EOL factory tooling (desktop application)
- Printer setup and label printing
- Supported DUTs (Devices Under Test)
- Support boards used during testing
- Firmware build & flashing references
- Known issues encountered onsite
- Investigation notes and TODOs

##  Nube iO EOL Factory (All-in-One Tool)

### Build Tool Installer

The EOL toolkit is packaged as a portable Windows application using Electron.

```bash
npx electron-builder --win portable --config.directories.output=dist
```

###  Important

- Run the build as Administrator
- Ensure `electron-builder` is installed

```json
"devDependencies": {
  "electron-builder": "^24.9.1"
}
```

###  Toolkit Repository

[NubeiO-Eol-Toolkit](https://github.com/NubeIO/NubeiO-Eol-Toolkit)

##  Printer Setup

### Supported Printer

**Brother P-Touch P900W**

### Resources

- **Product page:**  
  https://brothermobilesolutions.com/products/printers/p-touch/pt-desktop/ptp900w/

- **Drivers & tools:**  
  https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=p900weus&os=10069

### Installation Notes

1. Connect printer via USB cable for initial setup
2. If auto-detect fails:
   - Manually select the printer during installation
   - Install drivers first, then reconnect USB
3. Brother resource tools already include:
   - Printer driver
   - P-Touch Editor

###  Hello World Test

- Use P-Touch Editor
- Print a sample label to verify setup

##  Devices Under Test (DUT)

### GEN 1

#### Micro Edge

**Documentation:**  
[The Micro Edge DUT](https://www.notion.so/The-Micro-Edge-DUT-2c3ef58db55e80e5899bd66287634c65)

### GEN 2

#### ACB-M

[The ACB-M DUT](https://www.notion.so/The-ACB-M-DUT-2c3ef58db55e807ca632d8bc5c5418c8)

#### ZC-LCD

[The ZC-LCD DUT](https://www.notion.so/The-ZC-LCD-DUT-2c3ef58db55e8065abe8f0a6851427e9)

#### ZC-Controller (Damper)

[The ZC-controller damper DUT](https://www.notion.so/The-ZC-controller-damper-DUT-2c3ef58db55e8013a62cf01e04388e31)

#### Droplet

[Droplet DUT](https://www.notion.so/Droplet-DUT-2c3ef58db55e80b6b760f460e1ccdc16)

##  Support Boards

### AC-Connect

- Used as a device testing support board
- Assists with communication and validation

### ZC-Input-14In-8out

- Support board for reading ZoneController damper outputs
- 14 inputs, 8 outputs interface

##  Firmware & Flashing References

> **Note:** Keep firmware images in a single folder and flash together where possible.

### Support Board Firmware

#### AC-Connect

[FGA-Gen2-Fw - Factory Testing Device Test](https://github.com/NubeIO/FGA-Gen2-Fw/tree/feature/factory-testing-device-test)

#### ZC-Input-14In-8out

Used to read output of ZoneController damper board

### GEN 1 Firmware

#### MicroEdge

[rubix-micro-edge - Factory Testing](https://github.com/NubeIO/rubix-micro-edge/tree/feature/factory-testing-micro-edge)

### GEN 2 Firmware

#### ZC-LCD

**Factory testing code:**  
[ZC-LCD - Factory Testing](https://github.com/NubeIO/ZC-LCD/tree/factory-testing-zc-lcd)

#### ACB-M

**Factory testing code:**  
[ACB-M - Factory Testing](https://github.com/NubeIO/ACB-M/tree/factory-testing-ACB-M)

**Official branches:**
- `feature/integrate-new-lcd-version`
- `feature/zone-control`

#### ZoneController (Dampers)

**Factory testing code:**  
[zc-zoneio - Factory Testing](https://github.com/NubeIO/zc-zoneio/tree/factory-testing-zc-controller)

#### Droplet

**Test code:**  
[Droplet_V2 - AT Command Factory](https://github.com/NubeIO/Droplet_V2/tree/test/atcmd_factory)

**Official branch:**
- `feature/improve-register`


Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force; Set-Location C:\Users\Admin\Desktop\Nube-iO\eol-verification-docs\eol-verification-docs; .\generate-all-docs.ps1


---
*Last updated: March 11, 2026*
