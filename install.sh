#!/bin/bash

# Claude Easy Install - One-command setup for free Claude Code
# Detects OS and installs everything automatically

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║         Claude Easy Install          ║"
    echo "║      Free Claude Code Setup          ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
}

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    echo -e "${GREEN}Detected OS: $OS${NC}"
}

check_dependencies() {
    echo -e "${YELLOW}Checking dependencies...${NC}"
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Python 3 not found. Please install Python 3.8+ first${NC}"
        exit 1
    fi
    
    # Check curl
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}curl not found. Please install curl first${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Dependencies OK${NC}"
}

install_claude() {
    echo -e "${YELLOW}Installing Claude Code...${NC}"
    
    if [[ "$OS" == "windows" ]]; then
        # Windows PowerShell command
        powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://claude.ai/install.sh'))"
    else
        # Linux/macOS
        curl -fsSL https://claude.ai/install.sh | bash
    fi
    
    echo -e "${GREEN}Claude Code installed${NC}"
}

install_uv() {
    echo -e "${YELLOW}Installing uv (Python package manager)...${NC}"
    
    if [[ "$OS" == "windows" ]]; then
        powershell -Command "irm https://astral.sh/uv/install.ps1 | iex"
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
    
    # Add to PATH if not already there
    if [[ "$OS" != "windows" ]]; then
        export PATH="$HOME/.local/bin:$PATH"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
    
    echo -e "${GREEN}uv installed${NC}"
}

setup_config() {
    echo -e "${YELLOW}Setting up configuration...${NC}"
    
    # Ask user for NVIDIA API key
    echo -e "${BLUE}Do you have an NVIDIA API key? (get from: https://build.nvidia.com/meta/llama-3_1-8b-instruct)${NC}"
    read -p "Enter your NVIDIA API key (or press Enter to skip): " nvidia_key
    
    if [[ -z "$nvidia_key" ]]; then
        echo -e "${YELLOW}No API key provided. You'll need to update .env file manually later.${NC}"
        nvidia_key="YOUR_NVIDIA_API_KEY_HERE"
    else
        echo -e "${GREEN}NVIDIA API key received${NC}"
    fi
    
    # Create .env file with user-provided key and updated models
    cat > .env << EOF
# Free Claude Code Configuration
# Uses NVIDIA NIM models

# NVIDIA API Key (get from: https://build.nvidia.com/meta/llama-3_1-8b-instruct)
NVIDIA_NIM_API_KEY="$nvidia_key"

# Model configurations
MODEL_OPUS="nvidia_nim/moonshotai/kimi-k2-instruct-0905"
MODEL_SONNET="nvidia_nim/qwen/qwen3-coder-480b-a35b-instruct"
MODEL_HAIKU="nvidia_nim/deepseek-ai/deepseek-v3_2"
MODEL="nvidia_nim/deepseek-ai/deepseek-v3_2"

# Claude bypass settings
ANTHROPIC_AUTH_TOKEN="freecc"
ANTHROPIC_BASE_URL="http://localhost:8082"
EOF
    echo -e "${GREEN}Configuration created at .env${NC}"
    
    if [[ "$nvidia_key" == "YOUR_NVIDIA_API_KEY_HERE" ]]; then
        echo -e "${YELLOW}⚠️  Please edit .env file and replace YOUR_NVIDIA_API_KEY_HERE with your actual key${NC}"
    fi
}

start_server() {
    echo -e "${YELLOW}Starting Claude proxy server...${NC}"
    
    # Start server in background
    if [[ "$OS" == "windows" ]]; then
        start cmd /k "uv run uvicorn server:app --host 0.0.0.0 --port 8082"
    else
        nohup uv run uvicorn server:app --host 0.0.0.0 --port 8082 > server.log 2>&1 &
        echo $! > server.pid
    fi
    
    sleep 3
    echo -e "${GREEN}Server started on port 8082${NC}"
}

create_aliases() {
    echo -e "${YELLOW}Creating shortcuts...${NC}"
    
    # Create claude command that bypasses login
    if [[ "$OS" == "windows" ]]; then
        # Windows batch file
        cat > claude-free.bat << EOF
@echo off
echo Starting Claude Code (Free)...
set CLAUDE_CODE_GIT_BASH_PATH=C:/Users/anshita/AppData/Local/Programs/Git/bin/bash.exe
set ANTHROPIC_AUTH_TOKEN=freecc
set ANTHROPIC_BASE_URL=http://localhost:8082
claude %*
pause
EOF
        echo "Created claude-free.bat - use this instead of 'claude'"
    else
        # Linux/macOS alias
        cat > claude-free << EOF
#!/bin/bash
export CLAUDE_CODE_GIT_BASH_PATH="C:/Users/anshita/AppData/Local/Programs/Git/bin/bash.exe"
export ANTHROPIC_AUTH_TOKEN="freecc"
export ANTHROPIC_BASE_URL="http://localhost:8082"
claude "\$@"
EOF
        chmod +x claude-free
        sudo mv claude-free /usr/local/bin/ 2>/dev/null || mv claude-free ~/bin/ 2>/dev/null || echo "Move claude-free to your PATH manually"
        echo "Created 'claude-free' command"
    fi
}

print_success() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════╗"
    echo "║         Installation Complete!        ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [[ "$OS" == "windows" ]]; then
        echo "Run: claude-free.bat"
    else
        echo "Run: claude-free"
    fi
    
    echo ""
    echo "That's it! No login required."
    echo "Server running on http://localhost:8082"
}

# Main execution
print_banner
detect_os
check_dependencies
install_claude
install_uv
setup_config
start_server
create_aliases
print_success