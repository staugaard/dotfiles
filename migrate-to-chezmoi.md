# Migrate Dotfiles to Chezmoi

## Goal

Move this dotfiles repository from a custom `Rakefile` plus per-directory setup scripts to a chezmoi-managed source tree.

The target state is:

- Dotfiles are rendered and applied by chezmoi.
- Machine-specific values use chezmoi templates and local config data.
- Setup tasks are expressed as chezmoi scripts with clear run semantics.
- Chezmoi is the only supported bootstrap and apply path.
- The old Rake/Ruby bootstrap path is removed.

## Current State

The repository is now a chezmoi repository:

- The repository root is the git working tree.
- `.chezmoiroot` points chezmoi at the `home/` source state.
- `home/` contains dotfiles, app config, package data, source-only templates, and setup scripts.
- Chezmoi owns bootstrap, application, and daily maintenance workflows.

Some setup work remains imperative and host-dependent, but it now lives in chezmoi scripts:

- OS package setup varies between Homebrew and APT.
- macOS and Linux terminal setup import application state rather than manage simple home-directory files.

Package lists and setup behavior are declared in `home/.chezmoidata/packages.yaml` and implemented by sparse, idempotent scripts under `home/.chezmoiscripts/`.

## Non-Goals

- Do not redesign the shell environment during the migration.
- Do not replace Homebrew, APT, Cargo, or language-specific installers with a new provisioning framework.
- Do not introduce Nix, Ansible, or another broader machine management layer.
- Do not preserve retired personal configuration just because it is currently tracked.
- Do not keep compatibility wrappers after chezmoi has proven the bootstrap path.

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

Conversions:

- `10-zsh/oh-my-posh-theme.json` -> `home/dot_zsh/oh-my-posh-theme.json`
- `20-micro/settings.json` -> `home/dot_config/micro/settings.json`

Deferred:

- Terminal profile files stay in their current directories for Phase 4 because they are imported into app state by setup scripts rather than mapped to stable home-directory files.

Tasks:

- Move static assets into the `home/` source state.
- Delete old asset copies from `10-zsh/` and `20-micro/`.
- Convert `$HOME/.zsh/oh-my-posh-theme.json` and `$HOME/.config/micro/settings.json` from legacy symlinks to regular chezmoi-managed files.
- Update `10-zsh/setup.rb` to keep shell/tool installation but stop creating or linking the prompt theme.
- Update `20-micro/setup.rb` to keep Micro installation but stop creating or linking `settings.json`.
- Leave package installation and tool bootstrap behavior in setup scripts until Phase 5.

Verification:

- `chezmoi --source . --destination "$HOME" diff --no-pager`
- `chezmoi --source . --destination "$HOME" apply --dry-run --verbose`
- `chezmoi --source . --destination "$HOME" apply --verbose`
- Confirm `$HOME/.zsh/oh-my-posh-theme.json` and `$HOME/.config/micro/settings.json` are regular files, not symlinks.
- Confirm applied contents match `home/dot_zsh/oh-my-posh-theme.json` and `home/dot_config/micro/settings.json`.
- `chezmoi --source . --destination "$HOME" status --no-pager`
- `ruby -c 10-zsh/setup.rb`
- `ruby -c 20-micro/setup.rb`
- `rake -n install_executables`

Exit criteria:

- Static assets are installed by chezmoi rather than linked by setup scripts.
- Setup scripts no longer need to create directories only to place static files.
- Terminal profile import remains deferred to Phase 5.

## Phase 5: Convert Setup Scripts

Move imperative setup into chezmoi scripts with explicit run behavior.

Script categories:

- `run_once_...`: one-time bootstrap steps such as installing a package manager dependency.
- `run_onchange_...`: reinstall or refresh when script contents change.
- `run_before_...` / `run_after_...`: ordering-sensitive scripts around file application.

Recommended conversions:

- Package installation is data-driven from `home/.chezmoidata/packages.yaml`.
- Core package-manager setup becomes OS-specific `run_once_before_` scripts.
- Package installation uses `run_onchange_before_` so package-list changes trigger reruns.
- One-time bootstraps such as nvm and rustup use `run_once_after_`; nvm resolves the latest upstream release at apply time.
- Cargo-installed tools such as `eza` and `zoxide` use an idempotent `run_onchange_after_` script.
- Imported app state such as GNOME Terminal and macOS Terminal profiles uses checksum-triggered `run_onchange_after_` scripts.
- macOS defaults use a clearly named macOS-only `run_onchange_after_` script.

