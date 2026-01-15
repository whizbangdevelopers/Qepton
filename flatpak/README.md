# Flatpak Build

This directory contains the Flatpak manifest and build scripts for Qepton.

## Prerequisites

- flatpak
- flatpak-builder

### Installing Prerequisites

**Ubuntu/Debian:**
```bash
sudo apt install flatpak flatpak-builder
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

**Fedora:**
```bash
sudo dnf install flatpak flatpak-builder
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

**Arch Linux:**
```bash
sudo pacman -S flatpak flatpak-builder
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## Building

### Full Build

```bash
./build-flatpak.sh
```

This will:
1. Install required Flatpak runtimes
2. Build the Electron app
3. Create the Flatpak bundle

### Step by Step

```bash
# Install runtimes
./build-flatpak.sh deps

# Build Electron app
./build-flatpak.sh electron

# Build Flatpak bundle
./build-flatpak.sh flatpak
```

### Install Locally

```bash
./build-flatpak.sh install
```

Then run:
```bash
flatpak run com.cosmox.Qepton
```

## Output

- `qepton.flatpak` - The Flatpak bundle file
- `repo/` - Local Flatpak repository

## Files

- `com.cosmox.Qepton.yml` - Flatpak manifest
- `com.cosmox.Qepton.desktop` - Desktop entry file
- `com.cosmox.Qepton.metainfo.xml` - AppStream metadata
- `qepton.sh` - Wrapper script for Electron

## Publishing to Flathub

To publish to Flathub, submit a PR to https://github.com/flathub/flathub with the manifest.
