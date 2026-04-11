---
name: hyprland-safe-refactor
description: Use this skill when refactoring or modularizing Hyprland config under a stowed dotfiles setup, especially when extracting behavior into new sourced files from hyprland.conf. It enforces the safe workflow: create empty target files first, have the user run `stow -vRt ~ hyprland` from the `stow/` directory, wait for confirmation, only then move config into the new files, add `source` lines, and save `hyprland.conf` last.
metadata:
  short-description: Safe Hyprland stow refactors
---

# Hyprland Safe Refactor

## Use This Skill For

Use this skill when changing Hyprland config in a stowed dotfiles repo, especially under `stow/hyprland/.config/hypr`, and the work involves creating a new file that will be sourced by `hyprland.conf`.

Typical triggers:

- Create a new file that needs to be sourced using `source = ~/.config/hypr/...`
- Reorganize Hyprland config into modular sourced files

Do not use this workflow for simple edits that stay inside existing files and do not introduce a new sourced file.

## Required Workflow

When a new Hyprland config file needs to be introduced and sourced follow this sequence exactly:

1. Create the empty file in the repo first.
2. Stop and tell the user to run `stow -vRt ~ hyprland` from the `stow/` directory.
3. Wait for explicit user confirmation before moving any config into the new file.
4. After confirmation, move the relevant config into the new file.
5. Add the `source = ~/.config/hypr/<file>.conf` line to the calling file.
6. Save `hyprland.conf` last with a harmless final write so Hyprland notices the entrypoint change. Do this even if `hyprland.conf` itself was not changed.

Never skip the confirmation step when adding a new sourced Hyprland file.

## Operating Rules

- Before any substantial work, inspect the current files so the extraction is based on real structure rather than assumptions.
- Only split out a new file when the extracted block is substantial enough to justify a separate file.
- Avoid creating many tiny files. As a rule of thumb, prefer `10+` lines of cohesive config before extracting.
- Keep `hyprland.conf` as the composition root. It should source the major config areas, not duplicate them.
- Source order matters. If the new file depends on variables defined elsewhere, keep it after the file that defines them.
- Preserve unrelated user changes. Never revert existing edits you did not make.

## Communication Pattern

Use short progress updates in this pattern:

1. Say you are identifying the target block and creating the empty file.
2. Ask the user to run:

```bash
stow -vRt ~ hyprland
```

from the `stow/` directory.

3. Wait.
4. After confirmation, explain that you are extracting the block, wiring the `source`, and saving `hyprland.conf` last.

## Implementation Notes

- If you are creating `foo.conf`, create the empty file first and do not populate it until after the user confirms the `stow` step.
- After editing the new file and the source file, perform a final harmless edit to `hyprland.conf` so it is the last file written.
- When reporting completion, mention that `hyprland.conf` was saved last.

## Example

Example extraction request:

"Extract the multimedia bindings from `bindings.conf` into `system-bindings.conf`."

Expected behavior:

1. Create empty `system-bindings.conf`.
2. Ask the user to run `stow -vRt ~ hyprland` from `stow/`.
3. Wait for confirmation.
4. Move the binding block into `system-bindings.conf`.
5. Add `source = ~/.config/hypr/system-bindings.conf` to `bindings.conf`.
6. Save `hyprland.conf` last.
