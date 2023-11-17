#!/usr/bin/env bash

# Custom Eclipse installation with ADT for Eclipse / SonarLint
# ============================================================

DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
OUTPUT_FILE="$DIR/Eclipse.dmg"
OUTPUT_DIR="$DIR/Eclipse"
BUILD_DIR="$DIR/build"

# Replace template with value in a file
function replaceStringInFile() {
    sed -ir "s#$2#$3#" $1
    rm "$1r"
}

# =============================================================================
#   *) Templated and fallback configuration
# =============================================================================

ECLIPSE_TEMPLATE="https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/VERSION/R/eclipse-rcp-VERSION-R-macosx-cocoa-ARCH.dmg&mirror_id=MIRROR\&r=1"
ECLIPSE_VERSION="2023-09"
ECLIPSE_ARCH="$(uname -m)"
if [[ "$ECLIPSE_ARCH" == "arm64" ]]; then
    ECLIPSE_ARCH="aarch64"
fi
ECLIPSE_MIRROR="1285"

# =============================================================================
#   1) Remove old artifacts
# =============================================================================
rm -f $OUTPUT_FILE
rm -rf $OUTPUT_DIR
rm -rf $BUILD_DIR

# =============================================================================
#   2) Build download URL and download artifact
# =============================================================================
ECLIPSE_URL="${ECLIPSE_TEMPLATE//VERSION/$ECLIPSE_VERSION}"
ECLIPSE_URL="${ECLIPSE_URL//ARCH/$ECLIPSE_ARCH}"
ECLIPSE_URL="${ECLIPSE_URL//MIRROR/$ECLIPSE_MIRROR}"

wget $ECLIPSE_URL -O $OUTPUT_FILE

# =============================================================================
#   3) Extract artifact correctly and move it
# =============================================================================
7zz x $OUTPUT_FILE
rm -f $OUTPUT_FILE

mkdir $BUILD_DIR
mv $OUTPUT_DIR/Eclipse.app $BUILD_DIR
rm -rf $OUTPUT_DIR

# =============================================================================
#   4) Install additional feature / plug-ins (SonarLint)
# =============================================================================
$BUILD_DIR/Eclipse.app/Contents/MacOS/eclipse -noSplash -application org.eclipse.equinox.p2.director \
    -repository https://binaries.sonarsource.com/SonarLint-for-Eclipse/releases/ \
    -installIU org.sonarlint.eclipse.feature.feature.group

# =============================================================================
#   5) Create application icon
# =============================================================================
PNG="$DIR/sap.png"
ICON="$BUILD_DIR/sap.icns"
ICON_DIR="$BUILD_DIR/sap.iconset"

mkdir $ICON_DIR >/dev/null
sips -z 16 16   $PNG --out $ICON_DIR/icon_16x16.png
sips -z 32 32   $PNG --out $ICON_DIR/icon_16x16@2x.png
sips -z 32 32   $PNG --out $ICON_DIR/icon_32x32.png
sips -z 64 64   $PNG --out $ICON_DIR/icon_32x32@2x.png
sips -z 128 128 $PNG --out $ICON_DIR/icon_128x128.png
sips -z 256 256 $PNG --out $ICON_DIR/icon_128x128@2x.png
sips -z 256 256 $PNG --out $ICON_DIR/icon_256x256.png
iconutil -c icns $ICON_DIR
rm -R $ICON_DIR

mv $ICON "$BUILD_DIR/Eclipse.app/Contents/Resources/$(basename $ICON)"

# =============================================================================
#   6) Fix configuration: config.ini with default workspace
# =============================================================================
CONFIG_DIR="$BUILD_DIR/Eclipse.app/Contents/Eclipse/configuration"

replaceStringInFile "$CONFIG_DIR/config.ini" "@user.home/Documents/workspace" "@user.home/workspaces/adt_workspace"

# =============================================================================
#   7) Fix installation: eclipse.ini with default workspace
# =============================================================================
ECLIPSE_INI="$BUILD_DIR/Eclipse.app/Contents/Eclipse/eclipse.ini"

replaceStringInFile $ECLIPSE_INI "@user.home/eclipse-workspace" "@user.home/workspaces/adt_workspace"
replaceStringInFile $ECLIPSE_INI "Eclipse.icns" "$(basename $ICON)"

# =============================================================================
#   8) Fix installation: Info.plist with icon
# =============================================================================
INFO_PLIST="$BUILD_DIR/Eclipse.app/Contents/Info.plist"

replaceStringInFile $INFO_PLIST "Eclipse.icns" "$(basename $ICON)"

# =============================================================================
#   9) Remove build script logs and rename application
# =============================================================================
pushd $CONFIG_DIR
rm *.log
popd

touch "$BUILD_DIR/Eclipse.app"
mv "$BUILD_DIR/Eclipse.app" "$BUILD_DIR/ADTclipse.app"

# =============================================================================
#   10) Sign application again
# =============================================================================
codesign --force --deep --sign - "$BUILD_DIR/ADTclipse.app"

# =============================================================================
#   11) Inform about ADT for Eclipse being installed manually
# =============================================================================
echo "ADT for Eclipse must be installed manually from here: https://tools.eu1.hana.ondemand.com/$ECLIPSE_VERSION/"
