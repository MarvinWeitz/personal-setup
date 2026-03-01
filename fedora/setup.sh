echo "=== Installing Brave ==="
curl -fsS https://dl.brave.com/install.sh | sh

echo "=== Uninstalling Firefox ==="
sudo dnf remove -y firefox || true

echo "=== installing Bitwarden ==="
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.bitwarden.desktop

echo "=== Installing VSCode ==="
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update && sudo dnf install code -y

echo "=== Installing Docker ==="
sudo dnf remove docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-selinux \
  docker-engine-selinux \
  docker-engine
sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl enable --now docker
sudo groupadd docker
sudo usermod -aG docker $USER

echo "=== Configuring Monitor Layout ==="
kscreen-doctor \
  output.DP-9.mode.3840x2160@60 \
  output.DP-9.scale.1.7 \
  output.DP-9.position.0,0 \
  output.DP-9.enable \
  output.DP-11.mode.3840x2160@60 \
  output.DP-11.scale.1.7 \
  output.DP-11.position.2259,0 \
  output.DP-11.enable \
  output.DP-11.primary \
  output.DP-10.mode.3840x2160@60 \
  output.DP-10.scale.1.7 \
  output.DP-10.position.4518,0 \
  output.DP-10.enable \
  output.eDP-1.mode.2880x1920@120 \
  output.eDP-1.scale.1.7 \
  output.eDP-1.position.2455,1271 \
  output.eDP-1.enable
  
echo "=== Configuring Touchpad ==="
TOUCHPAD_INFO=$(sudo libinput list-devices | awk '/PIXA3854|[Tt]ouchpad/{found=1} found && /Id:/{print $2; exit}')
# Id format is "i2c:093a:0274" - extract vendor and product in decimal
VENDOR_HEX=$(echo $TOUCHPAD_INFO | cut -d: -f2)
PRODUCT_HEX=$(echo $TOUCHPAD_INFO | cut -d: -f3)
VENDOR_DEC=$(printf "%d" "0x$VENDOR_HEX")
PRODUCT_DEC=$(printf "%d" "0x$PRODUCT_HEX")
TOUCHPAD_NAME=$(sudo libinput list-devices | grep -i touchpad | grep "Device:" | sed 's/Device: *//')
kwriteconfig6 --file kcminputrc --group "Libinput" --group "$VENDOR_DEC" --group "$PRODUCT_DEC" --group "$TOUCHPAD_NAME" --key "NaturalScroll" "false"
kwriteconfig6 --file kcminputrc --group "Libinput" --group "$VENDOR_DEC" --group "$PRODUCT_DEC" --group "$TOUCHPAD_NAME" --key "ScrollFactor" "0.3"

echo "=== Configuring KRunner ==="
kwriteconfig6 --file krunnerrc --group "General" --key "FreeFloating" "true"
kwriteconfig6 --file kglobalshortcutsrc --group "services" --group "org.kde.krunner.desktop" --key "_launch" "Alt+Space\tMeta+Space"

cat <<EOF

=== Manual TODOs ===
  - VSCode: Login to Github
  - Bitwarden: Login on desktop
  - Brave: Activate sync (Bookmarks, Settings, Extensions, Themes)
  - Brave: Login on Bitwarden extension
  - Docker: Lougout to apply docker group

EOF
