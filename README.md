# 🚀 Claude Easy Install

**One-command setup for free Claude Code** - No login dashboard, uses your NVIDIA API key!

## Quick Start

### Automatic Install (Recommended)
```bash
# Clone and run installer
git clone https://github.com/Alishahryar1/free-claude-code.git claude-easy-install
cd claude-easy-install
chmod +x install.sh
./install.sh
```

### Manual Install
```bash
# Install Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# Set your NVIDIA API key in .env file
# Get key from: https://build.nvidia.com/meta/llama-3_1-8b-instruct

# Start free proxy
python3 -m pip install uv
uv run uvicorn server:app --host 0.0.0.0 --port 8082

# Use Claude (new terminal)
ANTHROPIC_AUTH_TOKEN="freecc" ANTHROPIC_BASE_URL="http://localhost:8082" claude
```

## Features
- ✅ **No login required** - Bypasses Claude dashboard
- ✅ **Uses NVIDIA NIM** - High-quality models with your API key
- ✅ **Cross-platform** - Linux, macOS, Windows
- ✅ **Auto-detect OS** - Smart installer
- ✅ **Interactive setup** - Asks for NVIDIA API key
- ✅ **Updated models** - Qwen and Kimi K1.5 models

## Models Used
- **Opus**: Kimi K2 Instruct 0905 (premium reasoning)
- **Sonnet**: Qwen3 Coder 480B (advanced coding)
- **Haiku**: DeepSeek V3.2 (fast & efficient)

## OS Support
- **Linux/macOS**: Uses bash/zsh
- **Windows**: Uses PowerShell
- **Auto-detection**: Runs appropriate commands

## Usage
After install, just run:
```bash
claude-free  # No login required!
```

## Windows Git Bash Auto-Setup
**No manual configuration needed!** The installer automatically:
- Sets `CLAUDE_CODE_GIT_BASH_PATH` to Git's bash.exe
- Configures `ANTHROPIC_AUTH_TOKEN` and `ANTHROPIC_BASE_URL`
- Works with Windows Git Bash out of the box

## Get NVIDIA API Key
1. Visit: https://build.nvidia.com/meta/llama-3_1-8b-instruct
2. Sign up for free account
3. Copy your API key
4. Paste during installation or edit .env file later