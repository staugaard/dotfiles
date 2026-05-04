# Dotfiles

This repository is migrating from a custom Rake/Ruby installer to chezmoi.

## Current Install Path

The legacy installer is still the supported way to apply these dotfiles during the migration:

```sh
./run.sh
```

That script installs the Ruby bootstrap it needs on Linux, runs `rake`, symlinks root dotfiles into `$HOME`, and executes the existing numbered setup scripts.

## Chezmoi Inspection Path

Chezmoi has been introduced as a safe inspection harness, but it does not manage any home-directory files yet.

The repository root is the git working tree. The chezmoi source state lives in `home/`, selected by `.chezmoiroot`.

Use these commands to inspect the current chezmoi state:

```sh
chezmoi --source . doctor
chezmoi --source . --destination "$HOME" status --no-pager
chezmoi --source . --destination "$HOME" diff --no-pager
chezmoi --source . --destination "$HOME" apply --dry-run --verbose
```

These commands should not propose applying repository implementation files such as `Rakefile`, `run.sh`, setup directories, or migration specs into `$HOME`.

## Migration Notes

The migration plan is tracked in `migrate-to-chezmoi.md`.

For now, do not use `chezmoi init --apply` as the primary fresh-machine install path. That becomes appropriate after later phases convert real dotfiles into the `home/` source state.
