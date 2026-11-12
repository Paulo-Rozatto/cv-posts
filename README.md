# CV Posts — Editorial Blueprint Pipeline

A reproducible, code-as-design content pipeline for publishing twice-weekly visual explainers on **Computer Vision**, **Image Processing**, and **Deep Learning** across **LinkedIn** and **Bluesky** over a 6-month schedule (**26 weeks × 2 posts/week = 52 posts**).

Every visual—static diagrams, multi-page PDF carousels, and animated algorithm GIFs—is generated from version-controlled Python and Typst source files under a unified design system.

---

## Visual Identity: "Editorial Blueprint"

Inspired by classic signal-processing drafting sheets and the black-and-yellow colors of **Volta Redonda, RJ**, all media share a locked high-contrast palette and typography system (`1080 × 1350` `4:5` portrait for slides/carousels; `1:1` for animated GIFs).

| Token | Hex | Role |
| :--- | :--- | :--- |
| `paper` | `#F7F6F0` | Primary slide and plot canvas background |
| `alloy` | `#EAE7DC` | Secondary callout cards, matrix cells, plot surfaces |
| `ink` | `#111214` | Headlines, body text, vector arrows, axes |
| `volta` | `#FFD100` | Accent highlights, category badges, active kernels |
| `graphite` | `#5C626E` | Coordinate grids, captions, footer metadata |

* **Headings:** `Space Grotesk`
* **Body Copy:** `Inter`
* **Math, Tensor Shapes & Labels:** `JetBrains Mono`

---

## Repository Structure (26-Week Scalable Layout)

```text
cv-posts/
├── fonts/                          # Local .ttf typefaces for deterministic builds
│   ├── Inter-VariableFont_opsz,wght.ttf
│   ├── Inter-Italic-VariableFont_opsz,wght.ttf
│   ├── JetBrainsMono-VariableFont_wght.ttf
│   ├── JetBrainsMono-Italic-VariableFont_wght.ttf
│   └── SpaceGrotesk-VariableFont_wght.ttf
├── templates/
│   ├── blueprint.typ               # Locked Typst slide layout, palette & crop marks
│   └── blueprint_style.py          # Matching Matplotlib & Pillow styling
├── posts/
│   ├── week_001/
│   │   ├── <topic_a>/              # Weekly Post 1
│   │   │   ├── generate_plots.py   # Generates figures (.png) & animations (.gif)
│   │   │   ├── post.typ            # Slide / carousel layout importing blueprint.typ
│   │   │   └── copy.md             # (Optional) LinkedIn & Bluesky post drafts
│   │   └── <topic_b>/              # Weekly Post 2
│   │       ├── generate_plots.py
│   │       └── post.typ
│   ├── week_002/
│   │   ├── <topic_a>/
│   │   └── <topic_b>/
│   ├── ...
│   └── week_026/                   # Final week of the 6-month cycle
│       ├── <topic_a>/
│       └── <topic_b>/
├── pyproject.toml                  # Python dependencies managed by uv
├── uv.lock                         # Locked dependency versions
└── .gitignore
```

> **Note:** Rendered outputs (`*.pdf`, `*.png`, `*.gif`) inside `posts/` are excluded via `.gitignore` so the repository stays lightweight while remaining 100% reproducible from source.

---

## Prerequisites & Setup

1. **Install [Typst](https://github.com/typst/typst)** (`>= 0.15` for variable font support) and **[uv](https://docs.astral.sh/uv/)**.
2. **Sync the Python environment:**
   ```bash
   uv sync
   ```
3. *(Optional)* Install the **Tinymist Typst** extension in VS Code and add `"tinymist.fontPaths": ["./fonts"]` to your workspace settings for instant live previews.

---

## Build Workflow

### 1. Scaffold a New Post
Create a folder for the target week and topic slug:
```bash
mkdir -p posts/week_<NNN>/<topic_slug>
```
Inside `post.typ`, import the shared template from three levels up:
```typst
#import "../../../templates/blueprint.typ": *
```

### 2. Generate Figures & Animations (Python)
Run the post's script inside the `uv`-managed environment to produce high-DPI plots (for Typst embedding) and looping GIFs (for Bluesky/LinkedIn):
```bash
uv run posts/week_<NNN>/<topic_slug>/generate_plots.py
```

### 3. Compile Slides & Carousels (Typst)
Export a multi-page PDF carousel for LinkedIn or individual PNG slides (`{p}` expands to page number) for Bluesky:

```bash
# LinkedIn PDF Carousel
typst compile --font-path ./fonts posts/week_<NNN>/<topic_slug>/post.typ posts/week_<NNN>/<topic_slug>/post.pdf

# High-Res PNG Slides (Bluesky / Single-Image Posts)
typst compile --font-path ./fonts posts/week_<NNN>/<topic_slug>/post.typ posts/week_<NNN>/<topic_slug>/slide-{p}.png --ppi 288
```

---

## Content Pillars

Posts rotate evenly across four categories throughout the 26-week schedule:

* **`[IP]` Classical Image Processing & Visual Math:** Fourier phase vs. magnitude, integral images, Canny hysteresis, seam carving, bilateral filtering, watershed, homography & RANSAC.
* **`[DL]` Deep Learning Architectures & Efficiency:** Depthwise separable convolutions, soft routing / MoE, U-Net skip connections, dilated convolutions, focal & dice loss, FlashAttention, quantization.
* **`[App]` Applied CV (Remote Sensing, Pose & Spatial AI):** Satellite image time series (SITS), spectral indices, SAR + optical fusion, 2D-to-3D human pose lifting, 3D Gaussian splatting, CV for physical rehabilitation.
* **`[Data]` Data-Centric AI & CV Phenomena:** Shortcut learning, interactive segmentation & annotation workflows, texture vs. shape bias, spatial/temporal data leakage, mAP thresholds, Grad-CAM pitfalls.