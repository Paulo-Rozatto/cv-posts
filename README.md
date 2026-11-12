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

# 6-Month Content Schedule (26 Weeks · 52 Posts)

* **Cadence:** 2 posts/week (recommended: **Tuesday** & **Thursday**)
* **Platforms:** LinkedIn (PDF Carousel / High-Res PNG) & Bluesky (PNG / Looping GIF)
* **Visual Identity:** Editorial Blueprint (`#F7F6F0` / `#111214` / `#FFD100`)

---

## Batch 1 — Foundation & Core Intuition (Weeks 1–4)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 01 | `week_001` | `[IP]` | 2D Fourier Phase vs. Magnitude | `posts/week_001/fourier` | 2-Slide PDF + Swap GIF |
| [ ] | 02 | `week_001` | `[DL]` | Depthwise Separable Convolutions | `posts/week_001/depthwise_conv` | CeTZ Tensor Diagram PNG |
| [ ] | 03 | `week_002` | `[App]` | Satellite Image Time Series (SITS) vs. Video | `posts/week_002/sits_vs_video` | Timeline Comparison PDF |
| [ ] | 04 | `week_002` | `[Data]` | Shortcut Learning ("Clever Hans" in Vision) | `posts/week_002/shortcut_learning` | Saliency Overlay PNG |
| [ ] | 05 | `week_003` | `[IP]` | Integral Images (Summed-Area Tables) | `posts/week_003/integral_images` | 4-Corner Lookup GIF |
| [ ] | 06 | `week_003` | `[DL]` | Focal Loss & Extreme Class Imbalance | `posts/week_003/focal_loss` | Loss Curve Plot + Math PDF |
| [ ] | 07 | `week_004` | `[App]` | 2D-to-3D Human Pose Lifting | `posts/week_004/pose_lifting_3d` | Projection Ray Diagram PNG |
| [ ] | 08 | `week_004` | `[Data]` | Why Dataset Annotation Is the Real Bottleneck | `posts/week_004/annotation_bottleneck` | 2-Slide Workflow PDF |

---

## Batch 2 — Edges, Routing & Geometry (Weeks 5–9)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 09 | `week_005` | `[IP]` | Sobel vs. Canny Edge Detection | `posts/week_005/sobel_vs_canny` | Hysteresis Step GIF |
| [ ] | 10 | `week_005` | `[DL]` | Soft Routing & Mixture-of-Experts (MoE) | `posts/week_005/soft_routing_moe` | CeTZ Routing Graph PNG |
| [ ] | 11 | `week_006` | `[App]` | Spectral Indices (NDVI/NDWI) vs. Learned Features | `posts/week_006/spectral_indices` | Band Reflectance Plot PNG |
| [ ] | 12 | `week_006` | `[Data]` | mAP@50 vs. mAP@50:95 Demystified | `posts/week_006/map_thresholds` | IoU Sweep GIF + PDF |
| [ ] | 13 | `week_007` | `[IP]` | Seam Carving (Content-Aware Resizing) | `posts/week_007/seam_carving` | Min-Energy Path GIF |
| [ ] | 14 | `week_007` | `[DL]` | Dilated (Atrous) Convolutions | `posts/week_007/dilated_convolutions` | Receptive Field Grid GIF |
| [ ] | 15 | `week_008` | `[App]` | NeRFs vs. 3D Gaussian Splatting | `posts/week_008/nerf_vs_gaussian_splatting` | 3-Slide Comparison PDF |
| [ ] | 16 | `week_008` | `[Data]` | Single-Layer Perceptron Convergence | `posts/week_008/perceptron_convergence` | Decision Boundary GIF |
| [ ] | 17 | `week_009` | `[IP]` | Bilateral Filtering vs. Gaussian Blur | `posts/week_009/bilateral_filter` | Edge-Preserving Profile PNG |

---

## Batch 3 — Multi-Scale & Spatiotemporal Models (Weeks 9–13)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 18 | `week_009` | `[DL]` | Why U-Net Skip Connections Endure | `posts/week_009/unet_skip_connections` | CeTZ Encoder-Decoder PNG |
| [ ] | 19 | `week_010` | `[App]` | The Temporal Exchanger Architecture | `posts/week_010/temporal_exchanger` | Channel Swap Diagram PNG |
| [ ] | 20 | `week_010` | `[Data]` | Texture Bias vs. Shape Bias | `posts/week_010/texture_vs_shape_bias` | Stylized Patch Comparison PDF |
| [ ] | 21 | `week_011` | `[IP]` | Watershed Segmentation as Topographical Flooding | `posts/week_011/watershed_segmentation` | Basin Flooding GIF |
| [ ] | 22 | `week_011` | `[DL]` | FlashAttention & GPU Memory Bandwidth | `posts/week_011/flash_attention` | HBM vs. SRAM Tiling PDF |
| [ ] | 23 | `week_012` | `[App]` | CV for Remote Physical Rehabilitation | `posts/week_012/cv_remote_rehab` | Keypoint Angle Telemetry PNG |
| [ ] | 24 | `week_012` | `[Data]` | Spatial & Temporal Data Leakage | `posts/week_012/spatiotemporal_leakage` | Tile Overlap Split PNG |
| [ ] | 25 | `week_013` | `[IP]` | Homography & RANSAC | `posts/week_013/homography_ransac` | Inlier Consensus GIF |
| [ ] | 26 | `week_013` | `[DL]` | Dice Loss vs. Cross-Entropy in Segmentation | `posts/week_013/dice_vs_cross_entropy` | Thin-Mask Gradient PDF |

