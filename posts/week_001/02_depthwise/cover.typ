
#import "@preview/cetz:0.5.3"

#let paper     = rgb("#F7F6F0")
#let alloy     = rgb("#EAE7DC")
#let ink       = rgb("#111214")
#let volta     = rgb("#FFD100")
#let graphite  = rgb("#5C626E")

#let red-channel = rgb("#F04450")
#let green-channel = rgb("#26A65B")
#let blue-channel = rgb("#2788C9")
#let yellow-filter = rgb("#F5E65A")
#let purple-filter = rgb("#B64CA6")

// --------------------------------------------------
// DEPTHWISE SEPARABLE HERO ILLUSTRATION
// --------------------------------------------------


#let depthwise-hero() = {
  cetz.canvas(length: 1.45cm, padding: 0.2, {
    import cetz.draw: *

    let feature-map = (
      x, y, rows, cols,
      cell: 0.45,
      color: paper,
      border: graphite,
    ) => {
      for i in range(cols) {
        for j in range(rows) {
          rect(
            (x + i * cell, y + j * cell),
            (x + (i + 1) * cell, y + (j + 1) * cell),
            fill: color,
            stroke: 0.8pt + border,
          )
        }
      }
    }

    let feature-stack = (
      x, y, rows, cols, depth,
      colors,
      cell: 0.45,
      dx: 0.17,
      dy: 0.17,
    ) => {
      for k in range(depth) {
        let layer = depth - k - 1
        feature-map(
          x + layer * dx,
          y + layer * dy,
          rows,
          cols,
          cell: cell,
          color: colors.at(layer),
        )
      }
    }

    // ----------------------------------------------
    // INPUT — LARGE RGB STACK
    // ----------------------------------------------

    feature-stack(
      0.0, 0.8,
      7, 7, 3,
      (red-channel, green-channel, blue-channel),
      cell: 0.55,
      dx: 0.22,
      dy: 0.22,
    )

    // ----------------------------------------------
    // DEPTHWISE — THREE INDEPENDENT FILTERS
    // ----------------------------------------------

    let fcell = 0.48

    feature-map(
      6.0, 2.0, 3, 3,
      color: red-channel,
      cell: fcell,
    )

    feature-map(
      7.4, 2.0, 3, 3,
      color: green-channel,
      cell: fcell,
    )

    feature-map(
      8.8, 2.0, 3, 3,
      color: blue-channel,
      cell: fcell,
    )

    // ----------------------------------------------
    // POINTWISE — THREE CHANNELS MIXED
    // ----------------------------------------------

    let px = 12.0
    let py = 2.0
    let pcell = 0.65
    let pd = 0.24

    // Three overlapping 1x1 slices
    feature-map(
      px + 2 * pd, py + 2 * pd,
      1, 1,
      cell: pcell,
      color: blue-channel,
    )

    feature-map(
      px + pd, py + pd,
      1, 1,
      cell: pcell,
      color: green-channel,
    )

    feature-map(
      px, py,
      1, 1,
      cell: pcell,
      color: volta,
    )

    // ----------------------------------------------
    // OUTPUT — NEUTRAL FEATURE MAP STACK
    // ----------------------------------------------

    feature-stack(
      16.0, 1.0,
      7, 7, 4,
      (alloy, alloy, alloy, alloy),
      cell: 0.55,
      dx: 0.17,
      dy: 0.17,
    )

    // ----------------------------------------------
    // FLOW ARROWS
    // ----------------------------------------------

    line(
      (4.5, 2.8),
      (5.5, 2.8),
      stroke: 1.6pt + volta,
      mark: (end: ">"),
    )

    line(
      (10.5, 2.8),
      (11.4, 2.8),
      stroke: 1.6pt + volta,
      mark: (end: ">"),
    )

    line(
      (13.9, 2.8),
      (15.2, 2.8),
      stroke: 1.6pt + volta,
      mark: (end: ">"),
    )
  })
}


