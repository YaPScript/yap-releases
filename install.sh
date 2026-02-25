#!/usr/bin/env bash
set -e

# YaPScript Distribution Installer
# https://github.com/YaPScript/yap-releases

echo "📦 Installing YaPScript..."

# Define repo
REPO="YaPScript/yap-releases"
VERSION="latest"

# Detect OS & Architecture
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# Normalize ARCH
if [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "amd64" ]; then
    ARCH="x86_64"
else
    echo "⚠️  Unsupported architecture: $ARCH"
    echo "Currently, only Linux x86_64 binaries are pre-compiled."
    exit 1
fi

if [ "$OS" != "linux" ]; then
    echo "⚠️  Unsupported operating system: $OS"
    echo "Currently, only Linux is fully supported by pre-compiled binaries."
    exit 1
fi

TAR_NAME="yap-${OS}-${ARCH}.tar.gz"
DOWNLOAD_URL="https://github.com/${REPO}/raw/main/${TAR_NAME}"

# We will install to ~/.local/bin if possible, or /usr/local/bin
INSTALL_DIR="$HOME/.local/bin"

# Ensure install dir exists
mkdir -p "$INSTALL_DIR"

# Download and extract
echo "⬇️  Downloading YaPScript binary..."
curl -sSL "$DOWNLOAD_URL" -o "/tmp/$TAR_NAME"
cd /tmp
tar -xzf "$TAR_NAME"

echo "🔨 Installing to $INSTALL_DIR/yap..."
mv yap "$INSTALL_DIR/yap"
chmod +x "$INSTALL_DIR/yap"
rm "$TAR_NAME"

echo "✅ YaPScript installed successfully!"

# Check if INSTALL_DIR is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "⚠️  Wait! $INSTALL_DIR is not in your PATH."
    echo "Please add this line to your ~/.bashrc or ~/.zshrc:"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\""
    echo ""
else
    echo "🎉 You can now run 'yap --help' to get started."
fi
