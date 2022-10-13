#!/usr/bin/env bash

# bin/
# Caddyfile
# caddy.service
# init.sh
# README.md

mkdir caddy && cd caddy

echo 'Downloading caddy.service'
curl -sOL https://raw.githubusercontent.com/caddyserver/dist/master/init/caddy.service

caddy_version=2.6.1
echo "Downloading caddy v${caddy_version}"
curl -sOL https://github.com/caddyserver/caddy/releases/download/v${caddy_version}/caddy_${caddy_version}_linux_amd64.tar.gz
mkdir ./bin
tar zxvf caddy_${caddy_version}_linux_amd64.tar.gz -C bin/
rm -rf caddy_${caddy_version}_linux_amd64*

echo "Create Caddyfile"
cat <<-DELIMITER > Caddyfile
:8080 {
  respond "Caddy Web Server"
}
import sites-enabled/*
DELIMITER

echo "Create init.sh"
cat <<-DELIMITER > init.sh
sudo cp bin/caddy /usr/bin/
sudo cp caddy.service /etc/systemd/system/caddy.service
sudo groupadd --system caddy
sudo useradd --system \\
    --gid caddy \\
    --create-home \\
    --home-dir /var/lib/caddy \\
    --shell /usr/sbin/nologin \\
    --comment "Caddy web server" \\
    caddy
sudo mkdir /etc/caddy
sudo cp Caddyfile /etc/caddy
sudo systemctl daemon-reload
sudo systemctl enable --now caddy
DELIMITER
chmod +x ./init.sh

echo "Create README.md"
cat <<-DELIMITER > README.md
## 使用
\`\`\`bash
sudo ./init.sh
\`\`\`
DELIMITER

