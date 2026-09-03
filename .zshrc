# Powerlevel10k instant prompt — keeps shell startup fast by caching the prompt.
# Must be at the very top of .zshrc, before anything that prints output.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
plugins=(
  git
  command-not-found
  fzf
  autojump
  sudo
  zsh-autosuggestions
)

[[ -f "$HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]] && \
  source "$HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

source $ZSH/oh-my-zsh.sh

# Modern CLI replacements — guarded so missing tools don't break the shell
command -v eza   &>/dev/null && alias ls='eza --icons' \
                             && alias ll='eza --icons -la --git' \
                             && alias lt='eza --icons --tree --level=2'
command -v bat   &>/dev/null && alias cat='bat --paging=never'
command -v rg    &>/dev/null && alias grep='rg'
command -v fd    &>/dev/null && alias find='fd'

export EDITOR="nvim"

# Includes GitHub PAT needed in codespaces for writing into the bluebox-kb
[ -f ~/.config/personal-secrets ] && source ~/.config/personal-secrets

# Powerlevel10k config. Run `p10k configure` at any time to re-run the wizard.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
