#!/bin/sh

APP=whatsapp-nativefier
mkdir tmp
cd ./tmp
wget -q https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
chmod a+x ./appimagetool

VERSION=$(curl -Ls https://api.github.com/repos/frealgagu/archlinux.whatsapp-nativefier/releases/latest | grep -E tag_name | awk -F '[""]' '{print $4}')
URL=$(curl -Ls https://api.github.com/repos/frealgagu/archlinux.whatsapp-nativefier/releases | grep -w -v i386 | grep -w -v i686 | grep -w -v aarch64 | grep -w -v arm64 | grep -w -v armv7l | grep browser_download_url | grep -w -v debug  | grep -i "x86_64.pkg.tar.zst" | cut -d '"' -f 4 | head -1)
wget $URL
tar xf ./*.tar.zst
mkdir $APP.AppDir
mv ./opt/$APP/* ./$APP.AppDir/
wget https://raw.githubusercontent.com/frealgagu/archlinux.whatsapp-nativefier/refs/heads/master/whatsapp-nativefier.png -O ./$APP.AppDir/$APP.png
wget https://raw.githubusercontent.com/frealgagu/archlinux.whatsapp-nativefier/refs/heads/master/whatsapp-nativefier.desktop -O ./$APP.AppDir/$APP.desktop

cat >> ./$APP.AppDir/AppRun << 'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "${0}")")"
export UNION_PRELOAD="${HERE}"
exec "${HERE}"/WhatsApp "$@"
EOF
chmod a+x ./$APP.AppDir/AppRun
ARCH=x86_64 ./appimagetool --comp zstd --mksquashfs-opt -Xcompression-level --mksquashfs-opt 20 ./$APP.AppDir
cd ..
mv ./tmp/*.AppImage ./Whatsapp-nativefier-$VERSION-x86_64.AppImage
