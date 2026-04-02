# Day 22 – Git Fundamentals Notes

## Difference Between `git add` and `git commit`

`git add` moves changes from the working directory into the staging area.

`git commit` creates a permanent snapshot of what is staged.

Add prepares changes. Commit records them.

---

## What is the Staging Area?

The staging area acts as a preparation layer between working directory and repository.

## Why doesn't Git just commit directly?

Git doesn't commit directly because the staging area gives you control. It allows selective commits. Instead of committing everything, you control exactly what goes into the next snapshot.

This improves precision and history quality.

---

## What information does `git log` show you?

`git log` displays the chronological history of all your committed work. 
- The commit hash (a unique ID for that version).
- The author who made the changes.
- The date and time of the commit.
- The commit message describing what was done.

It represents the timeline of the repository.

---

## What is the `.git/` folder & what happens if you delete it?

The `.git/` folder contains:

- Commit history
- Objects (snapshots)
- Branch references
- Configuration

If you delete `.git/`, the directory is no longer a Git repository.
All version history is permanently lost.

---

## Working Directory vs Staging Area vs Repository

Working Directory:
Where you edit files.

Staging Area:
Where changes are prepared for commit.

Repository:
The database of committed snapshots.

Flow:
Working Directory → Staging Area → Repository

---

Git is not just a tool.
It is a change management system.