---

## Batch 4 — Fusion, Attention & Attribution (Weeks 14–18)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 27 | `week_014` | `[App]` | Cloud Occlusion & SAR + Optical Fusion | `posts/week_014/sar_optical_fusion` | Dual-Sensor Pipeline PNG |
| [ ] | 28 | `week_014` | `[Data]` | Interactive Segmentation (Point & Box Prompts) | `posts/week_014/interactive_segmentation` | Prompt Refinement GIF |
| [ ] | 29 | `week_015` | `[IP]` | CLAHE (Adaptive Histogram Equalization) | `posts/week_015/clahe` | Tile Clipping Histogram PNG |
| [ ] | 30 | `week_015` | `[DL]` | Self-Attention as an Adaptive Filter | `posts/week_015/self_attention_filter` | Static vs. Dynamic Kernel PDF |
| [ ] | 31 | `week_016` | `[App]` | Epipolar Geometry & Stereo Matching | `posts/week_016/epipolar_stereo` | 1D Scanline Geometry PNG |
| [ ] | 32 | `week_016` | `[Data]` | Grad-CAM & Saliency Map Pitfalls | `posts/week_016/gradcam_pitfalls` | Sanity-Check Grid PNG |
| [ ] | 33 | `week_017` | `[IP]` | Morphological Opening, Closing & Top-Hat | `posts/week_017/morphological_ops` | Kernel Sweep GIF |
| [ ] | 34 | `week_017` | `[DL]` | Feature Pyramid Networks (FPN) | `posts/week_017/feature_pyramid_networks` | CeTZ Top-Down Pathway PNG |
| [ ] | 35 | `week_018` | `[App]` | Semantic vs. Instance vs. Panoptic Segmentation | `posts/week_018/segmentation_paradigms` | 3-Way Mask Comparison PDF |

---

## Batch 5 — Efficiency, Motion & Label Quality (Weeks 18–22)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 36 | `week_018` | `[Data]` | Active Learning for Visual Datasets | `posts/week_018/active_learning` | Uncertainty Sampling Loop PNG |
| [ ] | 37 | `week_019` | `[IP]` | Color Spaces Beyond RGB (CIELAB & HSV) | `posts/week_019/color_spaces` | Channel Decomposition PNG |
| [ ] | 38 | `week_019` | `[DL]` | Knowledge Distillation ("Dark Knowledge") | `posts/week_019/knowledge_distillation` | Temperature Softmax Plot PNG |
| [ ] | 39 | `week_020` | `[App]` | Optical Flow vs. Scene Flow | `posts/week_020/optical_vs_scene_flow` | 2D vs. 3D Vector Field PNG |
| [ ] | 40 | `week_020` | `[Data]` | Annotator Disagreement & Label Jitter | `posts/week_020/annotator_disagreement` | Boundary Variance PDF |
| [ ] | 41 | `week_021` | `[IP]` | Non-Local Means Denoising | `posts/week_021/non_local_means` | Patch-Matching Diagram PNG |
| [ ] | 42 | `week_021` | `[DL]` | Post-Training Quantization (FP32 to INT8) | `posts/week_021/post_training_quantization` | Activation Outlier Plot PDF |
| [ ] | 43 | `week_022` | `[App]` | Bridging Computer Vision & VR/AR | `posts/week_022/cv_vr_ar` | Spatial Anchor Pipeline PNG |
| [ ] | 44 | `week_022` | `[Data]` | Synthetic Data & Domain Randomization | `posts/week_022/synthetic_data` | Sim-to-Real Trade-Off PDF |

---

## Batch 6 — Advanced Spatial Priors & Scaling (Weeks 23–26)

| Done | # | Week | Pillar | Topic | Directory | Recommended Media |
| :---: | :---: | :--- | :--- | :--- | :--- | :--- |
| [ ] | 45 | `week_023` | `[IP]` | Distance Transforms on Binary Masks | `posts/week_023/distance_transforms` | Contour Isolation GIF |
| [ ] | 46 | `week_023` | `[DL]` | 2D Positional Embeddings & RoPE | `posts/week_023/positional_embeddings_2d` | Patch Coordinate Grid PNG |
| [ ] | 47 | `week_024` | `[App]` | Domain Shift Across Sensors & Seasons | `posts/week_024/domain_shift` | Feature Distribution Shift PNG |
| [ ] | 48 | `week_024` | `[Data]` | Foundation Models vs. Domain Specialists | `posts/week_024/foundation_vs_specialists` | Latency vs. Accuracy Matrix PDF |
| [ ] | 49 | `week_025` | `[IP]` | Anisotropic Diffusion (Perona–Malik) | `posts/week_025/anisotropic_diffusion` | PDE Smoothing Steps GIF |
| [ ] | 50 | `week_025` | `[DL]` | Test-Time Augmentation (TTA) Trade-Offs | `posts/week_025/test_time_augmentation` | Multi-Crop Latency Chart PNG |
| [ ] | 51 | `week_026` | `[App]` | Multi-Image Super-Resolution in Remote Sensing | `posts/week_026/multi_image_super_res` | Sub-Pixel Shift Alignment PNG |
| [ ] | 52 | `week_026` | `[Data]` | Dead ReLUs & Feature Collapse | `posts/week_026/dead_relus_collapse` | Channel Activation Heatmap PNG |