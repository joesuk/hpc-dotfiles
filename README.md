# HPC dotfiles

These are dotfiles for use with a headless, rootless, shared-filesystem slurm-based HPC cluster over ssh. I originally designed it to port over as much of my [local dotfiles](https://github.com/joesuk/dotfiles) to cluster computing. In particular, I use a personal fork of the [suckless `st` terminal](https://github.com/joesuk/st), but this is not required. The only terminal-specific feature is OSC 52 clipboard forwarding from nvim/tmux back to my local machine (see below).

## programs/features

* zsh shell
* nvim text editor
* personal tmux config for SLURM clusters, plus the cross-machine clipboard wiring.
* custom bash scripts and shell aliases and shortcuts for QOL.

## Assumptions (for a "similar infra" cluster)

- SLURM with `srun`/`module` (Lmod or environment-modules).
- No root: everything installs into `$HOME`, which is on a shared filesystem all nodes mount.
- Login nodes and compute nodes may run different OS images, so anything in a node-local path (e.g. `/usr/bin`) is not guaranteed to exist on compute nodes. Only `$HOME` and the module software tree are reliably shared.

## One-time setup on your LOCAL machine

These are prerequisites for the clipboard to work end to end. They are NOT done on the cluster.

1. **Enable OSC 52 in `st`.** `st` ships with `allowwindowops = 0`, which silently drops OSC 52 clipboard writes. In your st source (`~/.local/src/st`), set `int allowwindowops = 1;` in `config.h`, then `sudo make clean install` and open a fresh st window. Without this, yanking from nvim on the cluster will never reach your local clipboard.

2. **Install the st terminfo on the cluster** so keys and colors behave and tmux can advertise OSC 52. From your local machine:
   ```bash
   infocmp st-256color | ssh <cluster> tic -x -
   ```
   Alternatively export `TERM=xterm-256color` for cluster sessions, but then match that name in the tmux config (see below).

## Deploy on the cluster

1. **Clone into `$HOME`.** This repo's worktree is your home directory; the `.gitignore` is a whitelist (ignore everything, re-include only tracked dotfiles), so it will not touch anything it doesn't own.

2. **Create the runtime directories** the configs expect (they are gitignored, so they don't come with the clone):
   ```bash
   mkdir -p ~/.cache/zsh ~/.config/zsh ~/.config/shell ~/.local/bin ~/dox/vim_temp
   ```
   `~/dox/vim_temp` is required: nvim writes backups/swap there and errors on every save if it's missing.

3. **Get zsh onto a shared path.** The system `/usr/bin/zsh` may exist on the login node but not on compute nodes, so don't rely on it. Prefer a module:
   ```bash
   module spider zsh        # find the exact name/version
   module load zsh/5.9      # adjust version to what the cluster has
   ```
   The module load is already wired into `.bashrc`, so once you know the name it's automatic. If there's no module, install into `$HOME` with conda: `conda install -c conda-forge zsh`.

4. **Get nvim onto a shared path** (needs to be 0.10+ for the OSC 52 clipboard provider):
   ```bash
   module spider neovim                       # use a module if one exists
   # otherwise, static build into $HOME:
   curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
   tar -C ~/.local -xzf nvim-linux-x86_64.tar.gz
   ln -sf "$HOME/.local/nvim-linux-x86_64/bin/nvim" ~/.local/bin/vim
   ```
   On an old-glibc cluster (CentOS/RHEL 7 era), use the `neovim/neovim-releases` repo instead, which builds against older glibc.

5. **Install plugins** (needs outbound network; do this on the login node, set `http(s)_proxy` if the cluster requires it):
   ```bash
   # zsh syntax highlighting
   git clone https://github.com/zdharma-continuum/fast-syntax-highlighting \
     ~/.config/zsh/plugins/fast-syntax-highlighting
   # nvim plugins: launch nvim once; vim-plug bootstraps and runs :PlugInstall automatically
   nvim
   ```

6. **Activate.** Nothing to source. Just open a fresh login shell (re-ssh, or `exec bash -l`) and the chain below fires on its own.

## How activation works (no manual sourcing)

The flow is fully automatic. You never run `source ~/.zshenv`.

```
ssh login            -> bash login shell -> ~/.bash_profile
~/.bash_profile      -> sources ~/.bashrc
~/.bashrc            -> sets PATH, `module load zsh`, then `exec zsh -l`
zsh startup          -> reads ~/.zshenv (always, first), then $ZDOTDIR/.zshrc
~/.config/zsh/.zshrc -> sources ~/.config/shell/aliasrc
```

Key points:

- `~/.zshenv` is read by zsh automatically on every start. It sets `ZDOTDIR`, the XDG vars, `EDITOR`, and `PATH`. It is the one file you must never need to source by hand.
- The bash-to-zsh handoff lives in `~/.bashrc` (not just `~/.bash_profile`) so it also fires for non-login interactive shells, which is what `srun --pty /bin/bash` gives you. `~/.bash_profile` just sources `~/.bashrc`.
- The module load and `exec zsh` are guarded so they only run in interactive shells and don't break `scp`/`rsync`.
- The only manual `source` is during iterative edits: `source ~/.config/shell/aliasrc` or `exec zsh` to reload without re-logging in.

## Interactive jobs

For example, one may run the `srunc` alias (defined in `aliasrc`):

```sh
alias srunc='srun --pty -c 2 --mem=5GB -t 2:00:00 /bin/bash'
```

It launches `/bin/bash`, not zsh directly. `/bin/bash` is the canonical `--pty` target and avoids the pty-attach failures seen when launching a module binary directly. The `.bashrc` handoff then drops you into zsh on the compute node, with the zsh module already on `PATH` because `srun` exports your environment by default. Other aliases and shortcuts can be found in `.config/shell/`.

## Clipboard (yank in nvim -> local clipboard)

Copy-out uses OSC 52 and requires all three layers, top to bottom:

1. **nvim**: `init.vim` sets a `g:clipboard` OSC 52 provider and `clipboard+=unnamedplus`, so every yank emits OSC 52. Paste is routed to the local register so it never blocks on a terminal query.
2. **tmux**: `tmux.conf` has `set -g set-clipboard on` (the default `external` ignores in-pane OSC 52) and `set -as terminal-features ',st-256color:clipboard'` so tmux forwards the sequence outward. Clipboard settings only apply after a full `tmux kill-server`, not a re-source.
3. **st** (local): `allowwindowops = 1`, from the local prerequisites above.

Paste INTO nvim is separate and uses the terminal's own paste (bracketed paste handles indentation); it does not depend on OSC 52.

Quick test, outside tmux and outside nvim:
```bash
printf '\033]52;c;%s\007' "$(printf hello | base64)"
```
If "hello" lands in your local clipboard, the terminal path is good and any remaining issue is config inside tmux or nvim.

## Per-cluster things to adjust

- **zsh module name/version** in `.bashrc` (`module load zsh/5.9`): check `module spider zsh`.
- **TERM name** in `tmux.conf` `terminal-features`: match `echo $TERM` from outside tmux.
- **nvim path** in `.zshenv` `PATH`: matches the static-tarball layout; change if you install nvim elsewhere or via a module.
- **srun resources** in the `srunc` alias: cpus/mem/time and a `--partition`/`--gres=gpu` as the cluster requires.
- **`compinit -i`** in `.zshrc`: keeps zsh from nagging about group-writable directories on shared software trees. Leave it.

## Verify

In a fresh compute-node session:
```bash
echo $ZSH_VERSION          # non-empty: you're in zsh
command -v zsh             # should be the module/shared path, not /usr/bin/zsh
command -v vim             # should resolve to nvim
```
Then yank a line in nvim and paste it into a local app to confirm the clipboard chain.

## useful scripts

can be found under `.local/share`.
