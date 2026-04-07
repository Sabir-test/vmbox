# /home/sabir/dev/.bashrc — container shell config (devspace)
case $- in *i*) ;; *) return;; esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
shopt -s histappend checkwinsize

# Cyan [DEV] prefix — instantly shows you're inside the container
PS1='\[\033[0;36m\][DEV devspace]\[\033[0m\] \[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$ '

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias grep='grep --color=auto'

# Force dev SSH key only — never fall back to personal keys
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_dev_ed25519 -F ~/.ssh/config -o IdentitiesOnly=yes"

export PATH=$HOME/.local/bin:$PATH
export DEVSPACE=1
