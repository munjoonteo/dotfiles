# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Themes
source ~/.zsh/themes/powerlevel10k/powerlevel10k.zsh-theme

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
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias soz='source ~/.zshrc'
alias sshc='nvim ~/.ssh/config'

alias k="kubectl"
alias kx="kubectx"
alias kns="kubens"

alias pn="pnpm"
alias y="yarn"

alias c="cd ~/Code"

alias gityeet='git a . && git comamend && git psf'

# Helper functions
mkcd()
{
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}

# Setup brew (M1 Mac)
eval $(/opt/homebrew/bin/brew shellenv)

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

########## fzf ###########

source <(fzf --zsh) # This sets up fzf key bindings and fuzzy completion

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

######### zoxide #########

eval "$(zoxide init zsh)"
alias cd="z"

######### thefuck ########

eval $(thefuck --alias fk)
alias fkyeah="thefuck --yeah"

########## node ##########

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ $commands[kubectl] ]] && source <(kubectl completion zsh) # This enables shell command completion for kubectl

# pnpm
export PNPM_HOME="/Users/munjoonteo/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

##########################

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/munjoonteo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/munjoonteo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/munjoonteo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/munjoonteo/google-cloud-sdk/completion.zsh.inc'; fi

