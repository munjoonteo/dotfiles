# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"

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
alias ls="exa --icons --across --group-directories-first"
alias lsl="exa --long --all --icons --group-directories-first"
alias lst="exa --tree --long --icons --group-directories-first"
alias lsg="exa --git --long --icons --group-directories-first"

alias c="cd ~/Code"
alias ntgl="cd ~/Code/csesoc/notangles"
alias tt="cd ~/Code/csesoc/timetable-scraper"
alias chess="cd ~/Code/chessbot"
alias thesis="cd ~/Code/optosleep-backend"

# Helper functions
mkcd()
{
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}

# Colours (Normal)
# Black - 000000
# Red - A6002E
# Green - A8FF5F
# Yellow - FFF053
# Blue - 00BFBF
# Magenta - B200B2
# Cyan - 8799FF
# White - BFBFBF

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/munjoonteo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/munjoonteo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/munjoonteo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/munjoonteo/google-cloud-sdk/completion.zsh.inc'; fi

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"

