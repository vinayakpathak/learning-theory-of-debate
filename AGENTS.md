# Project and collaboration

This repository contains a LaTeX manuscript on learning theory for AI debate.
The user edits locally in VS Code; collaborators edit the existing Overleaf
project. The user prefers agents to run Git commands on their behalf.

## Git remotes

The local branch is `main`, with upstream `origin/main`.

| Remote | URL | Purpose |
| --- | --- | --- |
| `origin` | `git@github.com:vinayakpathak/learning-theory-of-debate.git` | GitHub repository |
| `overleaf` | `https://git@git.overleaf.com/6ac2b476b1b29fb31bf77845` | Collaborators' Overleaf project |

The Overleaf remote branch was verified to be `main`. This setup uses direct
Overleaf Git access, not Overleaf's GitHub synchronization feature. The local
repository connects the two remotes; they do not synchronize automatically.
A normal `git push` targets GitHub only. Keep `origin/main` as the upstream and
use explicit remote names when synchronizing. Remote configuration is local to
this checkout and must be recreated if needed in a new clone.

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
on 2026-10-05 with a merge preserving both histories. `main.tex` already matched
exactly. The only source difference was the `\vinayak` comment macro: the merge
kept Overleaf's `Vinayak:` label in place of the local `todo:` label. The local
ignore rules and this setup document were also retained.

Future synchronization should use ordinary merges; the initial
`--allow-unrelated-histories` option is no longer needed for these histories.
Fetch and inspect the current state rather than assuming either remote is
unchanged. Do not force-push or reset away either side to make them match.

## Routine synchronization

1. Check the working tree and preserve any uncommitted user edits.
2. Fetch and merge updates from `origin/main` and `overleaf/main` before editing.
3. Edit locally and commit the requested changes, staging source files explicitly.
4. Before publishing to Overleaf, fetch again and merge any new collaborator
   changes. Resolve conflicts and check the resulting manuscript.
5. For a requested sync with collaborators, push the reconciled branch with
   `git push overleaf main:main`, then `git push origin main`.
6. If a push is rejected because new changes arrived, fetch and merge them, then
   retry without force. Report which remotes were successfully updated.

Overleaf supports a single remote branch. Local feature branches can be used,
but their changes should be merged into `main` before syncing to Overleaf.

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
