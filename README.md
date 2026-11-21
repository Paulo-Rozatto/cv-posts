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
typst compile --root . --font-path ./fonts posts/week_<NNN>/<topic_slug>/post.typ posts/week_<NNN>/<topic_slug>/post.pdf

# High-Res PNG Slides (Bluesky / Single-Image Posts)
typst compile --root . --font-path ./fonts posts/week_<NNN>/<topic_slug>/post.typ posts/week_<NNN>/<topic_slug>/slide-{p}.png --ppi 288
```

---

## Content Pillars

Posts rotate evenly across four categories throughout the 26-week schedule:

* **`[IP]` Classical Image Processing & Visual Math:** Fourier phase vs. magnitude, integral images, Canny hysteresis, seam carving, bilateral filtering, watershed, homography & RANSAC.
* **`[DL]` Deep Learning Architectures & Efficiency:** Depthwise separable convolutions, soft routing / MoE, U-Net skip connections, dilated convolutions, focal & dice loss, FlashAttention, quantization.
* **`[App]` Applied CV (Remote Sensing, Pose & Spatial AI):** Satellite image time series (SITS), spectral indices, SAR + optical fusion, 2D-to-3D human pose lifting, 3D Gaussian splatting, CV for physical rehabilitation.
* **`[Data]` Data-Centric AI & CV Phenomena:** Shortcut learning, interactive segmentation & annotation workflows, texture vs. shape bias, spatial/temporal data leakage, mAP thresholds, Grad-CAM pitfalls.

# 6-Month Content Schedule (26 Weeks · 52 Posts)

* **Cadence:** 2 posts/week (recommended: **Tuesday** & **Thursday**)
* **Platforms:** LinkedIn (PDF Carousel / High-Res PNG) & Bluesky (PNG / Looping GIF)
* **Visual Identity:** Editorial Blueprint (`#F7F6F0` / `#111214` / `#FFD100`)
* **Ordering logic:** each week is **one study unit → two posts**; prerequisites flow forward.

---

## Batch 1 — Kernels, Frequency & Convolution Mechanics (Weeks 1–5)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [x] | 01 | `week_001` | `[IP]` | Harr-like features | `posts/week_001/01_harr_like` | 4-Corner Lookup GIF |
| [x] | 02 | `week_001` | `[DL]` | Depthwise Separable Convolutions | `posts/week_001/02_depthwise` | CeTZ + Typst PDF |
| [ ] | 03 | `week_002` | `[IP]` | Bilateral Filtering vs. Gaussian Blur | `posts/week_002/bilateral_filter` | Edge-Preserving Profile PNG |
| [ ] | 04 | `week_002` | `[IP]` | Non-Local Means Denoising | `posts/week_002/non_local_means` | Patch-Matching Diagram PNG |
| [ ] | 05 | `week_003` | `[IP]` | 2D Fourier Phase vs. Magnitude | `posts/week_003/fourier` | 2-Slide PDF + Swap GIF |
| [ ] | 06 | `week_003` | `[DL]` | Self-Attention as an Adaptive Filter | `posts/week_003/self_attention_filter` | Static vs. Dynamic Kernel PDF |
| [ ] | 07 | `week_004` | `[IP]` | Sobel vs. Canny Edge Detection | `posts/week_004/sobel_vs_canny` | Hysteresis Step GIF |
| [ ] | 08 | `week_004` | `[IP]` | Anisotropic Diffusion (Perona–Malik) | `posts/week_004/anisotropic_diffusion` | PDE Smoothing Steps GIF |
| [ ] | 09 | `week_005` | `[DL]` | 2D Positional Embeddings & RoPE | `posts/week_005/positional_embeddings_2d` | Patch Coordinate Grid PNG |
| [ ] | 10 | `week_005` | `[DL]` | FlashAttention & GPU Memory Bandwidth | `posts/week_005/flash_attention` | HBM vs. SRAM Tiling PDF |

---

