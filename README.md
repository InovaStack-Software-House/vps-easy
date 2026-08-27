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