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
if not ssh-add -l > /dev/null 2>&1
    ssh-add ~/.ssh/id_ed25519
end
