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

# Writing guidelines

These guidelines adapt the general writing preferences in
`~/infrabayes/AGENTS.md` to this learning theory manuscript.

## Default writing voice

- Write in the user's voice by default, including manuscript prose, notes,
  and explanations. Use their own writing and passages they have explicitly
  liked as the reference. Their latest edits and feedback take precedence
  over generic preferences for academic style.
- Use plain, direct sentences that explain what we are doing and why.
  Keep the mathematics precise, but write as one mathematician explaining
  an argument to another. Publication quality should come from clarity
  and correctness, not a more formal voice.
- Preserve the user's wording, rhythm, and order of ideas when editing.
  For a rough draft or outline, keep its structure and make local corrections
  for accuracy and readability. Do not replace it with a generic
  conference-paper voice. Match the user's style, not chat typos or shorthand.
  Requests to "polish" or "make this publishable" do not override this default.
- State the goal of a section, proof, or construction before its details.
  Explain what changes, what stays fixed, and what we will show before
  introducing the definitions and machinery.
- Develop an explanation one step at a time. State the idea, raise a natural
  objection when it matters, give a concrete example, and explain why the
  objection does or does not cause a problem. Use this sequence when it helps;
  do not force it onto every paragraph.
- Prefer concrete objects and actions to abstract nouns and academic phrases.
  Write "learn enough about the class to get low regret" rather than "seek an
  approximation sufficient to control regret." Natural transitions such as
  "For example" and "But this is fine" are welcome when they fit.
- Do not join a claim and its explanation with a colon. Write "The map is
  onto. For any right-hand side, we can ..." rather than "The map is onto:
  for any right-hand side, ...". A colon introducing a displayed formula
  is fine.
- Put qualifications where the argument needs them. Keep introductory
  explanations free of unnecessary caveats and derivations; explain side
  claims in words and cite or defer their details. State any assumption
  needed to make an intuitive claim correct, or narrow the claim.
- Treat assumptions established for the whole manuscript as implicit later,
  unless a result changes their scope. When temporarily setting an issue
  aside, state the simplifying assumption and say that the issue will be
  addressed later; a label such as "warmup" is not an explanation.
- In introductions, explain the obstacle and the idea that resolves it.
  Do not replace that explanation with a compressed inventory of technical
  mechanisms. Introduce technical details when they clarify the main idea.
- Write for a mathematically mature reader. Keep the exposition compact but
  explicit. Use the simplest examples and parameter dependence that make
  the point, and omit routine specializations, implementation details, and
  checks that belong in the full proof.

The user approved the following passage in the source project as a reference
for tone and the sequence of an explanation:

> The learner’s task is to learn enough about \(\mathcal L\) to get low regret.
> Of course, we may never learn all of \(\mathcal L\). For example, if the adversary
> keeps choosing conditional means in a strictly smaller subspace, then we
> cannot distinguish that subspace from the true \(\mathcal L\). But this is
> fine: we do not need to learn directions that the adversary never uses.

Use this as a voice reference, not as a template to repeat or as assumptions
or terminology for the debate model.

## Learn from writing feedback

- When the user requests a writing change, consider the preference it reveals
  about tone, wording, structure, explanations, or notation.
- Make the revision and update these writing guidelines during the same
  task when the feedback supports a new general principle. These updates
  are authorized without a separate confirmation.
- Keep inferred preferences as specific as the feedback supports. Distinguish
  writing preferences from mathematical corrections and instructions for one
  passage. Do not invent a broader preference when the reason is unclear.
- Read the existing guidelines before adding one. If the principle is already
  covered, apply it without adding or rewriting a duplicate. Refine an
  existing rule when feedback qualifies or changes it; add a rule only for
  a distinct principle. Apply it to the current revision and future writing.

## Definitions, notation, and mathematical exposition

- Define abbreviations once at first use, then use the short form throughout,
  including appendices. Use consistent names for the same mathematical
  objects and participants across definitions, statements, and proofs.
- Define every new function or quantity before the formula or instruction
  that uses it, including within an algorithm or display. When formalizing
  an idea already explained in words, explicitly connect the notation to it.
- Replace technical jargon used only once with its operative mathematical
  definition. Likewise, replace informal terms with a specific meaning by
  an explanation of the choice or quantity involved.
- Use concrete notation and defined objects rather than vague referents or
  undefined collective names. When an object is indexed by another, write
  "the hypothesis corresponding to $U$" rather than "the hypothesis of $U$".
- Use distinct base letters for unrelated quantities that appear together;
  do not rely only on subscripts or accents. Reuse established notation for
  the same role in the algorithm, analysis, and appendices.
