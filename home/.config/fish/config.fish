
# ----------------------------------------------------
# completions
starship init fish | source

set -U fish_greeting # disable welcome greeting when shell starts

function fish_right_prompt -d "Show Private label on right side when applicable"
    if not test -z $fish_private_mode
        set_color -b purple
        echo ' PRIVATE '
        set_color normal
    end
end

fnm env --use-on-cd | source


# ----------------------------------------------------
# imports

source ~/.bash_aliases
test -e ~/.fishrc.local; and source ~/.fishrc.local


# ----------------------------------------------------
# path

fish_add_path (yarn global bin)
fish_add_path /usr/local/bin


# ----------------------------------------------------
# alias and functions

# override bash reload alias for fish
alias reload "source ~/.config/fish/config.fish"

# use fd to search only in mounted Volumes
function fdm
    fd -E "/Volumes/Macintosh HD" $argv[1] /Volumes --exec-batch eza -al --color=always --icons --no-permissions --no-user --time-style=long-iso
end
