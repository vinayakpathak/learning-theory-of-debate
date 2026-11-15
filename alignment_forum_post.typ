// LessWrong-inspired typography, using local fonts with a bundled fallback.
#set page(
  paper: "us-letter",
  margin: (x: 1in, top: 0.85in, bottom: 0.85in),
)
#set text(
  font: ("Palatino", "Georgia", "Libertinus Serif"),
  size: 13pt,
  lang: "en",
  fill: rgb("333333"),
  hyphenate: false,
)
#set par(justify: false, leading: 0.75em, spacing: 1.2em)

// Use = for the title, == for sections, and === for subsections.
#set heading(numbering: none)
#show heading: set text(weight: "regular", fill: rgb("222222"))
#show heading: set par(leading: 0.35em)
#show heading: set block(above: 1.8em, below: 0.75em)
#show heading.where(level: 1): set text(size: 28pt)
#show heading.where(level: 1): set block(width: 85%, above: 0pt, below: 1em)
#show heading.where(level: 2): set text(size: 19pt)
#show heading.where(level: 3): set text(size: 15pt)

// Inline math uses $...$; display math uses $ ... $ with spaces inside.
#show math.equation: set text(font: "New Computer Modern Math")
#show math.equation.where(block: true): set block(above: 1em, below: 1em)
#show link: set text(fill: rgb("327e09"))

// Start writing your post below.

= Towards a Theory of Learnability via Debate

Debate is a popular training protocol that is believed to be a promising approach to the problem of scalable oversight. Even though it is a training protocol, not a lot is known about its learning behaviour. I uploaded a paper to arXiv with my coauthors Tosca Lechner, Sivan Sabato, and Ruth Urner that takes the first steps towards analyzing the learning theoretic aspects of debate. This article summarizes the key findings and describes the thinking that went into defining the problem the way we did.

== The problem of scalable oversight
It is known by now that a superintelligence is hard to create simply by writing its code directly. Even mild intelligences, that can recognize whether a picture is of a cat or not, are hard to create in this way and thus we have to resort to supervised learning. The idea is that even though we cannot write down the precise definition of a cat in the form of an algorithm, we can tell if a given picture is of a cat or not. Thus all we need to do is write the code for a _learner_ that looks at many examples of pictures of "cat" vs "not a cat" and writes down its own code for identifying cats. 

However, we want a superintelligence to accomplish more complex tasks than identifying cats. In a very general sense, we want an algorithm that takes in the state of the world, and outputs the best possible next action. However, computing the best possible next action is very challenging for a human being. Thus a supervised learning approach will not work since we aren't even able to calculate the labels that the learner would use for learning.

Even though we can't compute the next best action, it is feasible that we can provide some other kind of feedback. For example, the learner can show us the entire trajectory that the world would take starting from its proposed next action. Presumably, we can then judge whether we like the trajectory or not and give our judgement back to the learner as feedback. The problem of scalable oversight asks, what is the feedback we can continue to provide to a learner as it tries to learn to accomplish more and more complex tasks? 

== A complexity theoretic analogy
Following the "AI safety via debate" paper by Irving et al, we can consider the simpler question where the learner has finished learning and just needs to convince us that it has learned the right thing. Presumably, we need to be able to understand this certification problem before we can solve the learning problem. We can also hope that once we have a solution for certification, we can attempt to convert that into a solution for learning by using the feedback given by the human as a loss function to run gradient descent on. For example, suppose the learner tries to prove that it has found the correct solution, but the human disagrees, then one can try to propagate some gradients to the weights of the learner so that its next proposed certificate has a better chance of convincing the human.

Now, for the problem of certification, we can ask, what's the largest class of problems that can be certified by a human? Assume that a human is someone who can solve problems in P. The learner is something that can solve problems in a higher complexity class. For what classes does the learner have a way of proving to the human that it has found the correct solution? For example, suppose the learner can solve problems in the class $"NP" inter "co-NP"$. This means, there exists a polynomial time algorithm $A$ such that for every $x$ and $y$, there exists some certificate $c$ such that $A(x,y,c)$ returns true if $y$ is the correct label for $x$ and if $y$ isn't the correct label for $x$ then no certificate $c$ exists that can make $A(x,y,c)$ return true. Since $A$ is a polynomial time algorithm, a human can implement it. Thus we can ask the learner to produce both $y$ and $c$ for any given $x$ and we can ask the human to evaluate $A(x,y,c)$ as feedback that is then fed back to the learner. 

More generally, we can consider the entire polynomial hierarchy. Here, we have a constant number $k$ of certificates $c_1, c_2, dots, c_k$, each of length polynomial in the length of $x$. There exists a polynomial time algorithm $A$ such that if $y$ is the correct label, there exists a $c_1$ such that for every $c_2$, there exists a $c_3$, and so on, such that $A(x,y,c_1,c_2,dots,c_k)$ returns true. If $y$ is incorrect, then for every $c_1$ there exists a $c_2$ such that for every $c_3$, and so on, $A$ returns false. Thus we can ask the learner to produce $c_1$, another learner to try to refute it with $c_2$, the first learner to respond with $c_3$, and so on. A human only needs to evaluate $A$ at the end. Allowing any constant number of rounds, independent of the length of $x$, gives us the polynomial hierarchy. If we instead allow a polynomial number of rounds, keeping verification polynomial time, the resulting class is $"PSPACE"$, the class of problems that can be solved using polynomial space.

The process of generating the sequence of $c_i$'s looks like a _debate_ between two learners, and thus this protocol has been called debate. The argument above shows that in principle a polynomial time human can judge whether the answer to a problem in PSPACE is correct or not given the debate transcript consisting of the sequence of $c_i$'s. In particular, given any input $x$ and a candidate answer $y$, consider the game played between two debaters where each debater takes turns to compute certificates $c_i$'s. Once the entire transcript is generated, it is given along with $x$ and $y$ to the human and the payoff of the first debater is 1 if the human jusges the transcript to be a valid argument for certifying that $y$ is the answer to $x$ and 0 otherwise. The payoff of the second debater is the opposite of the payoff of the first, thus making it a zero sum game. The argument above shows that assuming the original problem is in PSPACE and the human judge can implement $A$, the first debater has a winning strategy for a pair $x, y$ if and only if $y$ is the correct answer to $x$. 

But just because the debater _has_ a winning strategy doesn't mean it can _find_ it. Indeed, if there was an efficient way of finding it for all $x$, then PSPACE would be equal to P. But the hope is that perhaps one can design an efficient algorithm (potentially gradient-based) for finding these strategies for the kinds of $x$'s one encounters in the real world. Finding strategies for wining is a learning problem, and it should be studied formally.


== Scalable oversight as a learning problem
Explain our learning problem.

Explain why online as opposed to iid.

== Solutions to the learning problem
Explain how cooperative learning becomes relevant

== Is debate a good solution?
Example where cooperative is better than oppositional.

== What about fallible humans?

== Next steps

