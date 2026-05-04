# Dotfiles

This repository is migrating from a custom Rake/Ruby installer to chezmoi.

## Current Migration Path

Chezmoi now manages plain dotfiles, Git configuration, and static app assets from the `home/` source state. Inspect and apply those files with:

```sh
chezmoi --source . --destination "$HOME" init --promptDefaults
chezmoi --source . --destination "$HOME" diff --no-pager
chezmoi --source . --destination "$HOME" apply --dry-run --verbose
chezmoi --source . --destination "$HOME" apply --verbose
```

The repository root is the git working tree. The chezmoi source state lives in `home/`, selected by `.chezmoiroot`.

The legacy installer is still used for setup scripts that have not moved to chezmoi yet:

```sh
./run.sh
```

During the migration, `./run.sh` no longer symlinks plain dotfiles, prompt themes, or Micro settings into `$HOME`, and no longer writes Git configuration. Chezmoi owns those targets. The legacy installer still runs the remaining numbered setup scripts.

Git identity is stored in the local chezmoi config generated from `home/.chezmoi.toml.tmpl`. Re-run `chezmoi --source . --destination "$HOME" init --prompt` if those local values need to change.

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
