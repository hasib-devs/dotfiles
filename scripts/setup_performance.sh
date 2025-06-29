#!/bin/bash

# =============================================================================
# Performance Monitoring Setup Script
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
  echo -e "${CYAN}[STEP]${NC} $1"
}

# Install system monitoring tools
install_system_monitoring() {
  log_step "Installing system monitoring tools..."

  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS monitoring tools
    if ! command -v htop &>/dev/null; then
      log_info "Installing htop..."
      brew install htop
    fi

    if ! command -v glances &>/dev/null; then
      log_info "Installing glances..."
      pip3 install glances
    fi

    if ! command -v btop &>/dev/null; then
      log_info "Installing btop..."
      brew install btop
    fi

    if ! command -v nvtop &>/dev/null; then
      log_info "Installing nvtop..."
      brew install nvtop
    fi

  else
    # Linux monitoring tools
    case "$(grep -oP '(?<=^ID=).+' /etc/os-release 2>/dev/null | tr -d '"')" in
    "ubuntu" | "debian" | "linuxmint")
      sudo apt update
      sudo apt install -y htop glances btop nvtop iotop
      ;;
    "fedora")
      sudo dnf install -y htop glances btop nvtop iotop
      ;;
    "centos" | "rhel" | "rocky" | "almalinux")
      sudo yum install -y htop glances btop nvtop iotop
      ;;
    "arch" | "manjaro")
      sudo pacman -S --noconfirm htop glances btop nvtop iotop
      ;;
    esac
  fi

  log_success "System monitoring tools installed"
}

# Install development environment monitoring
install_dev_monitoring() {
  log_step "Installing development environment monitoring..."

  # Install Node.js monitoring tools
  if command -v pnpm &>/dev/null; then
    log_info "Installing Node.js monitoring tools..."
    pnpm add -g clinic autocannon 0x
  elif command -v npm &>/dev/null; then
    log_info "Installing Node.js monitoring tools..."
    npm install -g clinic autocannon 0x
  fi

  # Install Python monitoring tools
  if command -v pip3 &>/dev/null; then
    log_info "Installing Python monitoring tools..."
    pip3 install memory-profiler psutil py-spy
  fi

  # Install Go monitoring tools
  if command -v go &>/dev/null; then
    log_info "Installing Go monitoring tools..."
    go install github.com/google/pprof@latest
    go install github.com/uber/go-torch@latest
  fi

  # Install Rust monitoring tools
  if command -v cargo &>/dev/null; then
    log_info "Installing Rust monitoring tools..."
    cargo install flamegraph
    cargo install cargo-watch
  fi

  log_success "Development monitoring tools installed"
}

