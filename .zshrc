# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Aliases
alias c="cd ~/Code"
alias gityeet='git a . && git comamend && git psf'
alias soz='source ~/.zshrc'
alias ta='tmux a'

alias p='git diff --name-only --diff-filter=ACM HEAD | xargs -r prettier --write'
alias ph='git show HEAD --name-only | sed '1d' | xargs -r prettier --write'

# Helper functions
mkcd()
{
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}

# Setup brew (M1 Mac)
eval $(/opt/homebrew/bin/brew shellenv)

######### theme ##########

source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

######### addons #########
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

########## fzf ###########

source <(fzf --zsh) # This sets up fzf key bindings and fuzzy completion

# Commands
# Ctrl+t - show files
# Ctrl+r - show command history
#
# ** + tab - open fuzzy finder menu (result depends on previous command)
# navigate options with up/down arrows and select multiple options with tab

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/fzf-git.sh/fzf-git.sh
bindkey '^G' fzf-git-widget

# Commands
# Ctrl-gf - files
# Ctrl-gb - branches
# Ctrl-gt - tags
# Ctrl-gr - remotes
# Ctrl-gh - hashes
# Ctrl-gs - stashes
# Ctrl-gl - reflogs

######### thefuck ########

eval $(thefuck --alias fk)
alias fkyeah="thefuck --yeah"

########## node ##########

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

######### kubectl ########

[[ $commands[kubectl] ]] && source <(kubectl completion zsh) # This enables shell command completion for kubectl
alias k="kubectl"
alias kx="kubectx"
alias kns="kubens"

######### zoxide #########

eval "$(zoxide init zsh)"
alias cd="z"
