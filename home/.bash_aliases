# -- GENERAL -------------------------------------------------------------------

alias projects="cd ~/projects"
alias dotfiles="cd ~/dotfiles"
alias iplocal="ipconfig getifaddr en0"
alias ippublic='echo $(curl -sS -4 ifconfig.me)'
alias weather="curl https://wttr.in/"
alias dufs="duf /Volumes/*"
alias yarnis="yarn install && yarn start"
alias finder="open -a Finder ."
alias pn="pnpm"

# old habits die hard :)
alias vim="nvim"
alias top="btm"
alias nvm="fnm"
alias grep='rg --color=auto'

# autocorrect
alias kgit="git"
alias gti="git"

# -- SHELL ---------------------------------------------------------------------

alias ls='eza --long --color=always --group-directories-first --icons'                            # long format
alias ll='eza --long --all --color=always --group-directories-first --icons'                      # preferred listing
alias la='eza --all --color=always --group-directories-first --icons'                             # all files and dirs
alias lt='eza --tree --all --ignore-glob=".git" --color=always --group-directories-first --icons' # tree listing
alias l.="eza --all | egrep '^\.'"                                                                # show only dotfiles

# like the original "/usr/bin/clear", but it actually removes things instead of just scrolling
alias clear='printf "\033c"'
alias cls='clear'

# start a new zsh session without history, and give it a custom name
alias incognito="NOHISTFILE=true bash -c 'exec -a zsh_private zsh' && clear"

# -- CONFIGS -------------------------------------------------------------------

alias bashrc='vim ~/.bashrc'
alias zshrc="vim ~/.zshrc"
alias reload="source ~/.bashrc && echo 'Sourced ~/.bashrc'"
alias gitignore="vim ~/.config/git/gitignore"

# -- TORRENTBOX ----------------------------------------------------------------

alias torrentbox="ssh torrentbox '(bash ~/torrentbox/torrentbox.sh status)'"

# -- DOCKER --------------------------------------------------------------------

alias do.ls='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}"'
alias doco="docker compose"

# -- MacOS ---------------------------------------------------------------------

# remove all .DS_Store files recursively
alias purge.ds='find . -type f \( -name ".DS_Store" -o -name "._.DS_Store" \) -delete -print 2>&1 | grep -v "Permission denied"'
alias zipclean="zip -d filename.zip __MACOSX/\*" # remove __MACOSX from zip files

# reload native apps
alias kill.finder="killall Finder"
alias kill.dock="killall Dock"
alias kill.code="osascript -e 'quit app \"Visual Studio Code\"'"

# flush dns
alias flushdns="dscacheutil -flushcache && killall -HUP mDNSResponder"

# start screen saver
alias afk="open /System/Library/CoreServices/ScreenSaverEngine.app"

# adminer
alias adminer="php -S localhost:9999 -c ~/projects/adminer/php.ini -t ~/projects/adminer"
