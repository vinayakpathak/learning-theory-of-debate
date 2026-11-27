// Compile with: typst compile notes/maxmin-debate-strategies.typ
#set document(title: "Maxmin strategies for debate with an unknown environment")
#set page(paper: "us-letter", margin: 1in, numbering: "1")
#set text(font: ("Times New Roman", "Libertinus Serif"), size: 11pt, lang: "en")
#set par(justify: true, spacing: 0.65em)
#set heading(numbering: "1.")
#show math.equation: set text(font: "New Computer Modern Math")
#let constraints = math.vec.with(delim: none, gap: 0.15em)
#let argmax = math.op("arg max", limits: true)

#title()

If each debater plays the strategy that gives it the best payoff in the
worst case, should we expect the proposer to give the correct answer?
This turns on what we take the worst case over. We first fix the environment
and vary the opponent. We then let each debater choose a strategy that must
work across environments. A single example will show what can happen both
in one debate and when the debaters can learn from earlier debates.

= The game for a fixed environment

Let $X$ be the input space, $Y = {0, 1}$ the label space, and $C$ a
finite set of certificates. An environment is a pair $E = (P, v)$. The
distribution $P$ supplies the inputs. The verifier $v$ judges the
debates. In one debate, both players see $x ~ P$. The proposer announces
a label $y$ and a certificate $p$. The responder sees both and chooses a
certificate $r$. The verifier accepts the proposal if $v(x, y, p, r) = 1$.
The winner gets one point and the loser gets zero.

We assume $v$ is valid. This means that for each $x$ there is a unique
label $h_v(x)$ for which the proposer can force acceptance. In symbols,
$
  y = h_v(x) quad <==> quad exists p in C thick forall r in C, quad v(x, y, p, r) = 1.
$
In particular, for a false label, every proposer certificate admits a reply
that gets the claim rejected.

A pure strategy for one debate is a function of the information the player
has when it moves. The two type signatures are
$
  pi: X arrow.r.long Y times C, quad rho: X times Y times C arrow.r.long C.
$
We allow each player to randomize. Write $Pi$ and $cal(R)$ for the
resulting sets of strategies. Given $(y, p) = pi(x)$ and
$r = rho(x, y, p)$, define $A_E(pi, rho) = bb(E)[v(x, y, p, r)]$, taking the
expectation over $x ~ P$ and the players' random choices. This is the
proposer's payoff. The responder's payoff is $1 - A_E(pi, rho)$.

For this fixed $E$, a pair $(pi_E, rho_E)$ is a Nash equilibrium if
neither player can gain by changing its strategy alone. Equivalently, for
every $pi, rho$,
$
  A_E(pi, rho_E) <= A_E(pi_E, rho_E) <= A_E(pi_E, rho).
$
Since the payoffs sum to one, these are the saddle-point inequalities.
They say that the proposer maximizes $inf_rho A_E(pi, rho)$ and the
responder maximizes $inf_pi (1 - A_E(pi, rho))$, with $E$ held fixed
in both optimizations. Conversely, any two such maxmin strategies form a
Nash equilibrium here. We can see this directly from validity. The proposer
can guarantee a payoff of one by giving the true label and a certificate
that forces acceptance on every input. Hence the proposer's maxmin value is
one and the responder's is zero. Pairing a proposer that guarantees one
with any responder satisfies the two inequalities.

It follows that every equilibrium proposer predicts $h_v(x)$ with
probability one under $P$. A single responder strategy can refute every
false claim by selecting a refuting $r$ for each observed $(x, y, p)$.
If the proposer made mistakes with positive probability, it could not
guarantee a payoff of one against that responder. This argument describes
play at equilibrium. How many verdicts the players would need to find such
strategies is a separate learning question.

= An unknown environment and one debate

Suppose the players know a family $cal(E)$ of possible environments.
Each $E in cal(E)$ specifies a game, but the family alone does not say
how to score a single strategy across those games. A prior on $E$ would
let us average its payoff. Here we ask what payoff the player can guarantee
for _every_ $E$. We can hold the distribution fixed by taking
$cal(E) = {P} times V$ for a verifier class $V$, or allow both
components to vary.

Keep the one-debate type signatures above. Write $G_"prop"$ and
$G_"resp"$ for the guaranteed payoffs, and $Pi^*$ and
$cal(R)^*$ for the sets of strategies that maximize them. Then
$
  G_"prop"(pi) &= inf_(constraints(E in cal(E), rho in cal(R))) A_E(pi, rho), && Pi^* &= argmax_(pi in Pi) G_"prop"(pi), \
  G_"resp"(rho) &= inf_(constraints(E in cal(E), pi in Pi)) (1 - A_E(pi, rho)), && cal(R)^* &= argmax_(rho in cal(R)) G_"resp"(rho).
