# Kitty Development Workspace

This Kitty setup is optimized for working on multiple coding projects simultaneously with Codex, Fish, and lazygit.

## Mental model

Kitty terminology:

- **Tab = project**
- **Window = terminal/split inside a project**
- **OS window = the actual Kitty application window**

A normal project looks like:

```text
Tab: miga-agent

┌───────────────────────────────┬───────────────┐
│                               │               │
│                               │     shell     │
│                               │               │
│            CODEX              ├───────────────┤
│                               │               │
│                               │    lazygit    │
│                               │               │
└───────────────────────────────┴───────────────┘
```

The goal is to keep one Kitty tab per active project and switch between projects instead of opening many terminal windows.

---

# Main keybindings

`kitty_mod` is:

```text
Ctrl + Shift
```

## Project management

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+P` | Open project launcher |
| `Ctrl+Shift+U` | Previous project/tab |
| `Ctrl+Shift+I` | Next project/tab |
| `Ctrl+Shift+G` | Select from currently open projects/tabs |

`Ctrl+Shift+P` launches the `kproj` picker.

It first asks for a mode:

```text
work        Codex + shell + lazygit
terminal    Plain Fish terminal
```

Then it asks for a Git project under:

```text
~/code
```

### Work mode

Creates:

```text
┌──────────────────────────┬──────────────┐
│                          │ shell        │
│                          │              │
│          CODEX           ├──────────────┤
│                          │ lazygit      │
│                          │              │
└──────────────────────────┴──────────────┘
```

### Terminal mode

Creates a project tab containing only a Fish shell.

Use this for commands, experiments, dev servers, logs, etc. when a full Codex workspace is unnecessary.

---

# Navigation inside a project

Vim-style navigation:

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+H` | Focus window to the left |
| `Ctrl+Shift+J` | Focus window below |
| `Ctrl+Shift+K` | Focus window above |
| `Ctrl+Shift+L` | Focus window to the right |

Think:

```text
        K
        ↑
    H ←   → L
        ↓
        J
```

---

# Creating and closing windows

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+Enter` | Create an automatic split |
| `Ctrl+Shift+X` | Close current split/window |

Example:

```text
┌──────────────────────────┬──────────────┐
│                          │ shell        │
│          CODEX           ├──────────────┤
│                          │ lazygit      │
└──────────────────────────┴──────────────┘
```

Need another temporary terminal?

```text
Ctrl+Shift+Enter
```

Do the work, then:

```text
Ctrl+Shift+X
```

The additional split is intentionally disposable.

---

# Zooming a window

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+Z` | Zoom/unzoom focused window |

Example:

```text
┌─────────────────────┬────────────┐
│                     │ shell      │
│       CODEX         ├────────────┤
│                     │ lazygit    │
└─────────────────────┴────────────┘
```

Focus lazygit and press:

```text
Ctrl+Shift+Z
```

to get:

```text
┌──────────────────────────────────┐
│                                  │
│             LAZYGIT              │
│                                  │
└──────────────────────────────────┘
```

Press `Ctrl+Shift+Z` again to restore the split layout.

This is particularly useful for Codex, lazygit, logs, or anything that temporarily needs the entire terminal.

---

# Useful Kitty defaults

These are Kitty defaults that are still useful alongside the custom workspace bindings.

## Tabs

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+T` / `Cmd+T` | New tab |
| `Ctrl+Shift+Q` / `Cmd+W` | Close current tab |

Normally prefer `Ctrl+Shift+P` over manually creating tabs, since `kproj` gives the tab the correct project name, directory, and layout.

---

## Clipboard

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+C` / `Cmd+C` | Copy |
| `Ctrl+Shift+V` / `Cmd+V` | Paste |

On macOS, `Cmd+C` and `Cmd+V` are usually the most convenient.

---

## Search and scrollback

| Shortcut | Action |
|---|---|
| `Cmd+F` | Search terminal scrollback |

