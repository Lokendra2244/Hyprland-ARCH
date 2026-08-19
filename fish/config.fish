if status is-interactive
    # Commands to run in interactive sessions can go here
    #blaze integration
    blaze fish --init | source
    fastfetch
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
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
# If the agent is running but has no keys, add them
if not ssh-add -l >/dev/null 2>&1
    ssh-add ~/.ssh/id_ed25519
end
direnv hook fish | source

# Ensure standard XDG_DATA_DIRS exists
set -q XDG_DATA_DIRS; or set -gx XDG_DATA_DIRS /usr/local/share:/usr/share
set -gx --path XDG_DATA_DIRS $XDG_DATA_DIRS

# Add Flatpak exports unconditionally to XDG_DATA_DIRS
for dir in /var/lib/flatpak/exports/share $HOME/.local/share/flatpak/exports/share
    if not contains $dir $XDG_DATA_DIRS
        set -ga XDG_DATA_DIRS $dir
    end
end