# Create performance monitoring scripts
create_monitoring_scripts() {
  log_step "Creating performance monitoring scripts..."

  local bin_dir="$HOME/.local/bin"
  mkdir -p "$bin_dir"

  # System health check script
  cat >"$bin_dir/system-health" <<'EOF'
#!/bin/bash

# =============================================================================
# System Health Check Script
# =============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== System Health Check ===${NC}"
echo

# CPU Usage
cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')
echo -e "CPU Usage: ${cpu_usage}%"

# Memory Usage
memory_info=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
total_memory=$(sysctl -n hw.memsize)
free_memory=$((memory_info * 4096))
used_memory=$((total_memory - free_memory))
memory_percent=$((used_memory * 100 / total_memory))

echo -e "Memory Usage: ${memory_percent}%"

# Disk Usage
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
echo -e "Disk Usage: ${disk_usage}%"

# Network Status
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo -e "Network: ${GREEN}Connected${NC}"
else
    echo -e "Network: ${RED}Disconnected${NC}"
fi

# Development Tools Status
echo
echo -e "${BLUE}=== Development Tools Status ===${NC}"

tools=("node" "python3" "php" "go" "rustc" "docker" "git" "nvim" "tmux")
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        version=$($tool --version 2>/dev/null | head -n1)
        echo -e "${GREEN}✓${NC} $tool: $version"
    else
        echo -e "${RED}✗${NC} $tool: Not installed"
    fi
done

echo
echo -e "${BLUE}=== Recommendations ===${NC}"

if [[ $cpu_usage -gt 80 ]]; then
    echo -e "${YELLOW}⚠ CPU usage is high. Consider closing unnecessary applications.${NC}"
fi

if [[ $memory_percent -gt 80 ]]; then
    echo -e "${YELLOW}⚠ Memory usage is high. Consider freeing up memory.${NC}"
fi

if [[ $disk_usage -gt 80 ]]; then
    echo -e "${YELLOW}⚠ Disk usage is high. Consider cleaning up files.${NC}"
fi
EOF

  # Development environment performance script
  cat >"$bin_dir/dev-performance" <<'EOF'
#!/bin/bash

# =============================================================================
# Development Environment Performance Script
# =============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Development Environment Performance ===${NC}"
echo

# Neovim startup time
if command -v nvim &> /dev/null; then
    echo -e "${BLUE}Testing Neovim startup time...${NC}"
    start_time=$(date +%s%N)
    nvim --headless -c "quit" 2>/dev/null
    end_time=$(date +%s%N)
    startup_time=$(( (end_time - start_time) / 1000000 ))
    echo -e "Neovim startup time: ${startup_time}ms"
    
    if [[ $startup_time -gt 1000 ]]; then
        echo -e "${YELLOW}⚠ Neovim startup is slow. Consider optimizing configuration.${NC}"
    else
        echo -e "${GREEN}✓ Neovim startup is fast${NC}"
    fi
fi

echo

# Node.js performance
if command -v node &> /dev/null; then
    echo -e "${BLUE}Node.js Performance Test${NC}"
    node -e "
    const start = Date.now();
    for(let i = 0; i < 1000000; i++) {
        Math.random();
    }
    console.log('Node.js computation time:', Date.now() - start, 'ms');
    "
fi

echo

# Python performance
if command -v python3 &> /dev/null; then
    echo -e "${BLUE}Python Performance Test${NC}"
    python3 -c "
import time
import random
start = time.time()
for _ in range(1000000):
    random.random()
print(f'Python computation time: {(time.time() - start) * 1000:.0f} ms')
"
fi

echo

# Git performance
if command -v git &> /dev/null; then
    echo -e "${BLUE}Git Performance Test${NC}"
    if git rev-parse --git-dir &> /dev/null; then
        start_time=$(date +%s%N)
        git status &> /dev/null
        end_time=$(date +%s%N)
        git_time=$(( (end_time - start_time) / 1000000 ))
        echo -e "Git status time: ${git_time}ms"
    else
        echo -e "${YELLOW}Not in a git repository${NC}"
    fi
fi
EOF

  # Resource monitoring script
  cat >"$bin_dir/monitor-resources" <<'EOF'
#!/bin/bash

# =============================================================================
# Real-time Resource Monitoring Script
# =============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to get CPU usage
get_cpu_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//'
    else
        top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//'
    fi
}

# Function to get memory usage
get_memory_usage() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//'
    else
        free | grep Mem | awk '{printf("%.1f", $3/$2 * 100.0)}'
    fi
}

# Function to get disk usage
get_disk_usage() {
    df -h / | awk 'NR==2 {print $5}' | sed 's/%//'
}

echo -e "${BLUE}=== Real-time Resource Monitoring ===${NC}"
echo -e "Press Ctrl+C to stop"
echo

while true; do
    # Clear previous lines
    printf "\033[3A\033[K"
    
    cpu=$(get_cpu_usage)
    memory=$(get_memory_usage)
    disk=$(get_disk_usage)
    
    # CPU color coding
    if [[ $cpu -gt 80 ]]; then
        cpu_color=$RED
    elif [[ $cpu -gt 60 ]]; then
        cpu_color=$YELLOW
    else
        cpu_color=$GREEN
    fi
    
    # Memory color coding
    if [[ $memory -gt 80 ]]; then
        mem_color=$RED
    elif [[ $memory -gt 60 ]]; then
        mem_color=$YELLOW
    else
        mem_color=$GREEN
    fi
    
    # Disk color coding
    if [[ $disk -gt 80 ]]; then
        disk_color=$RED
    elif [[ $disk -gt 60 ]]; then
        disk_color=$YELLOW
    else
        disk_color=$GREEN
    fi
    
    echo -e "CPU: ${cpu_color}${cpu}%${NC} | Memory: ${mem_color}${memory}%${NC} | Disk: ${disk_color}${disk}%${NC}"
    echo -e "Time: $(date '+%H:%M:%S')"
    echo
    
    sleep 2
