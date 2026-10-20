function abbrs --description 'List all abbreviations as "name  →  expansion"'
    abbr --show | string replace -r '^abbr -a .*?-- (\S+) (.*)$' '$1  →  $2' | sort
end
