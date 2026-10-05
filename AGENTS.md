# Project and collaboration

This repository contains a LaTeX manuscript on learning theory for AI debate.
The user edits locally in VS Code; collaborators edit the existing Overleaf
project. The user prefers agents to run Git commands on their behalf.

## Git remotes

The local editing branch is `main`, with upstream `origin/main`. A separate
local branch, `overleaf-sync`, tracks `overleaf/main` and holds the version
published to collaborators.

| Remote | URL | Purpose |
| --- | --- | --- |
| `origin` | `git@github.com:vinayakpathak/learning-theory-of-debate.git` | GitHub repository |
| `overleaf` | `https://git@git.overleaf.com/6ac2b476b1b29fb31bf77845` | Collaborators' Overleaf project |

The Overleaf remote branch is `main`. This setup uses direct Overleaf Git
access, not Overleaf's GitHub synchronization feature. The local repository
connects the remotes; they do not synchronize automatically.

**Keep `.gitignore` and `AGENTS.md` on local/GitHub `main`, but exclude them from
the active Overleaf project. Never push local `main` directly to Overleaf.**
The two branch tips intentionally differ in these files. Git ignore rules
cannot filter tracked files out of a push.

From local `main`, a normal `git push` targets GitHub only. This checkout also configures
`remote.overleaf.push` as `refs/heads/overleaf-sync:refs/heads/main`, so
`git push overleaf` publishes the filtered branch. Keep `origin/main` as the
upstream for local `main`. Remotes, this push mapping, and local hooks must be
recreated if needed in a new clone.

## Authentication

Overleaf uses username `git` and an Overleaf Git authentication token as the
HTTPS password. On this Mac, the token is stored in macOS Keychain, and Git's
configured credential helper is `osxkeychain`. Git retrieves it automatically;
agents do not need to read or display the token.

The temporary `.git/overleaf-token` file used for setup was deleted after
successful authentication. Do not depend on that file or put credentials in
tracked files, remote URLs, command arguments, or chat. If authentication stops
working, check the error and credential-helper configuration; a replacement
token can be supplied privately in a local file and imported into Keychain.
Keychain credentials are machine-local and are not included in this repository.

## Synchronization history

The independently initialized local/GitHub and Overleaf histories were joined
on 2026-10-05. `main.tex` already matched; the merge adopted Overleaf's
`Vinayak:` comment label in `macros.tex`. A subsequent cleanup removed
`.gitignore` and `AGENTS.md` from the Overleaf branch while retaining both on
`main`. The original histories are preserved; these files remain in earlier
Overleaf commits, but not its active project.

The histories now have common ancestors, so
`--allow-unrelated-histories` is no longer needed. Do not force-push or reset
away either side to make their intentionally different trees match.

## Importing collaborator changes

1. Check the working tree and preserve any uncommitted user edits. Fetch both
   remotes and integrate any new `origin/main` commits into `main`.
2. On clean local `main`, run
   `git merge --no-ff --no-commit overleaf/main`.
3. If a merge starts, keep the local metadata with
   `git restore --source=HEAD --staged --worktree -- .gitignore AGENTS.md`.
   This also resolves conflicts confined to those excluded files. Resolve all
   manuscript conflicts normally, preserving edits from both sides.
4. Review and commit the merge. If Git reports already up to date, no merge
   commit is needed. Keep the two local metadata files present in either case.

`--no-ff` matters: `--no-commit` alone does not stop a fast-forward from
removing the local metadata before it can be restored.

## Publishing manuscript changes

Before starting an export merge, compare the source trees. If there are no
manuscript changes to publish and the excluded files are already absent on
Overleaf, skip the export and push any requested `main` updates to GitHub.

1. Commit the requested local edits, then fetch again and import any new
   collaborator changes using the procedure above.
2. Use a temporary worktree on `overleaf-sync` so local `main` stays intact.
   If this branch is missing, create it from `overleaf/main`. Integrate any
   new `overleaf/main` commits on the sync branch before exporting.
3. In that worktree, merge reconciled `main` using
   `git merge --no-ff --no-commit main`. Resolve manuscript conflicts normally.
   Before committing, remove the excluded files with
   `git rm -f --ignore-unmatch -- .gitignore AGENTS.md`.
4. Review the staged result and commit the export merge. The source files
   should match reconciled `main`; neither excluded file may be in the export
   tree. Finish or abort any started merge before removing its worktree.
5. Push with `git push overleaf overleaf-sync:main`, then
   `git push origin main`. Remove the clean temporary worktree when finished.
6. If a push is rejected because new edits arrived, fetch and integrate them
   before retrying. Never use force. Report which remotes were updated.

The local `.git/hooks/pre-push` guard rejects pushes to this Overleaf project
if the pushed tree contains `.gitignore` or `AGENTS.md`. It does not affect
GitHub pushes. This guard and the default push mapping are machine-local;
do not bypass the guard to publish an unfiltered branch.

## Files and review comments

The manuscript is `main.tex`, with shared definitions in `macros.tex` and the
included ALT/JMLR class and style files. Preserve collaborator comments and
research notes unless the requested edit calls for changing them.

`.gitignore` excludes `.vscode/`, PDFs regardless of extension capitalization,
and `.DS_Store`. Keep those exclusions. Ignore rules do not untrack files already
present in remote history; inspect any such files during reconciliation.

Comments such as `\vinayak{...}`, `\ruth{...}`, and `\tosca{...}` are LaTeX
source and synchronize normally. Overleaf's built-in review comments and tracked
changes are separate metadata: Git pushes can displace or lose them, especially
when files are renamed. Account for active review metadata before syncing.
