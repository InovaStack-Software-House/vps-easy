#!/usr/bin/env bash
#
# Provisionamento da VPS (Ubuntu) - stack sem Docker
# PHP 8.5 + extensões | remove Apache | Node LTS + npm | cloudflared | Caddy
#
# Uso: rode como root (ex: recém logado via SSH/senha na Contabo)
#   chmod +x setup-vps.sh
#   ./setup-vps.sh
#
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Execute este script como root (sudo -i ou logado direto como root)." >&2
  exit 1
fi

CODENAME="$(lsb_release -cs)"
echo "==> Distro detectada: $CODENAME"

echo "==> Atualizando pacotes base..."
apt update -y
apt upgrade -y
apt install -y software-properties-common apt-transport-https ca-certificates curl gnupg lsb-release unzip

########################################
# 2. PHP 8.5 + extensões (via PPA ondrej/php)
########################################
echo "==> Adicionando repositório ondrej/php..."
add-apt-repository -y ppa:ondrej/php
apt update -y

echo "==> Instalando PHP 8.5 + extensões..."
apt install -y \
  php8.5 \
  php8.5-fpm \
  php8.5-cli \
  php8.5-common \
  php8.5-mbstring \
  php8.5-xml \
  php8.5-curl \
  php8.5-zip \
  php8.5-bcmath \
  php8.5-intl \
  php8.5-gd \
  php8.5-pgsql \
  php8.5-mysql \
  php8.5-sqlite3 \
  php8.5-redis \
  php8.5-opcache \
  php8.5-readline \
  php8.5-soap \
  php8.5-ldap \
  php8.5-imagick

########################################
# 1. Remover Apache (caso venha como dependência de algum pacote)
########################################
echo "==> Removendo Apache, se existir..."
systemctl stop apache2 2>/dev/null || true
systemctl disable apache2 2>/dev/null || true
apt purge -y 'apache2*' 2>/dev/null || true
apt autoremove -y

# Trava o Apache pra ele não voltar como dependência de nenhum outro pacote futuro
apt-mark hold apache2 2>/dev/null || true

systemctl enable php8.5-fpm
systemctl restart php8.5-fpm

########################################
# 3. Node.js (LTS atual: 24.x) + npm
########################################
echo "==> Instalando Node.js 24 LTS..."
curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
apt install -y nodejs

########################################
# 4. cloudflared (Cloudflare Tunnel)
########################################
echo "==> Instalando cloudflared..."
mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg -o /usr/share/keyrings/cloudflare-main.gpg
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared ${CODENAME} main" \
  > /etc/apt/sources.list.d/cloudflared.list
apt update -y
apt install -y cloudflared

########################################
# 5. Caddy
########################################
echo "==> Instalando Caddy..."
apt install -y debian-keyring debian-archive-keyring
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
  | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
  > /etc/apt/sources.list.d/caddy-stable.list
apt update -y
apt install -y caddy

########################################
# 6. Docker + Docker Compose plugin
########################################
echo "==> Instalando Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
 
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${CODENAME} stable" \
  > /etc/apt/sources.list.d/docker.list
apt update -y
 
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
 
systemctl enable docker
systemctl start docker
 
########################################
# Resumo
########################################
echo ""
echo "==================== INSTALADO ===================="
php -v
echo "-----------------------------------------------------"
node -v
npm -v
echo "-----------------------------------------------------"
cloudflared -v
echo "-----------------------------------------------------"
caddy version
echo "-----------------------------------------------------"
docker --version
docker compose version
echo "======================================================"
echo "Apache removido/travado, PHP-FPM (php8.5-fpm), Node, Caddy e Docker ativos."
echo "Próximo passo: configurar cloudflared tunnel e o Caddyfile."
