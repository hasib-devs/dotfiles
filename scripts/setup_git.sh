#!/bin/bash

# =============================================================================
# Git Setup Script
# =============================================================================
# This script sets up Git configuration and user information.

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../setup.sh"

log_step "Setting up Git..."

# Configure Git user information
configure_git_user() {
  log_info "Configuring Git user information..."

  # Prompt for user information
  read -p "Enter your Git username: " git_username
  read -p "Enter your Git email: " git_email

  # Set Git configuration
  git config --global user.name "$git_username"
  git config --global user.email "$git_email"

  log_success "Git user configured: $git_username <$git_email>"
}

# Configure Git settings
configure_git_settings() {
  log_info "Configuring Git settings..."

  # Set default branch name
  git config --global init.defaultBranch main

  # Set default editor
  if command -v nvim &>/dev/null; then
    git config --global core.editor nvim
  elif command -v vim &>/dev/null; then
    git config --global core.editor vim
  else
    git config --global core.editor nano
  fi

  # Set default pager
  if command -v bat &>/dev/null; then
    git config --global core.pager bat
  elif command -v less &>/dev/null; then
    git config --global core.pager less
  fi

  # Enable colorful output
  git config --global color.ui auto

  # Set default merge tool
  git config --global merge.tool vimdiff

  # Configure line endings
  if [[ "$OSTYPE" == "darwin"* ]]; then
    git config --global core.autocrlf input
  else
    git config --global core.autocrlf input
  fi

  # Set default push behavior
  git config --global push.default current

  # Enable automatic pruning of remote-tracking branches
  git config --global fetch.prune true

  # Set credential helper
  if [[ "$OSTYPE" == "darwin"* ]]; then
    git config --global credential.helper osxkeychain
  else
    git config --global credential.helper store
  fi

  # Configure pull strategy
  git config --global pull.rebase false

  # Set default log format
  git config --global log.decorate auto

  # Enable signing commits (optional)
  read -p "Do you want to set up GPG signing for commits? (y/N): " setup_gpg
  if [[ "$setup_gpg" =~ ^[Yy]$ ]]; then
    configure_gpg_signing
  fi

  log_success "Git settings configured"
}

# Configure GPG signing
configure_gpg_signing() {
  log_info "Configuring GPG signing..."

  # Check if GPG is available
  if ! command -v gpg &>/dev/null; then
    log_warning "GPG not found. Skipping GPG configuration."
    return
  fi

  # List existing GPG keys
  log_info "Existing GPG keys:"
  gpg --list-secret-keys --keyid-format LONG

  read -p "Enter your GPG key ID (or press Enter to skip): " gpg_key_id

  if [[ -n "$gpg_key_id" ]]; then
    git config --global user.signingkey "$gpg_key_id"
    git config --global commit.gpgsign true
    git config --global tag.gpgsign true

    log_success "GPG signing configured with key: $gpg_key_id"
  else
    log_info "GPG signing skipped"
  fi
}

# Create Git aliases
create_git_aliases() {
  log_info "Creating Git aliases..."

  # Basic aliases
  git config --global alias.st status
  git config --global alias.co checkout
  git config --global alias.cb 'checkout -b'
  git config --global alias.br branch
  git config --global alias.ci commit
  git config --global alias.cm 'commit -m'
  git config --global alias.ca 'commit -a'
  git config --global alias.cam 'commit -am'
  git config --global alias.df diff
  git config --global alias.dc 'diff --cached'
  git config --global alias.lg 'log --oneline --graph --decorate'
  git config --global alias.lga 'log --oneline --graph --decorate --all'
  git config --global alias.lg1 'log --oneline --graph --decorate -1'
  git config --global alias.lg10 'log --oneline --graph --decorate -10'
  git config --global alias.lg20 'log --oneline --graph --decorate -20'

  # Advanced aliases
  git config --global alias.unstage 'reset HEAD --'
  git config --global alias.last 'log -1 HEAD'
  git config --global alias.visual '!gitk'
  git config --global alias.type 'cat-file -t'
  git config --global alias.dump 'cat-file -p'
  git config --global alias.undo 'reset --soft HEAD^'
  git config --global alias.amend 'commit --amend'
  git config --global alias.who 'shortlog -s --'
  git config --global alias.changed 'diff --name-only'
  git config --global alias.staged 'diff --cached --name-only'

  # Workflow aliases
  git config --global alias.new 'checkout -b'
  git config --global alias.switch 'checkout'
  git config --global alias.publish 'push -u origin HEAD'
  git config --global alias.unpublish 'push origin --delete'
  git config --global alias.cleanup '!git branch --merged | grep -v "\\*" | xargs -n 1 git branch -d'
  git config --global alias.cleanup-remote '!git branch -r --merged | grep -v "\\*" | sed "s/origin\\///" | xargs -n 1 git push origin --delete'

  # Information aliases
  git config --global alias.aliases '!git config --get-regexp alias'
  git config --global alias.config 'config --list'
  git config --global alias.help '!git help'

  log_success "Git aliases created"
}

