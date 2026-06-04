# .bash_profile

# Get the aliases and functions
[ -f ~/.bashrc ] && . ~/.bashrc

export PATH="$HOME/.local/bin:$PATH"
case $- in *i*) ;; *) return ;; esac          # interactive only
command -v zsh >/dev/null && [ -z "$ZSH_VERSION" ] && exec zsh -l

# User specific environment and startup programs
