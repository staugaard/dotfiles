# Migrate Dotfiles to Chezmoi

## Goal

Move this dotfiles repository from a custom `Rakefile` plus per-directory setup scripts to a chezmoi-managed source tree.

The target state is:

- Dotfiles are rendered and applied by chezmoi.
- Machine-specific values use chezmoi templates and local config data.
- Setup tasks are expressed as chezmoi scripts with clear run semantics.
- The current repository remains usable throughout the migration.
- The old Rake/Ruby bootstrap path is removed only after the chezmoi path is proven.

## Current State

The repository currently has two kinds of configuration:

- Root dotfiles such as `.zshrc` and `.nvmrc`.
- Numbered setup directories such as `00-core`, `10-zsh`, and `20-go`.

`Rakefile` installs root dotfiles by symlinking tracked dotfiles into `$HOME`, then finds and runs executable setup files under the numbered directories.

Some setup work is imperative and host-dependent:

- `10-zsh/setup.rb` installs shell tooling and links the prompt theme.
- OS package setup varies between Homebrew, DNF, and APT.
- macOS and Linux terminal setup are split into platform-specific directories.

This shape maps well to chezmoi, but the migration should avoid turning every setup script into a large template all at once.

## Non-Goals

- Do not redesign the shell environment during the migration.
- Do not replace Homebrew, DNF, APT, Cargo, or language-specific installers with a new provisioning framework.
- Do not introduce Nix, Ansible, or another broader machine management layer.
- Do not preserve retired personal configuration just because it is currently tracked.
- Do not delete the existing Rake/Ruby path until the chezmoi path has been tested on at least the current machine.

## Phase 0: Remove Retired Dotfiles

Before converting files to chezmoi, remove configuration that is no longer used.

Retired files:

- `.my.cnf`
- `.ruby-version`

Rationale:

- MySQL configuration is no longer needed.
- A repository-level Ruby version file is no longer needed.
- The existing installer still uses Ruby internally, but that does not require keeping a Ruby version dotfile in this repository.

Verification:

- Search the repository for references to the retired files.
- Confirm `git status` shows only the intended deletions.

Exit criteria:

- Retired files are deleted rather than migrated into chezmoi.
- Later phases only convert configuration that still matters.

## Phase 1: Introduce Chezmoi Without Changing Behavior

Add chezmoi metadata while keeping the current installer working.

Tasks:

- Add `.chezmoiroot` at the repository root pointing to `home`.
- Add `home/.chezmoiignore` documenting that Phase 1 intentionally manages no home-directory files yet.
- Add a README section showing the temporary install and inspection paths:
  - existing install path: `./run.sh`
  - new inspection path: `chezmoi --source . doctor`, `chezmoi --source . --destination "$HOME" status`, `chezmoi --source . --destination "$HOME" diff`, and `chezmoi --source . --destination "$HOME" apply --dry-run --verbose`
- Record that `chezmoi init --apply` should not become the primary fresh-machine install path until later phases add real managed targets.

Recommended direction:

- Use the repository root as the git working tree.
- Use `home/` as the chezmoi source state via `.chezmoiroot`.
- Convert files into `home/` over time.
- Keep setup directories visible and outside the chezmoi source state until each has a chezmoi-native replacement.

Verification:

- `chezmoi --source . doctor`
- `chezmoi --source . --destination "$HOME" status --no-pager`
- `chezmoi --source . --destination "$HOME" diff --no-pager`
- `chezmoi --source . --destination "$HOME" apply --dry-run --verbose`
- Existing `./run.sh` still works.

Exit criteria:

- Chezmoi can inspect this repository without trying to apply setup implementation files into `$HOME`.
- The old install path remains unchanged.

## Phase 2: Convert Plain Dotfiles

Move root dotfiles into chezmoi naming conventions.

Conversions:

- `.zshrc` -> `home/dot_zshrc`
- `.nvmrc` -> `home/dot_nvmrc`

Tasks:

