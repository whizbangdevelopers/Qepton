#!/usr/bin/env bash
# Build Flatpak package for Qepton
# Requires: flatpak, flatpak-builder

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$SCRIPT_DIR/build"
REPO_DIR="$SCRIPT_DIR/repo"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check dependencies
check_deps() {
    if ! command -v flatpak-builder &> /dev/null; then
        log_error "flatpak-builder not found. Install with:"
        echo "  Ubuntu/Debian: sudo apt install flatpak-builder"
        echo "  Fedora: sudo dnf install flatpak-builder"
        echo "  Arch: sudo pacman -S flatpak-builder"
        exit 1
    fi

    # Install required runtimes
    log_info "Installing Flatpak runtimes..."
    flatpak install -y --noninteractive flathub org.freedesktop.Platform//23.08 || true
    flatpak install -y --noninteractive flathub org.freedesktop.Sdk//23.08 || true
    flatpak install -y --noninteractive flathub org.electronjs.Electron2.BaseApp//23.08 || true
}

# Build the Electron app first
build_electron_app() {
    log_info "Building Electron app..."
    cd "$PROJECT_ROOT"

    # Build with AppImage target to get unpacked app
    npm install
    npm run build:electron

    # Copy unpacked app to flatpak build dir
    rm -rf "$BUILD_DIR/app"
    mkdir -p "$BUILD_DIR/app"
    cp -r dist/electron/Packaged/linux-unpacked/* "$BUILD_DIR/app/"
}

# Build Flatpak
build_flatpak() {
    log_info "Building Flatpak..."
    cd "$SCRIPT_DIR"

    # Clean previous builds
    rm -rf .flatpak-builder
    rm -rf "$REPO_DIR"
    mkdir -p "$REPO_DIR"

    # Build
    flatpak-builder --force-clean --repo="$REPO_DIR" build-dir com.cosmox.Qepton.yml

    # Create bundle
    log_info "Creating Flatpak bundle..."
    flatpak build-bundle "$REPO_DIR" qepton.flatpak com.cosmox.Qepton

    log_info "Flatpak bundle created: $SCRIPT_DIR/qepton.flatpak"
}

# Install locally for testing
install_local() {
    log_info "Installing Flatpak locally..."
    flatpak --user install -y "$SCRIPT_DIR/qepton.flatpak"
    log_info "Installed! Run with: flatpak run com.cosmox.Qepton"
}

# Main
case "${1:-build}" in
    deps)
        check_deps
        ;;
    electron)
        build_electron_app
        ;;
    flatpak)
        build_flatpak
        ;;
    install)
        install_local
        ;;
    build|*)
        check_deps
        build_electron_app
        build_flatpak
        log_info "Done! Bundle: $SCRIPT_DIR/qepton.flatpak"
        ;;
esac
