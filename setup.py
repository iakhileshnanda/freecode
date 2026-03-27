#!/usr/bin/env python3
"""
Claude Easy Install - Python setup script
Automatically detects OS and runs appropriate installer
"""

import os
import platform
import subprocess
import sys
import time

def detect_os():
    """Detect the operating system"""
    system = platform.system().lower()
    if system == "windows":
        return "windows"
    elif system == "darwin":
        return "macos"
    elif system == "linux":
        return "linux"
    else:
        return "unknown"

def run_installer():
    """Run the appropriate installer based on OS"""
    os_type = detect_os()
    
    print(f"🖥️  Detected OS: {os_type}")
    
    if os_type == "windows":
        print("🔧 Running Windows PowerShell installer...")
        if os.path.exists("install.ps1"):
            subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", "install.ps1"])
        else:
            print("❌ install.ps1 not found")
            sys.exit(1)
    
    elif os_type in ["linux", "macos"]:
        print("🔧 Running Unix installer...")
        if os.path.exists("install.sh"):
            subprocess.run(["chmod", "+x", "install.sh"])
            subprocess.run(["./install.sh"])
        else:
            print("❌ install.sh not found")
            sys.exit(1)
    
    else:
        print("❌ Unsupported operating system")
        sys.exit(1)

def main():
    """Main setup function"""
    print("🚀 Claude Easy Install - Python Setup")
    print("=" * 40)
    
    # Check if we're in the right directory
    if not os.path.exists("server.py"):
        print("❌ Please run this from the claude-easy-install directory")
        sys.exit(1)
    
    run_installer()
    
    print("\n✅ Setup complete!")
    print("🎉 You can now use Claude Code for free!")

if __name__ == "__main__":
    main()