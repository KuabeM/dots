# path
set PATH $PATH $HOME/.cargo/bin $HOME/.local/bin $XDG_CONFIG_HOME/sway/scripts $HOME/.local/share/fnm $HOME/repos/robotx/utils/scripts /opt/gcc-arm-none-eabi-9/bin

# prompt
starship init fish | source

zoxide init fish | source
fzf --fish | source
fnm env --use-on-cd --shell fish | source

# alias
alias ll "eza -l --git"
alias l "eza -lag --git"
alias vim "nvim"
alias cat "bat --plain"
alias colorpick 'grim -g "$(slurp -p)" -t ppm - | convert - -format "%[pixel:p{0,0}]" txt:-'
alias tree 'erd --suppress-size --layout inverted --sort name'

abbr g 'git'

abbr ga 'git add'
alias gaa 'git add --all'
abbr gapa 'git add --patch'

abbr gb 'git branch'
abbr gbd 'git branch -d'
abbr gbD 'git branch -D'
abbr gbl 'git blame -b -w'
abbr gbnm 'git branch --no-merged'
abbr gbr 'git branch --remote'

abbr gc 'git commit -v'
abbr gcb 'git checkout -b'
abbr gco 'git checkout'
abbr gcf 'git config --list'

abbr gf 'git fetch'
abbr gl 'git pull'
abbr gp 'git push'
abbr grs 'git restore'
abbr gst 'git status'
abbr gr 'git remote --verbose'
abbr grt 'cd "$(git rev-parse --show-toplevel || echo .)"'

function _git_default_branch -d "Use init.defaultBranch if it's set and exists, otherwise use main if it exists. Falls back to master"
  command git rev-parse --git-dir &>/dev/null; or return
  if set -l default_branch (command git config --get init.defaultBranch)
    and command git show-ref -q --verify refs/heads/{$default_branch}
    echo $default_branch
  else if command git show-ref -q --verify refs/heads/main
    echo main
  else
    echo master
  end
end

function _git_develop_branch -d "Check for develop and similarly named branches"
  command git rev-parse --git-dir &>/dev/null || return
  for branch in dev devel development
    if command git show-ref -q --verify refs/heads/$branch
      echo $branch
      return
    end
  end
  echo develop
end

function _git_current_branch -d "Output git's current branch name"
  begin
    git symbolic-ref HEAD; or \
    git rev-parse --short HEAD; or return
  end 2>/dev/null | sed -e 's|^refs/heads/||'
end

function gwip -d "git commit a work-in-progress branch"
  git add -A; git rm (git ls-files --deleted) 2> /dev/null; git commit -m "--wip--" --no-verify
end
function gunwip -d "git uncommit the work-in-progress branch"
  git log -n 1 | grep -q -c "\--wip--"; and git reset HEAD~1
end

function dis -d "run and disown process"
    $argv[1] $argv[2] &; disown
end

function opend -d "open a file with xdg-open and disown process"
    dis xdg-open $argv[1]
end

alias gcm "git checkout (_git_default_branch)"
alias gcd 'git checkout (_git_develop_branch)'
alias gpsup 'git push --set-upstream origin (_git_current_branch)'

alias glg 'git log --stat'
alias glgp 'git log --stat -p'
alias glo "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'  --date short"
alias glos "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
alias gloa "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
alias gcob "git branch | fzf --preview 'git show --color always {-1}' --bind 'enter:become(git checkout {-1})'"

alias cat="bat --plain"
alias ...="cd ../../"
alias ....="cd ../../../"

bind \e\[3\;3~ kill-word

set -x CMAKE_BUILD_PARALLEL_LEVEL 8
set -x MAKEFLAGS '-j 8'
set -x PAGER 'less -R'
set -x EDITOR 'vim'

set -x CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER /opt/aarch64-brainlab-linux-gnu-13.2-kernel5.4/bin/aarch64-brainlab-linux-gnu-gcc
set -x CC_aarch64_unknown_linux_gnu /opt/aarch64-brainlab-linux-gnu-13.2-kernel5.4/bin/aarch64-brainlab-linux-gnu-gcc

set -x RUSTC_WRAPPER sccache