$
Each player must use the same strategy across all environments. In a given
environment the opponents covered by its guarantee include every strategy,
including one that happens to play perfectly there. In particular,
in each environment some proposer can force acceptance, so
$G_"resp"(rho) = 0$ for every $rho$. Maximizing its guaranteed payoff
therefore places no restriction on the responder.

Consider a single input $x_0$, with $P(x_0) = 1$, and a hidden bit
$b = h_v(x_0)$. There are two possible environments $E_b = (P, v_b)$,
one for each $b in {0, 1}$. The responder can concede ($r = 0$) or
challenge ($r = 1$). The proposer certificate $p$ can be either bit.
For both values of $p$, define
$
  v_b(x_0, y, p, 0) = 1, quad v_b(x_0, y, p, 1) = bold(1){y = b}.
$
Both verifiers are valid. The correct answer always wins, and a challenge
defeats the wrong answer.

If a proposer predicts 1 with probability $q$, the worst case is a
challenge in the environment whose correct label is less likely under
that prediction. Its guaranteed payoff is therefore $min(q, 1 - q)$.
Thus a fair guess is maxmin, with
payoff guarantee $1\/2$. Pair this proposer with a responder that always
concedes, which is also maxmin. In either fixed $E_b$, the responder
could increase its win probability from zero to $1\/2$ by challenging.
So the maxmin pair fails the Nash condition in _both_ possible games.

= An unknown environment and strategies that use the history

Now fix a horizon $T$. The same $E = (P, v)$ is used on all $T$ rounds,
and $x_1, dots.h, x_T$ are independent draws from $P$. Let $H_(t-1)$
be the public history before round $t$. It records the input, the proposed
label, both certificates, and the verdict from every earlier round. Write
$cal(H)_(t-1)$ for its possible values, with $H_0$ empty. A pure
policy specifies the following functions for each $t$:
$
  pi_t &: cal(H)_(t-1) times X arrow.r.long Y times C, \
  rho_t &: cal(H)_(t-1) times X times Y times C arrow.r.long C.
$
Write $Pi_T, cal(R)_T$ for the corresponding policy sets, again
allowing randomization. On round $t$ the players choose $(y_t, p_t)$
and $r_t$ and observe $a_t = v(x_t, y_t, p_t, r_t)$. For fixed
$(E, pi, rho)$ the expected total payoffs are
$
  U_"prop"^T(E, pi, rho) = bb(E) lr([sum_(t=1)^T a_t]), quad
  U_"resp"^T(E, pi, rho) = T - U_"prop"^T(E, pi, rho).
$
Applying the same maxmin criterion to the whole policy gives
$
  G_"prop"^T(pi) &= inf_(constraints(E in cal(E), rho in cal(R)_T)) U_"prop"^T(E, pi, rho), && Pi_T^* &= argmax_(pi in Pi_T) G_"prop"^T(pi), \
  G_"resp"^T(rho) &= inf_(constraints(E in cal(E), pi in Pi_T)) U_"resp"^T(E, pi, rho), && cal(R)_T^* &= argmax_(rho in cal(R)_T) G_"resp"^T(rho).
$
Can the players now learn enough that their average play approaches a
Nash equilibrium of the one-debate game for the actual $E$?

Return to the two verifiers above. The proposer guesses a fair bit on the
first round and keeps proposing it until a rejection. A rejection reveals
that the other bit is correct, so the proposer switches permanently to that
bit. This policy loses at most once, and a loss requires the initial guess
to be wrong. It guarantees at least $T - 1\/2$ expected wins. To see that
this guarantee is optimal, take any proposer policy. Choose $b$ to be a
least likely first prediction and have the responder challenge on the
first round. This already forces at least
$1\/2$ expected losses. Thus the proposer's policy is maxmin for every
$T$. Every responder policy still guarantees zero total wins, since an
opponent that always proposes $b$ can win all $T$ rounds in $E_b$.
In particular, always conceding is maxmin for every $T$.

Fix either $E_b$ and run these two policies together. Every proposal is
accepted, so the proposer repeats its first guess forever. With probability
$1\/2$ it makes $T$ prediction mistakes, giving $T\/2$ in expectation.
To evaluate average play in the one-debate game, draw a round uniformly
from the first $T$ and use the one-debate strategy each player used at
that history. The responder concedes against either label at every history.
The proposer predicts the wrong label in the selected round with
probability $1\/2$. Against that average proposer, switching to a
challenge raises the responder's one-debate win probability from zero to
$1\/2$, for every $T$. Thus average play need not approach the Nash
equilibria of the actual environment. The distribution of inputs was known
throughout. Conceding guarantees the responder as many wins in the worst
case as challenging does, while depriving the proposer of the verdict
that would correct its mistake.
