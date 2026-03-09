#!/usr/bin/env bash

set -e

echo "===== Настройка Zsh + Powerlevel10k + Oh My Zsh ====="

# -------------------------------
# 2. Установка Oh My Zsh
# -------------------------------
echo "[1/4] Установка Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh уже установлен."
fi

# -------------------------------
# 3. Установка Powerlevel10k
# -------------------------------
echo "[2/4] Установка Powerlevel10k..."
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
else
    echo "Powerlevel10k уже установлен."
fi

# -------------------------------
# 4. Установка плагинов
# -------------------------------
echo "[3/4] Установка плагинов..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# -------------------------------
# 5. Создание .zshrc
# -------------------------------
echo "[4/4] Создание ~/.zshrc..."

cat > ~/.zshrc <<'EOF'
# -----------------------------
# SSH AGENT (должен быть выше instant prompt)
# -----------------------------
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)" > /dev/null
fi

ssh-add ~/.ssh/id_ed25519 2>/dev/null

# -----------------------------
# POWERLEVEL10K INSTANT PROMPT
# -----------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -----------------------------
# OH MY ZSH
# -----------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# -----------------------------
# PLUGINS
# -----------------------------
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# -----------------------------
# USER SETTINGS
# -----------------------------
export EDITOR="nvim"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# -----------------------------
# ALIASES
# -----------------------------
alias ll="ls -lah"
alias gs="git status"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# -----------------------------
# POWERLEVEL10K CONFIG
# -----------------------------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo "===== Установка завершена! ====="
echo "Для активации zsh выполните: chsh -s $(which zsh) и откройте новый терминал."
echo "Понадобится перезайти в сессию"
echo "Если появится окно настройки Powerlevel10k, следуйте инструкциям."
