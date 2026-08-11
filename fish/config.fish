if status is-interactive
    # Commands to run in interactive sessions can go here
    #blaze integration
    blaze fish --init | source
end

#welcome greeting
set -g fish_greeting ""

#zoxide integration
zoxide init fish | source

# limit fzf
set -g fzf_preview_file_cmd bat --style=numbers --color=always --line-range :1000

#priortie the fzf key-binds
fzf_configure_bindings --history=\cr --directory=\ct --git_log=\cl --git_status=\cs --processes=\cp --variables=\cv

#make fd see dotfiles
set -g fzf_fd_opts --hidden

# Load Pywal colors if they exist
if test -e ~/.cache/wal/sequences
    cat ~/.cache/wal/sequences
end

function fetch
    # 1. Clear the screen for a clean canvas
    clear

    # 2. Run Fastfetch using the invisible text block to push your system stats to the right
    fastfetch --logo-type file --logo ~/.config/fastfetch/blank.txt

    # 3. Move the terminal cursor back up 19 lines (adjust this number based on your Fastfetch height)
    tput cuu 25

    # 4. Play the animated GIF in the empty space on the left!
    # (-g forces it to fit within a 35x18 character grid so it doesn't overlap text)
    timg -p kitty -g 45x25 ~/.config/fastfetch/ascii/giphy.gif
end

function fz
    # We are using fd, following links (-L), but allowing it to ignore hidden/junk folders to save SSHFS bandwidth.
    set file (env FZF_DEFAULT_COMMAND='fd -e pdf -e epub -e cbz -e djvu --type f -L . "$HOME" "$HOME/mnt"' fzf --prompt="📖 Open in Zathura: ")

    if test -n "$file"
        zathura "$file" >/dev/null 2>&1 &
        disown
    end
end
