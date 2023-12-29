# ----------------------------------------------------
# General

alias projects="cd ~/projects"
alias dotfiles="cd ~/dotfiles"
alias top="btm"
alias nvm="fnm"
alias iplocal="ipconfig getifaddr en0"
alias ippublic='echo $(curl -sS -4 ifconfig.me)'

# ----------------------------------------------------
# shell

alias ls='exa -l --color=always --group-directories-first --icons'                       # long format
alias ll='exa -al --color=always --group-directories-first --icons'                      # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'                       # all files and dirs
alias lt='exa -aT --ignore-glob=".git" --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'"                                                          # show only dotfiles

# like the original "/usr/bin/clear", but it actually removes things instead of just scrolling
alias clear='printf "\033c"'
alias cls='clear'

alias incognito="fish --private"

# ----------------------------------------------------
# shell config

alias bashrc='vim ~/.bashrc'
alias zshrc="vim ~/.zshrc"
alias reload="source ~/.bashrc && echo 'Sourced ~/.bashrc'"

alias grep='rg --color=auto'

# ----------------------------------------------------
# Torrentbox

alias torrentbox="ssh torrentbox '(bash ~/torrentbox/torrentbox.sh status)'"

# ----------------------------------------------------
# Docker

alias do.ls='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}"'
alias doco="docker compose"

# ----------------------------------------------------
# MacOS

# remove all .DS_Store files recursively
alias purge.ds='find . -type f \( -name ".DS_Store" -o -name "._.DS_Store" \) -delete -print 2>&1 | grep -v "Permission denied"'

# reload native apps
alias kill.finder="killall Finder"
alias kill.dock="killall Dock"
alias kill.code="osascript -e 'quit app \"Visual Studio Code\"'"

# flush dns
alias flushdns="dscacheutil -flushcache && killall -HUP mDNSResponder"

# start screen saver
alias afk="open /System/Library/CoreServices/ScreenSaverEngine.app"