Tasks:

- Preserve idempotency. A script should be safe to re-run even if chezmoi runs it again.
- Prefer small scripts grouped by concern rather than one large bootstrap script.
- Use template conditionals for OS-specific scripts where needed.
- Render unsupported-platform scripts to empty output so chezmoi skips them.
- Move terminal profile import assets into `home/.chezmoitemplates/terminal/` so they are source-only and not applied as home files.
- Remove unsafe legacy behavior such as shell-startup downloads, `git checkout .zshrc`, old hard-coded Go tarballs, and system-wide font writes.
- Delete replaced numbered setup scripts after their chezmoi equivalents have run successfully.
- Leave `Rakefile`, `run.sh`, and `package_manager.rb` for Phase 7 cleanup.

Verification:

- Render all script templates with `chezmoi --source . --destination "$HOME" execute-template --file <script>`.
- Run shell syntax checks on rendered scripts where practical.
- `chezmoi --source . --destination "$HOME" diff --no-pager`
- `chezmoi --source . --destination "$HOME" apply --dry-run --verbose`
- `chezmoi --source . --destination "$HOME" apply --verbose`
- Re-run `chezmoi --source . --destination "$HOME" apply --verbose` and confirm scripts do not perform unwanted repeat work.
- Confirm key commands are available: `brew`, `git`, `go`, `micro`, `gh`, `eza`, `zoxide`, `rustup`, and nvm from `$HOME/.nvm/nvm.sh`.
- `chezmoi --source . --destination "$HOME" status --no-pager`
- `rake -n install_executables`

Exit criteria:

- Essential setup work can be performed through chezmoi.
- Script run frequency is intentional and documented by filename.
- Replaced numbered setup scripts are gone.

## Phase 6: Bootstrap Documentation

Turn the README into the durable operating manual for this chezmoi repo.

Phase 6 is documentation hardening, not another migration of managed targets.
At this point, chezmoi owns dotfiles, app assets, local Git config templating,
package setup scripts, macOS defaults, Linux fonts, and terminal profile imports.
The README should describe that end state directly instead of presenting the
repo as a temporary Rake-to-chezmoi bridge.

Tasks:

- Rewrite `README.md` around the primary fresh-machine flow:
  - `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/staugaard/dotfiles.git`
  - `chezmoi init --apply git@github.com:staugaard/dotfiles.git` for machines that already have GitHub SSH access.
- Document the safe inspection flow:
  - `chezmoi init`
  - `chezmoi diff --no-pager`
  - `chezmoi apply --dry-run --verbose`
  - `chezmoi apply --verbose`
- Document the local-clone inspection flow using `chezmoi --source . --destination "$HOME"`.
- Document daily maintenance:
  - `chezmoi cd`
  - edit files under `home/`
  - `chezmoi diff --no-pager`
  - `chezmoi apply --verbose`
  - commit and push from the source repository.
- Document adding new files with `chezmoi add`, while noting that this repo uses `.chezmoiroot` and stores source state under `home/`.
- Document machine-local config generated from `home/.chezmoi.toml.tmpl`, including Git name, Git email, and GitHub username.
- Document how to revisit local config with `chezmoi init --prompt` or `chezmoi edit-config`.
- Document current ownership boundaries:
  - chezmoi owns dotfiles, static app assets, package/bootstrap scripts, macOS defaults, Linux fonts, and terminal profile imports.
  - package behavior is driven by `home/.chezmoidata/packages.yaml`.
  - macOS uses Homebrew; Linux support is apt-based only.
- Demote `Rakefile`, `run.sh`, and `package_manager.rb` to legacy migration residue. New setup should use chezmoi, not `./run.sh`.

