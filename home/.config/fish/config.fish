starship init fish | source

source ~/.bash_aliases

# load ~/.fishrc.local if it exists ()
test -e ~/.fishrc.local; and source ~/.fishrc.local

# override bash reload alias for fish
alias reload "source ~/.config/fish/config.fish"

# disable welcome greeting when shell starts
set -U fish_greeting

function fish_right_prompt -d "Show Private label on right side when applicable"
    if not test -z $fish_private_mode
        set_color -b purple
        echo ' PRIVATE '
        set_color normal
    end
end

# use fd to search only in mounted Volumes
function fdm
    fd -E "/Volumes/Macintosh HD" $argv[1] /Volumes --exec-batch exa -al --color=always --icons --no-permissions --no-user --time-style=long-iso
end
