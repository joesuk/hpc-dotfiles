# .bashrc
#

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
case $- in *i*) ;; *) return ;; esac                       # interactive only
command -v module >/dev/null && module load zsh/5.9 2>/dev/null
command -v zsh >/dev/null && [ -z "$ZSH_VERSION" ] && exec zsh -l

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi


unset rc
export PATH="$HOME/.local/nvim-linux-x86_64/bin:$PATH"
