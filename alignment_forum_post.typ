// Math article styling. No external packages or fonts are required.
#set page(
  paper: "us-letter",
  margin: (x: 1.15in, top: 1in, bottom: 0.9in),
  footer: context align(center, text(
    size: 9pt,
    fill: rgb("777777"),
    counter(page).display("1"),
  )),
)
#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "en",
  fill: rgb("222222"),
)
#set par(justify: true, leading: 0.65em, spacing: 0.85em)

// Use = for the title, == for sections, and === for subsections.
#set heading(numbering: none)
#show heading: set block(above: 1.6em, below: 0.6em)
#show heading.where(level: 1): set text(size: 25pt, weight: "regular")
#show heading.where(level: 1): set block(above: 0pt, below: 1.6em)
#show heading.where(level: 1): set par(justify: false, leading: 0.4em)
#show heading.where(level: 1): it => align(center, block(width: 80%, it))
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 11pt, weight: "bold")

// Inline math uses $...$; display math uses $ ... $ with spaces inside.
#show math.equation: set text(font: "New Computer Modern Math")
#show math.equation.where(block: true): set block(above: 1em, below: 1em)
#show link: set text(fill: rgb("294e63"))

// Start writing your post below.

= Towards a Theory of Learnability via Debate

Debate is a popular training protocol that is believed to be a promising approach to the problem of scalable oversight