#let depthwise-hero-v2() = {
  cetz.canvas(length: 1.45cm, padding: 0.2, {
    import cetz.draw: *

    // ----------------------------------------------
    // HELPERS
    // ----------------------------------------------

    let feature-map = (
      x, y, rows, cols,
      cell: 0.45,
      color: paper,
      border: graphite,
    ) => {
      for i in range(cols) {
        for j in range(rows) {
          rect(
            (x + i * cell, y + j * cell),
            (x + (i + 1) * cell, y + (j + 1) * cell),
            fill: color,
            stroke: 0.8pt + border,
          )
        }
      }
    }

    let feature-stack = (
      x, y, rows, cols, depth,
      colors,
      cell: 0.45,
      dx: 0.17,
      dy: 0.17,
    ) => {
      for k in range(depth) {
        let layer = depth - k - 1
        feature-map(
          x + layer * dx,
          y + layer * dy,
          rows,
          cols,
          cell: cell,
          color: colors.at(layer),
        )
      }
    }

    let caption = (x, y, value, color: paper, size: 13pt) => {
      content(
        (x, y),
        text(
          font: "JetBrains Mono",
          size: size,
          weight: "bold",
          fill: color,
        )[#value],
        anchor: "center",
      )
    }

    // ----------------------------------------------
    // 01 / INPUT — 10 × 10 × 3
    // ----------------------------------------------

    let input-x = -2.0
    let input-y = 0.5
    let input-cell = 0.45

    feature-stack(
      input-x, input-y,
      10, 10, 3,
      (red-channel, green-channel, blue-channel),
      cell: input-cell,
    )

    caption(input-x + 2.25, 6.0, "01 / Imagem")
    caption(input-x + 2.25, 0.0, "10 × 10 × 3", color: alloy)

    // Arrow
    line(
      (3.2, 2.6),
      (4.3, 2.6),
      stroke: 1.3pt + volta,
      mark: (end: ">"),
    )

    // ----------------------------------------------
    // 02 / DEPTHWISE — THREE SEPARATE FILTERS
    // One 3 × 3 × 1 filter per input channel
    // ----------------------------------------------

    let dw-x = 4.6
    let dw-y = 2.0
    let dw-cell = 0.30
    let dw-gap = 1.12

    // Red filter
    feature-map(
      dw-x, dw-y,
      3, 3,
      cell: dw-cell,
      color: red-channel,
    )

    // Green filter
    feature-map(
      dw-x + dw-gap, dw-y,
      3, 3,
      cell: dw-cell,
      color: green-channel,
    )

    // Blue filter
    feature-map(
      dw-x + 2 * dw-gap, dw-y,
      3, 3,
      cell: dw-cell,
      color: blue-channel,
    )

    caption(dw-x + 1.5, 4.6, "02 / Depthwise")
    caption(dw-x + 1.5, 1.2, "3 × (3 × 3 × 1)", color: alloy)

    // Arrow
    line(
      (8.6, 2.6),
      (9.4, 2.6),
      stroke: 1.3pt + volta,
      mark: (end: ">"),
    )

    // ----------------------------------------------
    // 03 / INTERMEDIATE MAPS — 8 × 8 × 3
    // ----------------------------------------------

    let mid-x = 9.7
    let mid-y = 1.0

    feature-stack(
      mid-x, mid-y,
      8, 8, 3,
      (red-channel, green-channel, blue-channel),
      cell: 0.36,
      dx: 0.14,
      dy: 0.14,
    )

    caption(mid-x + 1.15, 5.2, "03 / Mapas")
    caption(mid-x + 1.15, 0.2, "8 × 8 × 3", color: alloy)

    // Arrow
    line(
      (13.0, 2.6),
      (13.7, 2.6),
      stroke: 1.3pt + volta,
      mark: (end: ">"),
    )

    // ----------------------------------------------
    // 04 / POINTWISE — TWO 1 × 1 × 3 FILTERS
    // Each filter combines all three channels
    // ----------------------------------------------

    let pw-x = 14.0
    let pw-y = 2.1
    let pw-cell = 0.42
    let pw-dx = 0.13
    let pw-dy = 0.13

    // Draw the two independent 1 × 1 × 3 filters,
    // one behind the other.
    let pointwise-filter = (x, y, outline) => {
      feature-map(
        x + 2 * pw-dx, y + 2 * pw-dy,
        1, 1,
        cell: pw-cell,
        color: blue-channel,
        border: outline,
      )
      feature-map(
        x + pw-dx, y + pw-dy,
        1, 1,
        cell: pw-cell,
        color: green-channel,
        border: outline,
      )
      feature-map(
        x, y,
        1, 1,
        cell: pw-cell,
        color: red-channel,
        border: outline,
      )
    }

    // Back filter first, then front filter
    pointwise-filter(pw-x + 0.35, pw-y + 0.30, graphite)
    pointwise-filter(pw-x, pw-y, ink)

    caption(pw-x + 0.55, 4.6, "04 / Pointwise")
    caption(pw-x + 0.55, 1.2, "2 × (1 × 1 × 3)", color: alloy)

    // Arrow
    line(
      (16.3, 2.6),
      (17.0, 2.6),
      stroke: 1.3pt + volta,
      mark: (end: ">"),
    )

    // ----------------------------------------------
    // 05 / OUTPUT — 8 × 8 × 2
    // ----------------------------------------------

    let out-x = 17.4
    let out-y = 1.0

    feature-stack(
      out-x, out-y,
      8, 8, 2,
      (alloy, alloy),
      cell: 0.36,
      dx: 0.14,
      dy: 0.14,
    )

    caption(out-x + 1.55, 5.2, "05 / Saída")
    caption(out-x + 1.55, 0.2, "8 × 8 × 2", color: alloy)
  })
}