Note that some original Kitty `Ctrl+Shift+...` scrollback shortcuts have been intentionally replaced by our workspace navigation bindings.

---

## Font size

On macOS:

| Shortcut | Action |
|---|---|
| `Cmd++` | Increase font size |
| `Cmd+-` | Decrease font size |
| `Cmd+0` | Reset font size |

---

## Kitty configuration

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+F1` | Show Kitty shortcut help |
| `Ctrl+Shift+F2` / `Cmd+,` | Edit `kitty.conf` |
| `Ctrl+Shift+F5` | Reload `kitty.conf` |
| `Ctrl+Shift+F6` | Show/debug active Kitty configuration |

Most edits to `kitty.conf` can therefore be tested with:

```text
edit → save → Ctrl+Shift+F5
```

---

# Suggested daily workflow

## Starting work

Open Kitty.

Press:

```text
Ctrl+Shift+P
```

Choose:

```text
work
```

Then select the project:

```text
miga-agent
```

Repeat for any other project you need:

```text
Ctrl+Shift+P
work
resonate

Ctrl+Shift+P
work
some-other-project
```

You now have:

```text
Kitty
├── miga-agent
│   ├── Codex
│   ├── shell
│   └── lazygit
│
├── resonate
│   ├── Codex
│   ├── shell
│   └── lazygit
│
└── some-other-project
    ├── Codex
    ├── shell
    └── lazygit
```

---

## Switching projects

For adjacent projects:

```text
Ctrl+Shift+U    previous
Ctrl+Shift+I    next
```

When several projects are open:

```text
Ctrl+Shift+G
```

and select the desired tab directly.

---

## Working inside a project

Move between Codex, shell, and lazygit with:

```text
Ctrl+Shift+H/J/K/L
```

Typical loop:

```text
Codex
  ↓ J/L
shell
  ↓ J
lazygit
  ↑ K
shell
  ← H
Codex
```

There is no need to reach for the mouse.

---

## Temporarily focusing one tool

Navigate to it:

```text
Ctrl+Shift+H/J/K/L
```

then:

```text
Ctrl+Shift+Z
```

Work fullscreen.

When finished:

```text
Ctrl+Shift+Z
```

to restore the project layout.

---

## Need an extra shell?

Press:

```text
Ctrl+Shift+Enter
```

Kitty creates another split in the current project and inherits the current working directory.

When finished:

```text
Ctrl+Shift+X
```

Treat these extra windows as disposable scratch terminals.

---

## Need a project without Codex?

Use:

```text
Ctrl+Shift+P
```

then:

```text
terminal
```

This creates a normal project tab with only Fish.

Good uses include:

- running a dev server
- Docker Compose
- logs
- database shells
- one-off commands
- experiments
- monitoring processes

---

# Core shortcuts to memorize

If nothing else, remember these:

```text
PROJECTS

Ctrl+Shift+P        open project
Ctrl+Shift+U/I      previous / next project
Ctrl+Shift+G        choose open project


WINDOWS

Ctrl+Shift+HJKL     move around
Ctrl+Shift+Enter    create split
Ctrl+Shift+X        close split
Ctrl+Shift+Z        zoom / restore
```

Everything else is secondary.

---

# Files

Kitty configuration:

```text
~/.config/kitty/kitty.conf
```

Project launcher:

```text
~/.local/bin/kproj
```

Projects:

```text
~/code/
```

Suggested structure:

```text
~/code/
├── miga-agent/
├── resonate/
├── project-a/
└── project-b/
```

`kproj` discovers Git repositories in this directory and presents them through `fzf`.

---

# Philosophy

Keep the hierarchy simple:

```text
Kitty
    ↓
Tab = project
    ↓
Window = process
```

Use `kproj` to create predictable project environments.

Use tabs to switch context.

Use splits to work within that context.

Use temporary splits when something does not deserve a permanent place in the project layout.
