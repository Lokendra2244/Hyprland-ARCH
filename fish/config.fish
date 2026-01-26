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