Recommended bootstrap shape:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/staugaard/dotfiles.git
```

Verification:

- Read the README end to end from the perspective of a fresh machine.
- Search for stale transitional language, including old `./run.sh` install instructions and Phase 6 placeholder wording.
- Confirm the docs do not reference unsupported package managers.
- `chezmoi --source . --destination "$HOME" doctor`
- `chezmoi --source . --destination "$HOME" verify`
- `chezmoi --source . --destination "$HOME" status --no-pager`
- `chezmoi --source . --destination "$HOME" apply --dry-run --verbose`

Exit criteria:

- A new machine no longer needs to know about `Rakefile` first.
- `chezmoi init --apply` is documented as the durable bootstrap flow.
- The expected daily workflow and local-config workflow are documented.
- Phase 7 remains clearly scoped to deleting legacy installer residue.

## Phase 7: Remove Legacy Installer

Delete the old installer now that chezmoi is the proven path.

Removed files:

- `Rakefile`
- `run.sh`
- `package_manager.rb`
- ignored local Ruby build residue: `mkmf.log`

Tasks:

- Remove the tracked legacy installer files.
- Remove `mkmf.log` from repo `.gitignore` and managed `home/dot_gitignore`.
- Delete the local ignored `mkmf.log` artifact if present.
- Update `README.md` so chezmoi is documented as the only supported install and apply path.
- Update this spec so the current state describes the finished chezmoi repo rather than an active migration bridge.
- Check for stale references to removed files, Ruby/Rake bootstrap commands, numbered setup directories, and old symlink assumptions.

Verification:

- `chezmoi --source . --destination "$HOME" doctor`
- `chezmoi --source . --destination "$HOME" diff --no-pager`
- `chezmoi --source . --destination "$HOME" apply --dry-run --verbose`
- `chezmoi --source . --destination "$HOME" apply --verbose`
- `chezmoi --source . --destination "$HOME" verify`
- `chezmoi --source . --destination "$HOME" status --no-pager`
- Confirm `$HOME/.gitignore` matches `home/dot_gitignore` after apply.
- Confirm no ignored `mkmf.log` artifact remains.

Exit criteria:

- Chezmoi is the only supported dotfiles application path.
- No Ruby/Rake dependency remains solely for dotfile installation.
- The repository structure clearly communicates the chezmoi model.

## Phase 8: Polish Chezmoi End State

Clean up migration residue and harden the final chezmoi model.

Tasks:

- Delete stale `home/.chezmoiignore` because it has no active ignore rules.
- Move zsh plugin setup fully out of shell startup by installing plugins through OS package data.
- Make `.zshrc` tolerant of fresh and partial machines by guarding optional tools and using `$HOME`-based paths.
- Rename the nvm script to `run_onchange_` and render the latest nvm GitHub release into the script so upstream releases trigger a content change.
- Pin Linux Hack Nerd Font installation to the Nerd Fonts `v3.4.0` release archive and verify its SHA256 before extraction.
- Document package/script maintenance in `README.md`.

Verification:

- Render all script templates with `chezmoi --source . --destination "$HOME" execute-template --file <script>`.
- Run `bash -n` against every non-empty rendered script.
- `chezmoi --source . --destination "$HOME" ignored`
- `chezmoi --source . --destination "$HOME" diff --no-pager`
- `chezmoi --source . --destination "$HOME" apply --dry-run --verbose`
- `chezmoi --source . --destination "$HOME" apply --verbose`
- `chezmoi --source . --destination "$HOME" verify`
- `chezmoi --source . --destination "$HOME" status --no-pager`
- Start an interactive zsh smoke test and confirm startup has no clone/download/error output.

Exit criteria:

- Shell startup has no network install side effects.
- nvm updates are driven by chezmoi-rendered script content.
- Linux font installation is pinned and checksum-verified.
- Maintenance docs describe the package/script workflow.

## Risks and Decisions

### Symlinks vs Managed Files

The old setup symlinked root dotfiles into `$HOME`. Chezmoi now manages target files directly. Prefer regular managed files unless a file needs live source-tree editing from its home location.

### Secrets

No currently planned migration target should require secrets. If future secret-bearing dotfiles are added, decide whether they should remain untracked local files, become templates with local-only values, or move to encrypted chezmoi management.

### Script Re-Runs

Chezmoi can run scripts repeatedly depending on filename attributes. Each setup script should choose run behavior deliberately. Package installation scripts should be idempotent even when named as one-time scripts.

### Cross-Platform Scope

The repo supports macOS through Homebrew and Linux through APT. Keep that scope focused unless there is a concrete new platform to support.

## Suggested Commit Plan

1. Remove retired `.my.cnf` and `.ruby-version` dotfiles.
2. Add migration spec and initial chezmoi metadata.
3. Convert plain dotfiles.
4. Convert Git config templating.
5. Convert static assets.
6. Convert setup scripts.
7. Update bootstrap docs.
8. Remove legacy installer.

Each migration commit left at least one install path working. After Phase 7, chezmoi is the install path.
