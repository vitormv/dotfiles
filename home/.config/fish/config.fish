starship init fish | source

source ~/.bash_aliases

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