## Batch 2 — Receptive Fields & Segmentation (Weeks 6–10)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 11 | `week_006` | `[DL]` | Dilated (Atrous) Convolutions | `posts/week_006/dilated_convolutions` | Receptive Field Grid GIF |
| [ ] | 12 | `week_006` | `[DL]` | Feature Pyramid Networks (FPN) | `posts/week_006/feature_pyramid_networks` | CeTZ Top-Down Pathway PNG |
| [ ] | 13 | `week_007` | `[DL]` | Why U-Net Skip Connections Endure | `posts/week_007/unet_skip_connections` | CeTZ Encoder-Decoder PNG |
| [ ] | 14 | `week_007` | `[DL]` | Dice Loss vs. Cross-Entropy in Segmentation | `posts/week_007/dice_vs_cross_entropy` | Thin-Mask Gradient PDF |
| [ ] | 15 | `week_008` | `[IP]` | Morphological Opening, Closing & Top-Hat | `posts/week_008/morphological_ops` | Kernel Sweep GIF |
| [ ] | 16 | `week_008` | `[IP]` | Distance Transforms on Binary Masks | `posts/week_008/distance_transforms` | Contour Isolation GIF |
| [ ] | 17 | `week_009` | `[IP]` | Watershed Segmentation as Topographical Flooding | `posts/week_009/watershed_segmentation` | Basin Flooding GIF |
| [ ] | 18 | `week_009` | `[App]` | Semantic vs. Instance vs. Panoptic Segmentation | `posts/week_009/segmentation_paradigms` | 3-Way Mask Comparison PDF |
| [ ] | 19 | `week_010` | `[DL]` | Focal Loss & Extreme Class Imbalance | `posts/week_010/focal_loss` | Loss Curve Plot + Math PDF |
| [ ] | 20 | `week_010` | `[Data]` | mAP@50 vs. mAP@50:95 Demystified | `posts/week_010/map_thresholds` | IoU Sweep GIF + PDF |

---

## Batch 3 — Enhancement, Attribution & Dataset Bias (Weeks 11–13)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 21 | `week_011` | `[IP]` | CLAHE (Adaptive Histogram Equalization) | `posts/week_011/clahe` | Tile Clipping Histogram PNG |
| [ ] | 22 | `week_011` | `[IP]` | Color Spaces Beyond RGB (CIELAB & HSV) | `posts/week_011/color_spaces` | Channel Decomposition PNG |
| [ ] | 23 | `week_012` | `[Data]` | Grad-CAM & Saliency Map Pitfalls | `posts/week_012/gradcam_pitfalls` | Sanity-Check Grid PNG |
| [ ] | 24 | `week_012` | `[Data]` | Shortcut Learning ("Clever Hans" in Vision) | `posts/week_012/shortcut_learning` | Saliency Overlay PNG |
| [ ] | 25 | `week_013` | `[Data]` | Texture Bias vs. Shape Bias | `posts/week_013/texture_vs_shape_bias` | Stylized Patch Comparison PDF |
| [ ] | 26 | `week_013` | `[Data]` | Synthetic Data & Domain Randomization | `posts/week_013/synthetic_data` | Sim-to-Real Trade-Off PDF |

---

## Batch 4 — Geometry, 3D & Motion (Weeks 14–17)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 27 | `week_014` | `[IP]` | Homography & RANSAC | `posts/week_014/homography_ransac` | Inlier Consensus GIF |
| [ ] | 28 | `week_014` | `[App]` | Epipolar Geometry & Stereo Matching | `posts/week_014/epipolar_stereo` | 1D Scanline Geometry PNG |
| [ ] | 29 | `week_015` | `[App]` | 2D-to-3D Human Pose Lifting | `posts/week_015/pose_lifting_3d` | Projection Ray Diagram PNG |
| [ ] | 30 | `week_015` | `[App]` | CV for Remote Physical Rehabilitation | `posts/week_015/cv_remote_rehab` | Keypoint Angle Telemetry PNG |
| [ ] | 31 | `week_016` | `[App]` | NeRFs vs. 3D Gaussian Splatting | `posts/week_016/nerf_vs_gaussian_splatting` | 3-Slide Comparison PDF |
| [ ] | 32 | `week_016` | `[App]` | Bridging Computer Vision & VR/AR | `posts/week_016/cv_vr_ar` | Spatial Anchor Pipeline PNG |
| [ ] | 33 | `week_017` | `[App]` | Optical Flow vs. Scene Flow | `posts/week_017/optical_vs_scene_flow` | 2D vs. 3D Vector Field PNG |
| [ ] | 34 | `week_017` | `[App]` | The Temporal Exchanger Architecture | `posts/week_017/temporal_exchanger` | Channel Swap Diagram PNG |

