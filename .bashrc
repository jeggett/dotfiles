alias pn='pnpm'
alias ci='code-insiders'
alias py='python'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
alias docs-stage-bucket='rclone mount s3-connect:pole-stage-documents I: --vfs-cache-mode full'
alias docs-rc-bucket='rclone mount s3-connect:pole-rc-documents J: --vfs-cache-mode full'

export PATH="$HOME/prj/pole/bash_tools:$PATH"

# turn off cursor blinking
printf '\033[?12l'
