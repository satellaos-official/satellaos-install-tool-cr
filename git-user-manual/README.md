# Git Quick Start Guide

A simple guide for connecting a local project to GitHub and pushing your first commit.

---

## 1. Configure Your Git Identity

Set your Git username and email address.

```bash
git config --global user.name "your-github-username"
git config --global user.email "your-email@example.com"
```

Verify your settings:

```bash
git config --global --list
```

---

## 2. Navigate to Your Project Directory

Open a terminal and move into your project folder.

```bash
cd /path/to/your/project
```

Example:

```bash
cd $HOME/my-project
```

---

## 3. Initialize a Git Repository

Create a new local Git repository.

```bash
git init
```

---

## 4. Create a GitHub Repository

Create a new repository on GitHub.

**Recommended:**
- Leave the repository empty.
- Do not add a README, LICENSE, or .gitignore during creation.

---

## 5. Connect the Local Repository to GitHub

Replace the URL with your repository URL.

```bash
git remote add origin https://github.com/username/repository.git
```

Verify the remote:

```bash
git remote -v
```

---

## 6. Enable Credential Storage (Optional)

This allows Git to remember your credentials.

```bash
git config --global credential.helper store
```

> **Warning**
>
> Credentials may be stored in plain text. Avoid using this option on shared or public computers.

---

## 7. Rename the Default Branch to Main

Some systems still use `master` as the default branch.

```bash
git branch -m master main
```

If your branch is already named `main`, you can skip this step.

---

## 8. Create Your First Commit

Add all files:

```bash
git add .
```

Create a commit:

```bash
git commit -m "Initial commit"
```

---

## 9. Push to GitHub

Upload your project to GitHub.

```bash
git push -u origin main
```

The `-u` option sets the upstream branch so future pushes only require:

```bash
git push
```

---

# Handling Common Conflicts

## Option 1: Pull Remote Changes

Recommended when the GitHub repository already contains files.

```bash
git pull --rebase origin main
```

Then push again:

```bash
git push -u origin main
```

---

## Option 2: Force Push

Use only if you want to overwrite everything on the remote repository.

```bash
git push -u origin main --force
```

> **Warning**
>
> This can permanently overwrite remote changes and cause data loss.

---

# Cloning an Existing Repository

Download an existing GitHub repository:

```bash
git clone https://github.com/username/repository.git
```

Enter the project directory:

```bash
cd repository
```

---

# Useful Commands

Check repository status:

```bash
git status
```

View commit history:

```bash
git log
```

Check configured remotes:

```bash
git remote -v
```

Pull latest changes:

```bash
git pull
```

Push local changes:

```bash
git push
```