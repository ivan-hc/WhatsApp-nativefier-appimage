#!/bin/sh

APP=whatsapp-nativefier
mkdir tmp
cd ./tmp
wget -q "$(wget -q https://api.github.com/repos/probonopd/go-appimage/releases -O - | sed 's/"/ /g; s/ /\n/g' | grep -o 'https.*continuous.*tool.*86_64.*mage$')" -O appimagetool
chmod a+x ./appimagetool

VERSION=$(curl -Ls https://api.github.com/repos/frealgagu/archlinux.whatsapp-nativefier/releases/latest | grep -E tag_name | awk -F '[""]' '{print $4}')
URL=$(curl -Ls https://api.github.com/repos/frealgagu/archlinux.whatsapp-nativefier/releases | grep -w -v i386 | grep -w -v i686 | grep -w -v aarch64 | grep -w -v arm64 | grep -w -v armv7l | grep browser_download_url | grep -w -v debug  | grep -i "x86_64.pkg.tar.zst" | cut -d '"' -f 4 | head -1)
wget $URL
tar xf ./*.tar.zst
mkdir $APP.AppDir
mv ./opt/$APP/* ./$APP.AppDir/
wget https://aur.archlinux.org/cgit/aur.git/plain/whatsapp-nativefier.png?h=whatsapp-nativefier -O ./$APP.AppDir/$APP.png
wget https://aur.archlinux.org/cgit/aur.git/plain/whatsapp-nativefier.desktop?h=whatsapp-nativefier -O ./$APP.AppDir/$APP.desktop

cat >> ./$APP.AppDir/AppRun << 'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "${0}")")"
export UNION_PRELOAD="${HERE}"
exec "${HERE}"/WhatsApp "$@"
EOF
chmod a+x ./$APP.AppDir/AppRun
ARCH=x86_64 VERSION=$(./appimagetool -v | grep -o '[[:digit:]]*') ./appimagetool -s ./$APP.AppDir
cd ..
mv ./tmp/*.AppImage ./Whatsapp-nativefier-$VERSION-x86_64.AppImage
