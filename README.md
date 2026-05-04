# Dotfiles

This repository is migrating from a custom Rake/Ruby installer to chezmoi.

## Current Migration Path

Chezmoi now manages plain dotfiles from the `home/` source state. Inspect and apply those files with:

```sh
chezmoi --source . --destination "$HOME" diff --no-pager
chezmoi --source . --destination "$HOME" apply --dry-run --verbose
chezmoi --source . --destination "$HOME" apply --verbose
```

The repository root is the git working tree. The chezmoi source state lives in `home/`, selected by `.chezmoiroot`.

The legacy installer is still used for setup scripts that have not moved to chezmoi yet:

```sh
./run.sh
```

During the migration, `./run.sh` no longer symlinks plain dotfiles into `$HOME`; chezmoi owns those targets. It still runs the existing numbered setup scripts.

## Chezmoi Inspection

Use these commands to inspect the current chezmoi state:

```sh
chezmoi --source . doctor
chezmoi --source . --destination "$HOME" status --no-pager
chezmoi --source . --destination "$HOME" diff --no-pager
```

These commands should not propose applying repository implementation files such as `Rakefile`, `run.sh`, setup directories, or migration specs into `$HOME`.

## Migration Notes

The migration plan is tracked in `migrate-to-chezmoi.md`.

For now, do not use `chezmoi init --apply` as the only fresh-machine install path. That becomes appropriate after later phases convert setup scripts into chezmoi.