done
EOF

  # Make scripts executable
  chmod +x "$bin_dir/system-health"
  chmod +x "$bin_dir/dev-performance"
  chmod +x "$bin_dir/monitor-resources"

  log_success "Performance monitoring scripts created"
}

# Create Neovim performance configuration
create_nvim_performance_config() {
  log_step "Creating Neovim performance configuration..."

  local nvim_config_dir="$HOME/.config/nvim"
  local performance_file="$nvim_config_dir/lua/features/performance.lua"

  mkdir -p "$(dirname "$performance_file")"

  cat >"$performance_file" <<'EOF'
-- =============================================================================
-- Performance Monitoring and Optimization
-- =============================================================================

local M = {}

-- Performance monitoring functions
local function measure_startup_time()
    local start_time = vim.loop.hrtime()
    
    -- Create a timer to measure startup time
    vim.defer_fn(function()
        local end_time = vim.loop.hrtime()
        local startup_time = (end_time - start_time) / 1000000
        vim.notify("Neovim startup time: " .. string.format("%.2f", startup_time) .. "ms", vim.log.levels.INFO)
    end, 100)
end

-- Memory usage monitoring
local function get_memory_usage()
    local meminfo = vim.loop.get_memory_info()
    if meminfo then
        local usage_mb = meminfo.rss / 1024 / 1024
        return string.format("%.1f MB", usage_mb)
    end
    return "Unknown"
end

-- Performance optimization settings
local function setup_performance_optimizations()
    -- Disable unused providers
    vim.g.loaded_python3_provider = 0
    vim.g.loaded_ruby_provider = 0
    vim.g.loaded_node_provider = 0
    vim.g.loaded_perl_provider = 0
    
    -- Optimize for performance
    vim.opt.lazyredraw = true
    vim.opt.synmaxcol = 200
    vim.opt.updatetime = 100
    vim.opt.timeoutlen = 300
    
    -- Disable unused features
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_matchparen = 1
    vim.g.loaded_2html_plugin = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_tutor_mode_plugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1
end

-- Performance monitoring commands
local function setup_performance_commands()
    -- Command to show memory usage
    vim.api.nvim_create_user_command('Memory', function()
        local usage = get_memory_usage()
        vim.notify("Memory usage: " .. usage, vim.log.levels.INFO)
    end, {})
    
    -- Command to show startup time
    vim.api.nvim_create_user_command('StartupTime', function()
        measure_startup_time()
    end, {})
    
    -- Command to profile current file
    vim.api.nvim_create_user_command('Profile', function()
        vim.cmd('profile start profile.log')
        vim.cmd('profile func *')
        vim.cmd('profile file *')
        vim.notify("Profiling started. Use :profile pause to stop.", vim.log.levels.INFO)
    end, {})
end

-- Performance keymaps
local function setup_performance_keymaps()
    local opts = { noremap = true, silent = true }
    
    -- Quick performance checks
    vim.keymap.set('n', '<leader>pm', function()
        local usage = get_memory_usage()
        vim.notify("Memory: " .. usage, vim.log.levels.INFO)
    end, opts)
    
    vim.keymap.set('n', '<leader>ps', function()
        measure_startup_time()
    end, opts)
    
    -- Toggle performance optimizations
    vim.keymap.set('n', '<leader>po', function()
        vim.opt.lazyredraw = not vim.opt.lazyredraw
        vim.notify("Lazy redraw: " .. tostring(vim.opt.lazyredraw), vim.log.levels.INFO)
    end, opts)
end

-- Initialize performance monitoring
function M.setup()
    setup_performance_optimizations()
    setup_performance_commands()
    setup_performance_keymaps()
    
    -- Measure startup time on startup
    measure_startup_time()
    
    vim.notify("Performance monitoring initialized", vim.log.levels.INFO)
end

return M
EOF

  log_success "Neovim performance configuration created"
}