- Distinguish an actual count from a bound on it, and explain their relation.
  Prefer an explicit subscript such as "max" for a bound to a time subscript
  that could be mistaken for the actual count.
- Use unprimed variables in function definitions unless a distinction is
  needed there. A prime distinguishing a candidate from a chosen object in
  an optimization rule need not carry into the function's definition.
- Prefer concise established expressions to unnecessary shorthand symbols.
  For example, use $|M|$ directly when defining $n=|M|$ would only add notation.
  Define hypotheses directly through their coefficients when a separate
  parameter space serves no purpose. Prefer the notation or coordinates of
  a construction to repeated technical adjectives.
- State the dimensions of parameterized matrices and vectors, distinguishing
  fixed dimensions from the dependence of entries on the parameter. Say
  "a matrix with rational entries" or "a vector with rational coordinates",
  not "a rational matrix" or "a rational vector"; identify which components
  of a history or other compound object have the property.
- State general properties once instead of enumerating obvious special cases.
  Integrate definitions and explanations into the argument's narrative.
  Keep short expressions and simple inequality chains inline when they
  complete a sentence; use displays when they improve readability. Number
  equations only when referenced elsewhere, including earlier in the text.
- Refer to sections and appendices by number using labels such as
  `Section~\ref{...}` and `Appendix~\ref{...}`, not informal names. Reuse
  earlier definitions instead of redefining objects. When a distant passage
  relies on an object's structure, briefly recall the relevant structure.
- Define model changes precisely with formulas and explain their relation
  to the original setting. If borrowing a framework, show how both settings
  fit it and cite the section that defines it.
- When comparing models, state the most important difference first. For
  regret guarantees, distinguish the comparator, the learner's actual
  performance or hypothetical value, and how observations are generated.
  A shared comparator does not mean that two papers bound the same regret.
- Explain material needed for the next step without repeating what was just
  displayed. After revising a paragraph, check that the next paragraph
  continues from its new ending instead of restarting the motivation.

## Theorems, lemmas, and proofs

- By default, do not give lemmas names or title-like bold prefixes. Begin
  with the mathematical statement; add a name only when the user requests
  one. Internal reference labels are allowed.
- Set theorem and lemma statements as running text beginning on the same
  line as the heading. In LaTeX, avoid blank lines after `\begin{lemma}`
  or between consecutive sentences of the statement.
- Give each lemma one claim. State a general fact in the lemma and apply
  it to a particular object in the surrounding text. Motivate a lemma by
  saying what it proves and why the next step needs that fact.
- State hypotheses in the form provided by earlier results. Do not assume
  a numerical bound that follows only from a later parameter choice; derive
  it in the proof. State intermediate results in the form needed by the
  current algorithm, deferring extra generality for later algorithms.
- State reusable concentration bounds as lemmas with the probability and
  scope of the event in the statement and a separate proof. Carry probability
  qualifications into derived statements and use the same event throughout
  each proof.
- Cite established lemmas and theorems instead of rederiving them or turning
  their conclusions into new assumptions. Distinguish author attribution
  from established theorem names. For an unnamed result, say "a result of
  [author]" or cite its theorem number; author attribution in a heading is fine.
- Organize proofs around the idea and what each step achieves. Name the
  standard results used and the structural properties that make them apply.
  Explain the general construction before specializing it when special-case
  algebra would hide the idea.
- When a standard inequality justifies a substantive step, name it and show
  the short computation rather than describing only how quantities grow.
  If a chain of equalities proves the desired identity, avoid first proving
  one inequality by the same calculation unless that introduces a useful
  general method.
- Do not put a formal lemma inside a proof sketch. State a needed fact in a
  sentence, including its probability qualification and constant dependencies,
  cite the appendix equation or lemma proving it, and continue the argument.

## Algorithms and learning guarantees

- Before a formal algorithm, explain in words how the learner works, in the
  order its steps occur. Explain each step before using shorthand for its
  outputs. For a refinement, first explain the guiding principle, the earlier
  learner's limitation, and what the new score or rule lets us decide.
- Give the algorithm and the definitions needed to read it before its
  analysis. A short lemma establishing a new score's guarantee may follow
  its definition and selection rule before the full algorithm; reuse that
  lemma in the analysis.
- When a later learner reuses an earlier technique, refer back and explain
  only what changes, including new formulas or assumptions. Discuss multiple
  learners collectively only after each has been introduced. Keep remarks
  about a later learner in its own section.