// --------------------------------------------------
// BLUEPRINT COVER
// --------------------------------------------------

#let blueprint-cover(
  tag: "01 / 06",
  headline: "Uma técnica de uma década",
  highlight: "Torna a IA mais rápida hoje",
  subtitle: "Como dividir uma operação pode tornar modelos de visão mais eficientes.",
  footer: "@paulo-rozatto",
) = {
  set page(
    width: 1080pt,
    height: 1350pt,
    fill: paper,
    margin: (x: 72pt, y: 72pt),
    background: place(top + left, dx: 36pt, dy: 36pt)[
      #rect(
        width: 1008pt,
        height: 1278pt,
        stroke: 1pt + alloy,
      )
    ],
  )

  set text(
  font: "Inter",
  fill: ink,
  size: 24pt,
)

  // Header
  grid(
    columns: (1fr, auto),
    align: (left, right),
    column-gutter: 10pt,
    [
      #box(fill: volta, inset: (x: 12pt, y: 6pt))[
        #text(
          font: "JetBrains Mono",
          size: 18pt,
          weight: "bold",
          fill: ink,
        )[#tag]
      ]
    ],
    [
      //#text(
      //  font: "JetBrains Mono",
      //  size: 15pt,
      //  fill: graphite,
      //)[#kicker]
    ],
  )

  v(52pt)

  // Headline
  text(
    font: "Space Grotesk",
    size: 70pt,
    weight: "bold",
    tracking: -1.5pt,
  )[#headline]

  v(0pt)

  text(
  font: "Space Grotesk",
  size: 70pt,
  weight: "bold",
  fill: volta,
  tracking: -1.5pt,
)[#highlight]

  v(20pt)

  text(
    size: 23pt,
    fill: graphite,
  )[#subtitle]

  v(36pt)

  // Technical illustration panel
  box(
  width: 100%,
  fill: graphite,
  inset: 120pt,
  radius: 5pt,
)[
  #align(center)[
    #depthwise-hero()
  ]
]

  v(24pt)

  // Highlighted takeaway
  line(length: 100%, stroke: 2pt + volta)

  v(14pt)

  text(
    font: "JetBrains Mono",
    size: 15pt,
    fill: graphite,
  )[

    Depthwise Separable Convolutions

  ]

  v(1fr)

  // Footer
  place(bottom + left)[
    #text(
      font: "JetBrains Mono",
      size: 16pt,
      fill: graphite,
    )[#footer]
  ]

  place(bottom + right)[
    #text(
      font: "JetBrains Mono",
      size: 16pt,
      fill: graphite,
      weight: "bold",
    )[Week 01 / Post 02]
  ]
}