# Create performance dashboard
create_performance_dashboard() {
  log_step "Creating performance dashboard..."

  local bin_dir="$HOME/.local/bin"

  cat >"$bin_dir/performance-dashboard" <<'EOF'
#!/bin/bash

# =============================================================================
# Performance Dashboard
# =============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    PERFORMANCE DASHBOARD                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

while true; do
    # Get system information
    cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')
    memory_info=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
    total_memory=$(sysctl -n hw.memsize)
    free_memory=$((memory_info * 4096))
    used_memory=$((total_memory - free_memory))
    memory_percent=$((used_memory * 100 / total_memory))
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    # Clear previous content
    printf "\033[6A\033[K"
    
    # Display metrics
    echo -e "${BLUE}System Metrics:${NC}"
    echo -e "CPU Usage:    ${cpu_usage}%"
    echo -e "Memory Usage: ${memory_percent}%"
    echo -e "Disk Usage:   ${disk_usage}%"
    echo -e "Time:         $(date '+%Y-%m-%d %H:%M:%S')"
    echo
    
    # Color coding
    if [[ $cpu_usage -gt 80 ]]; then
        echo -e "${RED}⚠ High CPU usage detected${NC}"
    fi
    
    if [[ $memory_percent -gt 80 ]]; then
        echo -e "${RED}⚠ High memory usage detected${NC}"
    fi
    
    if [[ $disk_usage -gt 80 ]]; then
        echo -e "${RED}⚠ High disk usage detected${NC}"
    fi
    
    echo
    echo -e "${YELLOW}Press Ctrl+C to exit${NC}"
    
    sleep 5
done
EOF

  chmod +x "$bin_dir/performance-dashboard"

  log_success "Performance dashboard created"
}

# Create performance aliases
create_performance_aliases() {
  log_step "Creating performance monitoring aliases..."

  local aliases=(
    "alias health='system-health'"
    "alias perf='dev-performance'"
    "alias monitor='monitor-resources'"
    "alias dashboard='performance-dashboard'"
    "alias top='htop'"
    "alias top2='btop'"
    "alias top3='glances'"
  )

  for alias in "${aliases[@]}"; do
    if ! grep -q "$alias" ~/.bashrc 2>/dev/null; then
      echo "$alias" >>~/.bashrc
    fi

    if ! grep -q "$alias" ~/.zshrc 2>/dev/null; then
      echo "$alias" >>~/.zshrc
    fi
  done

  log_success "Performance monitoring aliases created"
}

# Main setup function
setup_performance_monitoring() {
  log_step "Setting up performance monitoring..."

  install_system_monitoring
  install_dev_monitoring
  create_monitoring_scripts
  create_nvim_performance_config
  create_performance_dashboard
  create_performance_aliases

  log_success "Performance monitoring setup completed!"
  echo
  echo -e "${CYAN}Available commands:${NC}"
  echo -e "  ${GREEN}health${NC}      - System health check"
  echo -e "  ${GREEN}perf${NC}        - Development environment performance"
  echo -e "  ${GREEN}monitor${NC}     - Real-time resource monitoring"
  echo -e "  ${GREEN}dashboard${NC}   - Performance dashboard"
  echo -e "  ${GREEN}top${NC}         - Enhanced system monitor (htop)"
  echo -e "  ${GREEN}top2${NC}        - Advanced system monitor (btop)"
  echo -e "  ${GREEN}top3${NC}        - Comprehensive monitor (glances)"
  echo
  echo -e "${CYAN}Neovim performance commands:${NC}"
  echo -e "  ${GREEN}:Memory${NC}     - Show memory usage"
  echo -e "  ${GREEN}:StartupTime${NC} - Measure startup time"
  echo -e "  ${GREEN}:Profile${NC}    - Start profiling"
  echo -e "  ${GREEN}<leader>pm${NC}  - Quick memory check"
  echo -e "  ${GREEN}<leader>ps${NC}  - Quick startup time"
  echo -e "  ${GREEN}<leader>po${NC}  - Toggle optimizations"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_performance_monitoring
fi