- Introduce parameters by saying when they will be chosen and what the choice
  should achieve. State a lemma about an algorithm step using that step's
  inputs and quantities, rather than introducing a global horizon when a
  bound in terms of the local inputs suffices.
- For regret analyses, put an informal theorem and a short proof sketch after
  the algorithm in the main body. Explain each term's source, how often its
  cost occurs, and how balancing the terms gives the rate. Put exact constants,
  technical lemmas, and full proofs in a dedicated appendix with explicit
  references from the main body.
- In informal arguments, use asymptotic bounds to explain the tradeoff before
  exact constants or detailed algebra. State suppressed dependencies and
  logarithmic factors. Simplify expressions such as `O(log(T+1))` to
  `O(log T)` there, retaining small-parameter adjustments in precise statements.
  Leave routine bookkeeping that does not affect the rate to the full proof.
- Justify a rate requirement in a computational definition through the
  concrete loophole a weaker requirement permits. Track both runtime and
  regret in the construction; for a general rate function, state the growth
  condition and carry the function through the argument. Do not substitute
  convention or a preference for faster convergence for this explanation.
  A concise mechanism and citation may replace a published derivation, but
  nuanced justifications belong beside the definition, not in a footnote.

## Computational arguments, when relevant

- If an analysis assumes exact optimization, keep the algorithm, theorem,
  and proof under that assumption. Explain numerical approximation and its
  effect on the guarantee in the computational discussion.
- State the decision and optimization problems before their implementation.
  Give the reduction's idea in the main body and cite an appendix for the
  explicit formulation and precision arguments. Open the appendix with its
  plan and recall what the reduction establishes and what remains to prove.
- First show how each problem fits the solver's hypotheses as if the solver
  were exact, then explain approximate solutions and error control. Explain
  auxiliary variables and multipliers by identifying their defining equations
  and purpose. Display a new optimization problem's objective and variable
  domains before analyzing it.
- State substantive identities and claims that a problem has a required
  program formulation as lemmas, with the construction and hypothesis checks
  in their proofs. For several problems, preserve their order and numbering
  and complete each treatment before the next. Use parallel lemmas when
  appropriate, citing the earlier technique and giving only the new details.
  Do not describe one problem's obstacle as the whole implementation's only
  remaining issue.
- Specify the actual algorithmic input: what is built into the learner,
  explicitly supplied, or accessed through oracles. Explain representations
  of infinite sets and distinguish established representations from new
  encoding assumptions. Do not impose encoding requirements on unused data.
- State runtime in usual parameters such as $\log(1/\varepsilon)$ for
  accuracy $\varepsilon$, handling encoding details in the proof. State
  accuracy lemmas for a general parameter in the scale their proofs control.
  Explain a later choice where it is made, including its runtime cost, instead
  of hiding that choice inside the lemma through a parameter conversion.
- For NP-hardness sections, give the main-body overview in words, identifying
  which variants are hard or tractable and citing the appendix for each.
  Put formal theorems next to reductions and proofs. Keep statements to the
  setting, learner assumptions, and conclusion; put construction details,
  constants, and intermediate claims in the proof. Use parallel statements
  for parallel results and avoid repeating definitions just given in the text.

## Related work and citations

- Keep related work short, about one paragraph per theme. Choose a few
  relevant concepts with one or two sources each, explain their connection
  to this model, and summarize individual papers only as needed for comparison.
- For a foundational topic, use a narrative: pose the question, give the
  standard answer and attribution, explain its shortcomings, and introduce
  the alternatives leading to the object used here. State the connection to
  this work in the first sentence or two and keep the paragraph moderate in
  length; a roughly 500-word paragraph is too long.
- Prefer published papers or books to blogs and forum posts when they make
  the same point. Use a forum post only when no such published source exists.
- For citation-only requests, preserve prose exactly. Place directly relevant
  sources beside the claims they support, using multiple sources where useful.
  Flag unsupported or contradicted claims separately instead of attaching
  misleading citations.

## LaTeX and document style

- Prefer the conference template's theorem, lemma, proof, and algorithm
  environments, with small style adjustments when needed instead of separate
  conversion-only environments. Use proof environments for full proofs and
  sketches, with their automatic QED markers.
- Use the existing `algorithm2e` package and its pseudocode commands for
  loops, branches, and instructions when writing formal algorithms.
- Preserve the ALT template's author--year citations, shared theorem/lemma
  counter, appendix headings and pagination, and default hyperlink colours.
  Use lettered appendix sections with numeric subsection suffixes such as
  A.1 and A.2 unless the template requires otherwise. When reviewing venue
  compliance, distinguish recommended style from an explicit rejection rule.
