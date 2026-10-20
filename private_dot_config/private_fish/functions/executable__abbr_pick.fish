function _abbr_pick --description 'Fuzzy-pick an abbreviation and insert its name at the cursor'
    set -l picked (abbrs | fzf --prompt='abbr> ' --height=60% --reverse --query=(commandline -t))
    if test -n "$picked"
        commandline -t -- (string split -m1 ' ' -- $picked)[1]
    end
    commandline -f repaint
end
