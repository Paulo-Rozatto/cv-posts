// blueprint.typ — Editorial Blueprint Visual Identity
#let paper     = rgb("#F7F6F0")
#let alloy     = rgb("#EAE7DC")
#let ink       = rgb("#111214")
#let volta     = rgb("#FFD100")
#let graphite  = rgb("#5C626E")

#let blueprint-slide(
  tag: "IP • 01",
  title: "Slide Title",
  footer: "paulo-rozatto",
  body
) = {
  set page(
    width: 1080pt,
    height: 1350pt, // 4:5 portrait for LinkedIn & Bluesky
    fill: paper,
    margin: (x: 72pt, y: 72pt),
    background: place(top + left, dx: 36pt, dy: 36pt)[
      // Signature yellow viewfinder corner marks
      #rect(width: 1008pt, height: 1278pt, stroke: 1pt + alloy)
    ]
  )
  set text(font: "Inter", fill: ink, size: 24pt)

  // Header badge + yellow highlight bar
  box(fill: volta, inset: (x: 12pt, y: 6pt))[
    #text(font: "JetBrains Mono", weight: "bold", size: 18pt)[#tag]
  ]
  v(14pt)
  text(font: "Space Grotesk", weight: "bold", size: 46pt, tracking: -0.5pt)[#title]
  v(24pt)
  line(length: 100%, stroke: 2pt + ink)
  v(28pt)

  // Main slide content
  body

  // Footer
  place(bottom + left)[
    #text(font: "JetBrains Mono", size: 16pt, fill: graphite)[#footer]
  ]
}