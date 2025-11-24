# Neomutt Nix Development Environment

This repository contains a shell.nix configuration for reproducible Neomutt development. It provides a hermetic environment with all dependencies (Notmuch, Lua, SASL, etc.) pre-configured.

1. Quick Start
**Entering the Environment**
Run the following command in the directory containing shell.nix:
```bash
nix-shell
```

**Building Neomutt**
Once inside the shell and in the proper `git worktree` folder, configure and build using the provided hooks:
```bash
# Configure with all features enabled (disable docs for speed)
./configure --enable-everything --disable-doc
```

# Build using all available cores
```
make -j$(nproc)
``` 

2. Git Worktree Workflow
We use a Bare Repository strategy. This allows you to have multiple branches checked out simultaneously in sibling directories (e.g., main, ai-agent, feature) without constantly switching context in a single folder.

**Step 1: Directory Setup (Bare Clone)** 
Create a project directory and clone your fork as a bare repository.

```bash
mkdir neomutt-dev
cd neomutt-dev

# Clone your fork as a bare repository into a hidden .git folder
git clone --bare git@github.com:YOUR_USERNAME/neomutt.git .git

# Fix the git configuration to handle worktrees correctly
git config --bool core.bare false
``` 

**Step 2: Establish "Read-Only" Main**
Create a worktree for main. We treat this as a pristine reference point—never build or code here.

```bash
# Check out main into a specific directory
git worktree add main main
# (Optional) Prevent accidental pushes from this local branch
cd main
git config branch.main.pushRemote no_push
cd ..
``` 

**Step 3: Add Upstream Remote**
Connect to the official repository to fetch updates.
```bash
cd main
git remote add upstream [https://github.com/neomutt/neomutt.git](https://github.com/neomutt/neomutt.git)
git fetch upstream
cd ..
```

**Step 4: Create Development Worktrees**
Create specific directories for your active tasks.
1. AI Agent Development: `git worktree add -b ai-agent ai-agent main`
2. Feature Development: `git worktree add -b feat/new-sidebar feature main`
3. Code Review (Detached Head):
Use this slot to check out Pull Requests without polluting your local branches.
```bash
git worktree add --detach review main
``` 

**Step 5: Managing shell.nix**
Keep shell.nix in the root folder and symlink it into active worktrees:
```bash
ln -s ../shell.nix ai-agent/shell.nix
ln -s ../shell.nix feature/shell.nix
``` 

**Directory Structure**
├── .git/           # Bare repository (metadata only)
├── shell.nix       # Nix environment definition
├── main/           # Read-only reference to upstream/main
├── ai-agent/       # Active worktree for AI features
├── feature/        # Active worktree for generic features
└── review/         # Detached worktree for testing PRs

