# codespace-dotfiles

GitHub Codespaces dotfiles for Alejandro. Lightweight shell environment — no Zellij, no heavy language runtimes — focused on making every Codespace feel like home from the first terminal open.

## What this repo does

When GitHub Codespaces starts a new Codespace, it automatically:

1. Clones this repo to `~/codespace-dotfiles`
2. Runs `install.sh`

`install.sh` installs:

- zsh + oh-my-zsh + Powerlevel10k + zsh-autosuggestions + zsh-autocomplete
- CLI tools: ripgrep, bat, fd, eza, delta, lazygit, fzf, autojump
- Clones `AlejandroCamba/dotfiles` to `~/dotfiles` (for Claude config)
- Symlinks Claude config from `~/dotfiles`: agents, skills, hooks, commands, CLAUDE.md, settings.json
- Symlinks shell config from this repo: `.zshrc`, `.p10k.zsh`, `.gitconfig`

Project-level runtimes (Node, Python, Go, etc.) are handled by devcontainers, not this repo.

## Prerequisites

- GitHub account with Codespaces enabled.
- `AlejandroCamba/dotfiles` is private — a `DOTFILES_PAT` Codespace secret is required (see below).

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

## DOTFILES_PAT

`AlejandroCamba/dotfiles` is a private repo. `install.sh` needs a token to clone it. Create a fine-grained PAT with **Contents: Read-only** on `AlejandroCamba/dotfiles`, then add it as a Codespace secret:

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens) → Fine-grained tokens → Generate new token
2. Set resource owner to your account, select only `AlejandroCamba/dotfiles`
3. Under **Repository permissions**, set **Contents** to **Read-only**
4. Copy the token
5. Go to [github.com/settings/codespaces](https://github.com/settings/codespaces) → Secrets → New secret
6. Name it `DOTFILES_PAT`, paste the token, and grant access to `AlejandroCamba/bluebox` (or whichever repos you create Codespaces in)

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
- [ ] Create a fine-grained PAT with Contents: Read-only on `AlejandroCamba/dotfiles` and add it as a Codespace secret named `DOTFILES_PAT`
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