# Configure Git ignore
configure_git_ignore() {
  log_info "Configuring global Git ignore..."

  local gitignore_global="$HOME/.gitignore_global"

  cat >"$gitignore_global" <<'EOF'
# =============================================================================
# Global Git Ignore File
# =============================================================================

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~
.project
.classpath
.settings/

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
*.lcov

# nyc test coverage
.nyc_output

# Dependency directories
node_modules/
jspm_packages/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.test
.env.local
.env.production

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# Next.js build output
.next

# Nuxt.js build / generate output
.nuxt
dist

# Gatsby files
.cache/
public

# Storybook build outputs
.out
.storybook-out

# Temporary folders
tmp/
temp/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
.hypothesis/
.pytest_cache/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
target/

# Jupyter Notebook
.ipynb_checkpoints

# pyenv
.python-version

# celery beat schedule file
celerybeat-schedule

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Go
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
go.work

# Go workspace file
go.work

# Rust
target/
Cargo.lock

# Java
*.class
*.jar
*.war
*.ear
*.zip
*.tar.gz
*.rar
hs_err_pid*

# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties
dependency-reduced-pom.xml
buildNumber.properties
.mvn/timing.properties
.mvn/wrapper/maven-wrapper.jar

# Gradle
.gradle
build/
!gradle/wrapper/gradle-wrapper.jar
!**/src/main/**/build/
!**/src/test/**/build/

# IntelliJ IDEA
.idea/
*.iws
*.iml
*.ipr
out/
!**/src/main/**/out/
!**/src/test/**/out/

# Eclipse
.apt_generated
.classpath
.factorypath
.project
.settings
.springBeans
.sts4-cache
bin/
!**/src/main/**/bin/
!**/src/test/**/bin/

# NetBeans
/nbproject/private/
/nbbuild/
/dist/
/nbdist/
/.nb-gradle/

# VS Code
.vscode/

# Terraform
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl

# Docker
.dockerignore

# Kubernetes
*.kubeconfig

# AWS
.aws/

# Local development
.env.local
.env.development.local
.env.test.local
.env.production.local
EOF

  git config --global core.excludesfile "$gitignore_global"

  log_success "Global Git ignore configured"
}

# Configure Git hooks (optional)
configure_git_hooks() {
  log_info "Configuring Git hooks..."

  local hooks_dir="$HOME/.git-templates/hooks"
  mkdir -p "$hooks_dir"

  # Set the hooks directory
  git config --global init.templateDir "$HOME/.git-templates"

  # Create pre-commit hook
  cat >"$hooks_dir/pre-commit" <<'EOF'
#!/bin/bash

# Pre-commit hook to run basic checks

echo "Running pre-commit checks..."

# Check for trailing whitespace
if git diff --cached --check; then
    echo "✓ No trailing whitespace found"
else
    echo "✗ Trailing whitespace found. Please fix and commit again."
    exit 1
fi

# Check for merge conflict markers
if git diff --cached | grep -q "^<<<<<<< \|^=======\|^>>>>>>> "; then
    echo "✗ Merge conflict markers found. Please resolve conflicts and commit again."
    exit 1
fi

echo "✓ Pre-commit checks passed"
EOF

  chmod +x "$hooks_dir/pre-commit"

  log_success "Git hooks configured"
}

# Main Git setup
main() {
  configure_git_user
  configure_git_settings
  create_git_aliases
  configure_git_ignore
  configure_git_hooks

  log_success "Git setup completed successfully!"
  log_info "You can now use Git with your configured settings"
  log_info "Use 'git aliases' to see all available aliases"
}

main "$@"