---

## Batch 5 — Remote Sensing, Resolution & Domain Shift (Weeks 18–21)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 35 | `week_018` | `[App]` | Satellite Image Time Series (SITS) vs. Video | `posts/week_018/sits_vs_video` | Timeline Comparison PDF |
| [ ] | 36 | `week_018` | `[Data]` | Spatial & Temporal Data Leakage | `posts/week_018/spatiotemporal_leakage` | Tile Overlap Split PNG |
| [ ] | 37 | `week_019` | `[App]` | Spectral Indices (NDVI/NDWI) vs. Learned Features | `posts/week_019/spectral_indices` | Band Reflectance Plot PNG |
| [ ] | 38 | `week_019` | `[App]` | Cloud Occlusion & SAR + Optical Fusion | `posts/week_019/sar_optical_fusion` | Dual-Sensor Pipeline PNG |
| [ ] | 39 | `week_020` | `[App]` | Domain Shift Across Sensors & Seasons | `posts/week_020/domain_shift` | Feature Distribution Shift PNG |
| [ ] | 40 | `week_020` | `[DL]` | Test-Time Augmentation (TTA) Trade-Offs | `posts/week_020/test_time_augmentation` | Multi-Crop Latency Chart PNG |
| [ ] | 41 | `week_021` | `[App]` | Multi-Image Super-Resolution in Remote Sensing | `posts/week_021/multi_image_super_res` | Sub-Pixel Shift Alignment PNG |
| [ ] | 42 | `week_021` | `[IP]` | Seam Carving (Content-Aware Resizing) | `posts/week_021/seam_carving` | Min-Energy Path GIF |

---

## Batch 6 — Efficiency, Training Dynamics & Label Quality (Weeks 22–26)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 43 | `week_022` | `[DL]` | Knowledge Distillation ("Dark Knowledge") | `posts/week_022/knowledge_distillation` | Temperature Softmax Plot PNG |
| [ ] | 44 | `week_022` | `[Data]` | Foundation Models vs. Domain Specialists | `posts/week_022/foundation_vs_specialists` | Latency vs. Accuracy Matrix PDF |
| [ ] | 45 | `week_023` | `[DL]` | Soft Routing & Mixture-of-Experts (MoE) | `posts/week_023/soft_routing_moe` | CeTZ Routing Graph PNG |
| [ ] | 46 | `week_023` | `[DL]` | Post-Training Quantization (FP32 to INT8) | `posts/week_023/post_training_quantization` | Activation Outlier Plot PDF |
| [ ] | 47 | `week_024` | `[Data]` | Single-Layer Perceptron Convergence | `posts/week_024/perceptron_convergence` | Decision Boundary GIF |
| [ ] | 48 | `week_024` | `[Data]` | Dead ReLUs & Feature Collapse | `posts/week_024/dead_relus_collapse` | Channel Activation Heatmap PNG |
| [ ] | 49 | `week_025` | `[Data]` | Active Learning for Visual Datasets | `posts/week_025/active_learning` | Uncertainty Sampling Loop PNG |
| [ ] | 50 | `week_025` | `[Data]` | Why Dataset Annotation Is the Real Bottleneck | `posts/week_025/annotation_bottleneck` | 2-Slide Workflow PDF |
| [ ] | 51 | `week_026` | `[Data]` | Interactive Segmentation (Point & Box Prompts) | `posts/week_026/interactive_segmentation` | Prompt Refinement GIF |
| [ ] | 52 | `week_026` | `[Data]` | Annotator Disagreement & Label Jitter | `posts/week_026/annotator_disagreement` | Boundary Variance PDF |