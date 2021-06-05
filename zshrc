# If you come from bash you might have to change your $PATH.
export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.cabal/bin"

export PATH="$PATH:$HOME/.config/sway/scripts"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# CMake use all cores
CMAKE_BUILD_PARALLEL_LEVEL=4
export GTEST_COLOR=1

# https://github.com/caiogondim/bullet-train.zsh
# BULLETTRAIN_STATUS_EXIT_SHOW=true
# BULLETTRAIN_CONTEXT_DEFAULT_USER="korbinian"
# BULLETTRAIN_IS_SSH_CLIENT=true
# BULLETTRAIN_GIT_COLORIZE_DIRTY=true
# BULLETTRAIN_GIT_BG=30 #147
# BULLETTRAIN_TIME_BG=238 #67 #31 #22
# BULLETTRAIN_TIME_FG=252
# BULLETTRAIN_GIT_DIRTY=""
# BULLETTRAIN_GIT_UNTRACKED="%F{black} ●%F{black}"
# BULLETTRAIN_GIT_MODIFIED="%F{blue} 🟆%F{black}"
# BULLETTRAIN_DIR_EXTENDED=2
# BULLETTRAIN_PROMPT_CHAR="%F{green}🠶%F{black}"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="bullet-train"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
        git
        colored-man-pages
)

source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG="en_US.UTF-8"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# aliases
alias ll="exa -l --git"
alias l="exa -lag --git"

# Nodejs version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# use neovim
alias vim="nvim"
alias vi="nvim"
alias batp="bat --plain"

# sccache
export RUSTC_WRAPPER=sccache
# color picker with grim
alias colorpick='grim -g "$(slurp -p)" -t ppm - | convert - -format "%[pixel:p{0,0}]" txt:-'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# starship prompt
eval "$(starship init zsh)"

# ghcup & Haskell
[ -f "/home/korbinian/.ghcup/env" ] && source "/home/korbinian/.ghcup/env" # ghcup-env
