# Dotfiles

Personal dotfiles managed by [chezmoi](https://www.chezmoi.io/).

The repository root is the git working tree. The chezmoi source state lives in
`home/`, selected by `.chezmoiroot`.

## Fresh Machine Bootstrap

This is a private repository, so authenticate with GitHub before bootstrapping.
The primary path assumes SSH access to GitHub is already configured:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:staugaard/dotfiles.git
```

If chezmoi is already installed:

```sh
chezmoi init --apply git@github.com:staugaard/dotfiles.git
```

HTTPS also works, but only after Git has credentials that can clone the private
repo, for example after `gh auth setup-git`:

```sh
chezmoi init --apply https://github.com/staugaard/dotfiles.git
```

The first run creates local chezmoi config from `home/.chezmoi.toml.tmpl`.
Review the prompts for Git name, Git email, and GitHub username instead of
blindly accepting defaults on a new machine.

## Inspect Before Applying

To inspect the repo before changing the home directory:

```sh
chezmoi init git@github.com:staugaard/dotfiles.git
chezmoi diff --no-pager
chezmoi apply --dry-run --verbose
chezmoi apply --verbose
```

For this already-cloned repository, use the explicit source and destination:

```sh
chezmoi --source . --destination "$HOME" doctor
chezmoi --source . --destination "$HOME" diff --no-pager
chezmoi --source . --destination "$HOME" apply --dry-run --verbose
chezmoi --source . --destination "$HOME" apply --verbose
```

## Daily Workflow

Open the source repository:

```sh
chezmoi cd
```

Edit managed files under `home/`, then inspect and apply:

```sh
chezmoi diff --no-pager
chezmoi apply --verbose
chezmoi status --no-pager
```

Commit and push changes from the source repository with normal git commands.

To add a new home file to chezmoi:

```sh
chezmoi add ~/.example
chezmoi cd
git status
```

Because this repo uses `.chezmoiroot`, source files live under `home/` even
though the git working tree is the repository root.

## Local Configuration

Machine-local values are stored in chezmoi's local config, generated from
`home/.chezmoi.toml.tmpl`.

The current local data is:

- `git.name`
- `git.email`
- `git.githubUser`

To review prompts again:

```sh
chezmoi init --prompt
```

To edit the generated local config directly:

```sh
chezmoi edit-config
```

After changing local config, inspect the rendered output before applying:

```sh
chezmoi diff --no-pager
chezmoi apply --dry-run --verbose
chezmoi apply --verbose
```

## Managed Ownership

Chezmoi owns:

- plain dotfiles such as `.zshrc`, `.nvmrc`, `.gitconfig`, and `.gitignore`
- static app assets such as the oh-my-posh theme and Micro settings
- package and tool bootstrap scripts
- macOS defaults
- Linux user font installation
- GNOME Terminal and macOS Terminal profile imports

Package and setup behavior is declared in `home/.chezmoidata/packages.yaml` and
implemented by sparse scripts in `home/.chezmoiscripts/`.

macOS uses Homebrew. Linux support is apt-based only.

## Updating Packages And Scripts

Package and tool changes should start in `home/.chezmoidata/packages.yaml`.
Scripts in `home/.chezmoiscripts/` should stay sparse, idempotent, and scoped to
work that cannot be represented as managed files.

Before applying script changes, render and syntax-check them:

```sh
tmpdir="$(mktemp -d)"
for script in home/.chezmoiscripts/*.tmpl; do
  rendered="$tmpdir/$(basename "${script%.tmpl}")"
  chezmoi --source . --destination "$HOME" execute-template --file "$script" > "$rendered"
  [[ ! -s "$rendered" ]] || bash -n "$rendered"
done
rm -rf "$tmpdir"
```

Then inspect and apply normally:

```sh
chezmoi --source . --destination "$HOME" diff --no-pager
chezmoi --source . --destination "$HOME" apply --dry-run --verbose
chezmoi --source . --destination "$HOME" apply --verbose
```

Only clear chezmoi script state when intentionally forcing scripts to rerun:

```sh
chezmoi state delete-bucket --bucket=entryState
chezmoi state delete-bucket --bucket=scriptState
```

## Supported Path

Chezmoi is the only supported install and apply path for this repository. The
old Ruby/Rake bootstrapper has been removed.
