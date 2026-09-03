# codespace-dotfiles

GitHub Codespaces dotfiles for Alejandro. Lightweight shell environment — no Zellij, no heavy language runtimes — focused on making every Codespace feel like home from the first terminal open.

## What this repo does

When GitHub Codespaces starts a new Codespace, it automatically:

1. Clones this repo to `~/codespace-dotfiles`
2. Runs `install.sh`

`install.sh` installs:

- zsh + oh-my-zsh + Powerlevel10k + zsh-autosuggestions + zsh-autocomplete
- CLI tools: ripgrep, bat, fd, eza, delta, lazygit, fzf, autojump
- atuin (cross-codespace shell history sync)
- Clones `AlejandroCamba/dotfiles` to `~/dotfiles` (for Claude config)
- Symlinks Claude config from `~/dotfiles`: agents, skills, hooks, commands, CLAUDE.md, settings.json
- Symlinks shell config from this repo: `.zshrc`, `.p10k.zsh`, `.gitconfig`

Project-level runtimes (Node, Python, Go, etc.) are handled by devcontainers, not this repo.

## Prerequisites

- This repo must be **public**, or you must have Codespaces access to a private dotfiles repo configured in your GitHub settings.
- GitHub account with Codespaces enabled.

## Configure GitHub to use this repo

1. Go to [github.com/settings/codespaces](https://github.com/settings/codespaces)
2. Under **Dotfiles**, check "Automatically install dotfiles"
3. Select `AlejandroCamba/codespace-dotfiles` as the dotfiles repository
4. Save

Every new Codespace you create will now run `install.sh` automatically.

## Claude config pull from dotfiles

`install.sh` clones `https://github.com/AlejandroCamba/dotfiles` into `~/dotfiles`, then symlinks:

| Symlink | Source |
|---|---|
| `~/.claude/agents` | `~/dotfiles/claude/agents` |
| `~/.claude/skills` | `~/dotfiles/claude/skills` |
| `~/.claude/hooks` | `~/dotfiles/claude/hooks` |
| `~/.claude/commands` | `~/dotfiles/claude/commands` |
| `~/.claude/CLAUDE.md` | `~/dotfiles/claude/CLAUDE.md` |
| `~/.claude/settings.json` | `~/dotfiles/claude/settings.json` |

This keeps Claude Code's skills, hooks, and settings identical between your local machine and every Codespace. When you update `dotfiles`, the change is live in every Codespace that has `~/dotfiles` cloned.

## Atuin history sync

[Atuin](https://atuin.sh) replaces your shell history with a SQLite database, optionally synced to Atuin's cloud (or a self-hosted server). Every Codespace picks up your full history.

**One-time setup (do this once on any machine):**

```bash
atuin register -u <username> -e <email> -p <password>
```

**On each subsequent Codespace (or machine), log in:**

```bash
atuin login -u <username> -p <password>
atuin sync
```

The `.zshrc` in this repo initialises atuin on shell start:

```zsh
[[ -f ~/.atuin/bin/atuin ]] && eval "$(~/.atuin/bin/atuin init zsh)"
```

## BLUEBOX_KB_PAT

The `.zshrc` sources `~/.config/personal-secrets` if it exists. This is where `BLUEBOX_KB_PAT` lives on the local machine. In Codespaces, set it as a **Codespace secret** instead:

1. Go to [github.com/settings/codespaces](https://github.com/settings/codespaces)
2. Under **Secrets**, add `BLUEBOX_KB_PAT` with your GitHub PAT value
3. Grant access to the repositories that need it (e.g. `AlejandroCamba/bluebox`)

GitHub injects Codespace secrets as environment variables before `install.sh` runs, so they are available in every terminal session.

## First-time setup checklist

After creating this repo on GitHub and configuring it as your dotfiles source:

- [ ] Create the GitHub repo `AlejandroCamba/codespace-dotfiles` and push this directory
- [ ] Go to Settings → Codespaces → Dotfiles and point to this repo
- [ ] Register atuin: `atuin register -u <username> -e <email> -p <password>`
- [ ] Set `BLUEBOX_KB_PAT` as a Codespace secret
- [ ] Open a new Codespace to verify everything works

## Directory structure

```
codespace-dotfiles/
├── install.sh      # Bootstrap script (GitHub runs this automatically)
├── .zshrc          # Codespace-specific zsh config
├── .p10k.zsh       # Powerlevel10k prompt config
├── .gitconfig      # Git config (delta pager, rebase settings, etc.)
└── README.md       # This file
```
