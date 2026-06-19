# Luke's config for the Zoomer Shell

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
#PS1="%B%{$fg[cyan]%}[%{$fg[magenta]%}%~%{$fg[cyan]%}]%{$reset_color%}$%b "
PS1="%B%{$fg[cyan]%}[%{$fg[green]%}%m%{$fg[cyan]%}:%{$fg[magenta]%}%~%{$fg[cyan]%}]%{$reset_color%}$%b "

#PS1="%{$fg[red]%}[%{$fg[yellow]%}a%{$fg[red]%}]%{$reset_color%}$ "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -i
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' '^ulfcd\n'

bindkey -s '^a' '^ubc -lq\n'

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

# prevent weird error of enter becoming ^M in zsh
ttyctl -f

# cd history (type cd -[TAB] to see history)
setopt AUTO_PUSHD                  # pushes the old directory onto the stack
setopt PUSHD_MINUS                 # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                 # expand the expression (allows 'cd -2/tmp')
autoload -U compinit && compinit   # load + start completion
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

# Load syntax highlighting; should be last.
source "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 2>/dev/null

# fix folder name highlighting thing
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# homebrew
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -x "$HOME/.linuxbrew/bin/brew" ] && eval "$($HOME/.linuxbrew/bin/brew shellenv)"

# torch container related stuff
export TORCH_CONTAINER_TOOL="/scratch/js10454/verl_grpo/workspace/entropy-code/scripts/torch_container_shell.sh"

tc() {
    "$TORCH_CONTAINER_TOOL" "$@"
}

tcpu() {
    "$TORCH_CONTAINER_TOOL" --cpu "$@"
}

tl40s() {
    "$TORCH_CONTAINER_TOOL" --gpu l40s "$@"
}

th200() {
    "$TORCH_CONTAINER_TOOL" --gpu h200 "$@"
}

tcrw() {
    "$TORCH_CONTAINER_TOOL" --cpu --rw "$@"
}

# Quick CPU checks: imports, config inspection, small scripts
tcpuq() {
  tcpu \
    --cpus 2 \
    --mem 8GB \
    --time 00:30:00 \
    "$@"
}

# Normal CPU debugging inside the container
tcpud() {
  tcpu \
    --cpus 4 \
    --mem 32GB \
    --time 02:00:00 \
    "$@"
}

# High-memory CPU work: setup, preprocessing, package inspection
tcpuh() {
  tcpu \
    --cpus 8 \
    --mem 64GB \
    --time 04:00:00 \
    "$@"
}

# Writable-overlay setup/install session
tsetup() {
  tcpu \
    --rw \
    --cpus 8 \
    --mem 64GB \
    --time 04:00:00 \
    "$@"
}

# Quick L40S check: CUDA, imports, nvidia-smi
tl40sq() {
  tl40s \
    --gpus 1 \
    --cpus 4 \
    --mem 32GB \
    --time 00:30:00 \
    "$@"
}

# L40S model-loading / vLLM / inference debugging
tl40sv() {
  tl40s \
    --gpus 1 \
    --cpus 8 \
    --mem 80GB \
    --time 01:00:00 \
    "$@"
}

# L40S GRPO/Ray troubleshooting
tl40sg() {
  tl40s \
    --gpus 1 \
    --cpus 16 \
    --mem 120GB \
    --time 02:00:00 \
    "$@"
}

# Two-L40S distributed debugging
tl40s2g() {
  tl40s \
    --gpus 2 \
    --cpus 16 \
    --mem 160GB \
    --time 02:00:00 \
    "$@"
}