- Move both plain dotfiles into the `home/` source state.
- Preserve file contents exactly.
- Do not template either file unless there is an actual host-specific difference.
- Do not preserve the historical executable bit on `.zshrc`; manage it as a normal readable config file.
- Update the legacy Rake symlink task to use an explicit allowlist, initially empty, so `./run.sh` cannot overwrite chezmoi-managed dotfiles or link repo metadata into `$HOME`.

Verification:

- `chezmoi --source . --destination "$HOME" diff --no-pager`
- `chezmoi --source . --destination "$HOME" apply --dry-run --verbose`
- `chezmoi --source . --destination "$HOME" apply --verbose`
- Confirm `$HOME/.zshrc` and `$HOME/.nvmrc` are regular files, not symlinks.
- Confirm applied contents match `home/dot_zshrc` and `home/dot_nvmrc`.
- `chezmoi --source . --destination "$HOME" status --no-pager`
- `ruby -c Rakefile`
- `rake -n install_symlinks`

Exit criteria:

- Plain root dotfiles are managed by chezmoi.
- Applying chezmoi does not alter file contents unexpectedly.
- The old symlink installer ignores converted files and future repo metadata by default.

## Phase 3: Convert Git Configuration Template

Replace the custom Ruby ERB flow for `.gitconfig` with a chezmoi template.

Current behavior:

- `20-git/setup.rb` reads `20-git/gitconfig.erb`.
- It fills values from existing `git config` or interactive prompts.
- It writes `$HOME/.gitconfig`.

Target behavior:

- `home/dot_gitconfig.tmpl` renders `.gitconfig`.
- User-specific values come from local chezmoi data generated by `home/.chezmoi.toml.tmpl`.
- GitHub authentication uses GitHub CLI credential helpers when `gh` is available.
- The global Git ignore file is managed by chezmoi as `home/dot_gitignore`.

Tasks:

- Convert `20-git/gitconfig.erb` to `home/dot_gitconfig.tmpl`.
- Define required local data keys:
  - `git.name`
  - `git.email`
  - `git.githubUser`
- Add `home/.chezmoi.toml.tmpl` using `promptStringOnce` defaults for Git identity.
- Drop the obsolete `[github] token` entry.
- Add GitHub and Gist credential helpers only when `gh` is discoverable.
- Convert the global Git ignore file to `home/dot_gitignore`.
- Delete `20-git/setup.rb` and `20-git/gitconfig.erb` after chezmoi successfully applies `.gitconfig`.

Verification:

- Compare generated `.gitconfig` against the current file.
- `chezmoi --source . --destination "$HOME" execute-template --init --promptString 'Git name=Mick Staugaard' --promptString 'Git email=mick@staugaard.com' --promptString 'GitHub username=staugaard' --file home/.chezmoi.toml.tmpl`
- `chezmoi --source . --destination "$HOME" init --promptDefaults`
- `chezmoi --source . --destination "$HOME" execute-template --file home/dot_gitconfig.tmpl`
- `chezmoi --source . --destination "$HOME" diff --no-pager`
- `chezmoi --source . --destination "$HOME" apply --dry-run --verbose`
- `chezmoi --source . --destination "$HOME" apply --verbose`
- Confirm `$HOME/.gitconfig` has no `[github] token`.
- Confirm `$HOME/.gitignore` is a regular file and matches `home/dot_gitignore`.
- `ruby -c Rakefile`
- `rake -n install_executables`

Exit criteria:

- `.gitconfig` is generated by chezmoi.
- The global Git ignore file is managed by chezmoi.
- No Ruby ERB is needed for Git config.

## Phase 4: Convert Linked Assets and App Config

Move static config assets into chezmoi-managed paths.

Candidates:

- `10-zsh/oh-my-posh-theme.json` -> `.zsh/oh-my-posh-theme.json`
- `20-micro/settings.json` -> `.config/micro/settings.json`, if that is the actual target path
- terminal profile files, if they belong in stable user config locations

Tasks:

- For each asset, identify its real target path in `$HOME`.
- Convert symlinks to regular chezmoi-managed files unless live editing the source file is important.
- Use chezmoi external files only if an asset should be downloaded rather than stored directly.

Verification:

- `chezmoi diff`
- Open or reload the relevant app where practical.

Exit criteria:

- Static assets are installed by chezmoi rather than linked by setup scripts.
- Setup scripts no longer need to create directories only to place static files.

## Phase 5: Convert Setup Scripts

Move imperative setup into chezmoi scripts with explicit run behavior.

Script categories:

- `run_once_...`: one-time bootstrap steps such as installing a package manager dependency.
- `run_onchange_...`: reinstall or refresh when script contents change.
- `run_before_...` / `run_after_...`: ordering-sensitive scripts around file application.

Recommended conversions:

- Core package-manager setup becomes OS-specific `run_once_` scripts.
- Zsh package installation becomes `run_once_` or `run_onchange_`, depending on whether updates should be automatic.
- Cargo-installed tools such as `eza` and `zoxide` become idempotent scripts.
- macOS defaults become a clearly named macOS-only script.

Tasks:

- Preserve idempotency. A script should be safe to re-run even if chezmoi runs it again.
- Prefer small scripts grouped by concern rather than one large bootstrap script.
- Use template conditionals for OS-specific scripts where needed.
- Keep the original setup scripts until their chezmoi equivalents have run successfully.

Verification:

- `chezmoi apply --dry-run --verbose`
- `chezmoi apply --verbose`
- Re-run `chezmoi apply --verbose` and confirm scripts do not perform unwanted repeat work.

Exit criteria:

- Essential setup work can be performed through chezmoi.
- Script run frequency is intentional and documented by filename.

## Phase 6: Bootstrap Documentation

Document the new fresh-machine flow.

Tasks:

- Add or update `README.md` with:
  - installing chezmoi
  - initializing this repo
  - applying dotfiles
  - editing managed files
  - adding new dotfiles
  - handling machine-local config
- Include a short rescue path for inspecting changes:
  - `chezmoi diff`
  - `chezmoi apply --dry-run --verbose`
  - `chezmoi cd`

Recommended bootstrap shape:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <repo-url>
```

Exit criteria:

- A new machine no longer needs to know about `Rakefile` first.
- The expected daily workflow is documented.

## Phase 7: Remove Legacy Installer

Delete the old installer after chezmoi is the proven path.

Candidates for removal:

- `Rakefile`
- `run.sh`
- `package_manager.rb`
- setup scripts that have been fully replaced
- old ERB templates replaced by chezmoi templates

Tasks:

- Remove only files that no longer have an active role.
- Check for references to removed files in docs and scripts.
- Make one final pass for stale symlink assumptions.

Verification:

- `chezmoi doctor`
- `chezmoi diff`
- `chezmoi apply --dry-run --verbose`
- `chezmoi apply --verbose`
- Fresh clone/init smoke test if practical.

Exit criteria:

- Chezmoi is the only supported dotfiles application path.
- No Ruby dependency remains solely for dotfile installation.
- The repository structure clearly communicates the chezmoi model.

## Risks and Decisions

### Symlinks vs Managed Files

The current setup symlinks root dotfiles into `$HOME`. Chezmoi typically manages target files directly. Prefer regular managed files unless a file needs live source-tree editing from its home location.

### Secrets

No currently planned migration target should require secrets. If future secret-bearing dotfiles are added, decide whether they should remain untracked local files, become templates with local-only values, or move to encrypted chezmoi management.

### Script Re-Runs

Chezmoi can run scripts repeatedly depending on filename attributes. Each setup script should choose run behavior deliberately. Package installation scripts should be idempotent even when named as one-time scripts.

### Cross-Platform Scope

The repo currently supports macOS and Linux package managers. Preserve that support during migration, but avoid broad platform cleanup until after chezmoi is working.

## Suggested Commit Plan

1. Remove retired `.my.cnf` and `.ruby-version` dotfiles.
2. Add migration spec and initial chezmoi metadata.
3. Convert plain dotfiles.
4. Convert Git config templating.
5. Convert static assets.
6. Convert setup scripts.
7. Update bootstrap docs.
8. Remove legacy installer.

Each commit should leave at least one install path working.
