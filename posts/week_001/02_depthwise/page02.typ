#import "@preview/cetz:0.5.3"

#let paper = rgb("#F7F6F0")
#let alloy = rgb("#EAE7DC")
#let ink = rgb("#111214")
#let volta = rgb("#FFD100")
#let graphite = rgb("#5C626E")

#let red-channel = rgb("#F04450")
#let green-channel = rgb("#26A65B")
#let blue-channel = rgb("#2788C9")

// --------------------------------------------------
// STANDARD CONVOLUTION HERO
// One kernel spans ALL input channels, one per output.
// --------------------------------------------------
//

#let standard-conv-hero() = {
  cetz.canvas(length: 1.45cm, padding: 0.2, {
    import cetz.draw: *

    let feature-map = (
      x,
      y,
      rows,
      cols,
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
      x,
      y,
      rows,
      cols,
      depth,
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

    let caption = (x, y, value, color: paper, size: 16pt) => {
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
    // 01 / INPUT  4 × 4 × 3
    // ----------------------------------------------
    feature-stack(
      -2,
      0.5,
      10,
      10,
      3,
      (red-channel, green-channel, blue-channel),
    )

    // Input: x = -2, width = 10 * 0.45 / 2
    caption(-2 + 5 * 0.45, 6, "01 / Imagem")
    caption(-2 + 5 * 0.45, 0., "10 × 10 × 3", color: alloy)

    line((3.2, 2.6), (4.7, 2.6), stroke: 1.3pt + volta, mark: (end: ">"))

    // ----------------------------------------------
    // 02 / FILTERS — 3 × 3 × 3 × 2
    // Two independent kernel volumes
    // ----------------------------------------------
    let kx = 5.0
    let ky = 2.0
    let kcell = 0.32
    let kdx = 0.11
    let kdy = 0.11
    let ksize = 3 * kcell
    let depth = 0.11

    // Helper: draw one 3D kernel volume
    let kernel-volume = (x, y) => {
      // Three channel slices
      feature-map(
        x + 2 * kdx,
        y + 2 * kdy,
        3,
        3,
        color: blue-channel,
        cell: kcell,
      )
      feature-map(
        x + kdx,
        y + kdy,
        3,
        3,
        color: green-channel,
        cell: kcell,
      )
      feature-map(
        x,
        y,
        3,
        3,
        color: red-channel,
        cell: kcell,
      )

      // Volume edges
      line((x, y + ksize), (x + 2 * depth, y + ksize + 2 * depth), stroke: 1pt + ink)
      line((x + 2 * depth, y + ksize + 2 * depth), (x + ksize + 2 * depth, y + ksize + 2 * depth), stroke: 1pt + ink)
      line((x + ksize, y + ksize), (x + ksize + 2 * depth, y + ksize + 2 * depth), stroke: 1pt + ink)
      line((x + ksize, y + ksize), (x, y + ksize), stroke: 1pt + ink)

      line((x + ksize, y), (x + ksize + 2 * depth, y + 2 * depth), stroke: 1pt + ink)
      line((x + ksize, y), (x + ksize, y + ksize), stroke: 1pt + ink)
      line((x + ksize, y), (x, y), stroke: 1pt + ink)
      line((x, y), (x, y + ksize), stroke: 1pt + ink)
      line((x + ksize + 2 * depth, y + 2 * depth), (x + ksize + 2 * depth, y + ksize + 2 * depth), stroke: 1pt + ink)

      // Hidden edges
      line((x, y), (x + 2 * depth, y + 2 * depth), stroke: 2pt + graphite, dash: "dashed")
      line(
        (x + 2 * depth, y + 2 * depth),
        (x + ksize + 2 * depth, y + 2 * depth),
        stroke: 2pt + graphite,
        dash: "dashed",
      )
      line(
        (x + 2 * depth, y + 2 * depth),
        (x + 2 * depth, y + ksize + 2 * depth),
        stroke: 2pt + graphite,
        dash: "dashed",
      )
    }

    // Draw two independent filters
    kernel-volume(kx + 0.35, ky + 0.3)
    kernel-volume(kx, ky)

    caption(5 + (3 * 0.42 + 2 * 0.14) / 2, 4.6, "02 / Filtros")
    caption(4.9 + (3 * 0.42 + 2 * 0.14) / 2, 0.9, "3 × 3 × 3 × 2", color: alloy)

    line((7.4, 2.6), (9.0, 2.6), stroke: 1.3pt + volta, mark: (end: ">"))

    // ----------------------------------------------
    // 03 / OUTPUT  4 × 4 × 5
    // ----------------------------------------------
    feature-stack(
      9.7,
      1,
      8,
      8,
      2,
      (alloy, alloy),
      cell: 0.45,
      dx: 0.14,
      dy: 0.14,
    )
    caption(9.7 + (8 * 0.45 + 0.14) / 2, 5.4, "03 / Saida")
    caption(9.6 + (8 * 0.45 + 0.14) / 2, 0.2, "8 × 8 × 2", color: alloy)
  })
}
