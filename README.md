# nvim-config
My Neovim configuration written in Lua

## External Dependencies

This Neovim configuration requires the following external tools to function properly.

### Required Tools

#### Node.js
Required for GitHub Copilot and language servers.

**Windows:**
```powershell
# Install Node.js from https://nodejs.org/
# Then install neovim package
npm install --global neovim
```

**Ubuntu:**
```bash
# Install Node.js
sudo apt update
sudo apt install nodejs npm

# Install neovim package
npm install --global neovim
```

#### ripgrep
Required for Telescope's live_grep functionality.

**Windows:**
```powershell
# Using Chocolatey
choco install ripgrep

# Or using Scoop
scoop install ripgrep

# Or download from https://github.com/BurntSushi/ripgrep/releases
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install ripgrep
```

#### CMake
Required for building telescope-fzf-native.nvim.

**Windows:**
```powershell
# Using Chocolatey
choco install cmake

# Or download installer from https://cmake.org/download/
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install cmake build-essential
```

#### Git
Required for lazy.nvim plugin management.

**Windows:**
```powershell
# Download and install from https://git-scm.com/download/win
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install git
```

### Optional Tools

#### zenhan / fcitx5
Required for IME control (win-ime-con.nvim plugin).

**Windows:**

```powershell
# Download from https://github.com/iuchim/zenhan
# Place zenhan.exe in your PATH
```

**WSL:**

```bash
# zenhan.exe must be accessible from WSL via the Windows PATH.
# Normally, the Windows PATH is automatically inherited via /mnt/c/...
```

**Linux (or Docker container):**

```bash
# If using fcitx5
sudo apt update
sudo apt install fcitx5
```

**Note:**  If no IME control tool is found in the environment (e.g., a Docker container), IME switching is silently skipped.

#### TypeScript with tsserver

Required for TypeScript language server (after/lsp/ts_ls.lua).

```
npm install -g typescript
```

#### Python with debugpy
Required for Python debugging with nvim-dap.

**Windows:**
```powershell
# Install Python from https://www.python.org/
# Install debugpy
pip install debugpy
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install python3 python3-pip
pip3 install debugpy
```

#### C/C++ Debugger (GDB/LLDB)
Required for C/C++/Fortran debugging with nvim-dap.

**Windows:**
```powershell
# Install MinGW-w64 or MSYS2
# GDB will be included in the toolchain
```

**Ubuntu:**
```bash
sudo apt update
sudo apt install gdb
```
