# 🚀 Setup do Orquestrador IA - InovaStack

Este é o ambiente isolado para o Hermes Agent coordenar o OpenCode CLI em projetos Laravel e Nuxt.

## 1. Estrutura de Pastas na VPS
Antes de iniciar, crie a seguinte estrutura no seu diretório home (`~/`):

```text
/home/seu-usuario/ai-orquestrador/
├── .env
├── docker-compose.yml
├── Dockerfile.workspace
├── opencode-config/     <-- Coloque suas pastas de 'skills', 'agents' e o 'AGENT.MD' aqui!
└── workspace/           <-- Seus projetos (ex: /projeto-salao, /fluenzia) vão aparecer aqui.
```

## 2. Setup da VPS

- Atualiza o sistema e instala dependências base (curl, gnupg, etc.)
- Para/desabilita/purga o Apache (apt purge 'apache2*') e dá apt-mark hold nele pra nenhum outro pacote reinstalar como dependência depois
- Adiciona o PPA ondrej/php e instala PHP 8.5 + extensões (fpm, cli, mbstring, xml, curl, zip, bcmath, intl, gd, pgsql, mysql, sqlite3, redis, opcache, readline, soap, ldap, imagick), habilita e sobe o php8.5-fpm
- Instala Node.js 24.x (LTS ativa atualmente) + npm via NodeSource
- Instala cloudflared pelo repo oficial da Cloudflare
- Instala Caddy pelo repo oficial (Cloudsmith)
- No fim, imprime as versões de tudo pra conferência

```text
chmod +x setup-vps.sh
./setup-vps.sh
```
