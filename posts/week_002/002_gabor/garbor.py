from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap
from matplotlib.patches import Rectangle, FancyArrowPatch
from matplotlib.animation import FuncAnimation, PillowWriter
from scipy.ndimage import convolve
from PIL import Image

# ── Editorial Blueprint Palette ───────────────────────────────────────────────
PAPER    = "#F7F6F0"
ALLOY    = "#EAE7DC"
INK      = "#111214"
VOLTA    = "#FFD100"
GRAPHITE = "#5C626E"


import numpy as np
import colour
from matplotlib.colors import LinearSegmentedColormap

def hex_to_oklab(hex_color: str) -> np.ndarray:
    rgb = np.array([int(hex_color[i:i+2], 16) / 255.0 for i in (1, 3, 5)])
    return colour.XYZ_to_Oklab(colour.sRGB_to_XYZ(rgb))


def oklab_to_srgb(lab: np.ndarray) -> np.ndarray:
    rgb = colour.XYZ_to_sRGB(colour.Oklab_to_XYZ(lab))
    return np.clip(rgb, 0.0, 1.0)


def make_oklab_colormap(name: str, stops: list[tuple[float, str]], N: int = 512) -> LinearSegmentedColormap:
    positions = np.array([p for p, _ in stops], dtype=float)
    colors = np.array([hex_to_oklab(c) for _, c in stops], dtype=float)

    samples = np.linspace(0.0, 1.0, N)
    lab = np.column_stack([
        np.interp(samples, positions, colors[:, i])
        for i in range(3)
    ])

    rgb_samples = oklab_to_srgb(lab)
    return LinearSegmentedColormap.from_list(name, rgb_samples, N=N)

BLUEPRINT_HEAT = make_oklab_colormap(
    "blueprint_heat",
    [
        (0.00, INK),
        (0.35, GRAPHITE),
        (0.78, VOLTA),
        (1.00, PAPER),
    ],
)


plt.rcParams.update({
    "figure.facecolor": PAPER,
    "savefig.facecolor": PAPER,
    "axes.facecolor": ALLOY,
    "axes.edgecolor": INK,
    "axes.linewidth": 1.0,
    "text.color": INK,
    "axes.titlecolor": INK,
    "xtick.color": GRAPHITE,
    "ytick.color": GRAPHITE,
    "font.family": "sans-serif",
    "font.sans-serif": ["Space Grotesk", "Inter", "DejaVu Sans"],
    "font.monospace": ["JetBrains Mono", "DejaVu Sans Mono"],
    "savefig.bbox": "tight",
})

# Diverging colormap for Gabor kernel: negative (INK) -> zero (PAPER) -> positive (VOLTA)
BLUEPRINT_DIV = LinearSegmentedColormap.from_list(
    "blueprint_div", [INK, PAPER, VOLTA], N=256
)

# ── Parameters ────────────────────────────────────────────────────────────────
OUTPUT_GIF  = "gabor_orientation_sweep.gif"
FACE_PATH   = Path("resources/marie_bashkirtseff.jpg")   # Drop your public-domain portrait here (cropped square)
IMG_SIZE    = 256                # Resolution for crisp facial details

KERNEL_SIZE = 31                 # Odd kernel size
SIGMA       = 4.2                # Gaussian envelope std dev
WAVELENGTH  = 9.0                # Sinusoidal wavelength (lambda)
GAMMA       = 0.65               # Spatial aspect ratio (ellipticity)

FPS         = 15
N_FRAMES    = 90                 # 0° -> 180° in 2° increments (6.0s smooth loop)
DPI         = 100


# ── Load & Prepare Face Test Signal ───────────────────────────────────────────
def load_face_signal(path: Path, size: int = 256) -> np.ndarray:
    """
    Loads a portrait image, center-crops to a square, converts to normalized
    grayscale [0, 1], and applies gentle contrast stretching.
    """
    if not path.exists():
        raise FileNotFoundError(
            f"Place a square-cropped public-domain portrait at '{path.resolve()}'."
        )

    im = Image.open(path).convert("L")
    w, h = im.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    im = im.crop((left, top, left + side, top + side)).resize(
        (size, size), Image.Resampling.LANCZOS
    )

    arr = np.asarray(im, dtype=np.float64) / 255.0
    # Gentle percentile contrast stretch so edges read cleanly on mobile
    p2, p98 = np.percentile(arr, (2, 98))
    arr = np.clip((arr - p2) / max(p98 - p2, 1e-6), 0.0, 1.0)
    return arr


face = load_face_signal(FACE_PATH, IMG_SIZE)


# ── 2D Gabor Kernel & Precomputation ──────────────────────────────────────────
def make_gabor_kernel(size: int, sigma: float, theta: float, lambd: float, gamma: float) -> np.ndarray:
    """Zero-mean 2D real Gabor kernel (even/cosine phase)."""
    r = size // 2
    y, x = np.mgrid[-r:r + 1, -r:r + 1].astype(np.float64)

    x_theta = x * np.cos(theta) + y * np.sin(theta)
    y_theta = -x * np.sin(theta) + y * np.cos(theta)

    envelope = np.exp(-(x_theta**2 + (gamma**2) * (y_theta**2)) / (2.0 * sigma**2))
    carrier = np.cos(2.0 * np.pi * x_theta / lambd)

    kernel = envelope * carrier
    kernel -= kernel.mean()  # Enforce zero DC response on flat regions
    kernel /= np.linalg.norm(kernel)
    return kernel


angles_deg = np.linspace(0.0, 180.0, N_FRAMES, endpoint=False)
kernels = []
responses = []

for deg in angles_deg:
    theta = np.deg2rad(deg)
    k = make_gabor_kernel(KERNEL_SIZE, SIGMA, theta, WAVELENGTH, GAMMA)
    # Energy magnitude |I * g| highlights oriented structures clearly regardless of polarity
    resp = np.abs(convolve(face, k, mode="reflect"))
    kernels.append(k)
    responses.append(resp)

responses = np.array(responses)
# Normalize response globally across all angles so intensity comparisons stay honest
resp_vmax = np.percentile(responses, 99.3)
responses = np.clip(responses / max(resp_vmax, 1e-6), 0.0, 1.0)
kernel_abs_max = max(np.max(np.abs(k)) for k in kernels)


# ── Editorial Blueprint Figure Layout ─────────────────────────────────────────
fig = plt.figure(figsize=(10, 10), facecolor=PAPER)

# Signature viewfinder frame
fig.add_artist(Rectangle(
    (0.025, 0.025), 0.95, 0.95,
    transform=fig.transFigure,
    fill=False, edgecolor=ALLOY,
    linewidth=1.0, zorder=0
))

# Header tag
fig.text(
    0.075, 0.925, "Week 02 / Post 02",
    fontsize=9, fontweight="bold",
    color=INK, family="monospace",
    bbox=dict(facecolor=VOLTA, edgecolor="none", boxstyle="square,pad=0.45")
)

fig.text(
    0.075, 0.845,
    "Filtros de Gabor",
    fontsize=22, fontweight="bold",
    color=INK
)

#fig.text(
#    0.075, 0.835,
#    "Seletividade de orientação e frequência espacial (0° → 180°).",
#    fontsize=10, color=GRAPHITE
#)

fig.add_artist(plt.Line2D(
    [0.075, 0.925], [0.805, 0.805],
    transform=fig.transFigure,
    color=INK, linewidth=1.5
))

# Equation strip below header
fig.text(
    0.50, 0.755,
    r"$g(x,y;\,\lambda,\theta,\sigma,\gamma)"
    r"=\exp\!\left(-\dfrac{x'^2+\gamma^2 y'^2}{2\sigma^2}\right)"
    r"\cos\!\left(\dfrac{2\pi x'}{\lambda}\right)$",
    ha="center", va="center", fontsize=11.5, color=GRAPHITE
)

# ── 3-Column Axes Geometry (Vertically Centered) ──────────────────────────────
# Col 1: Input face | Col 2: Sweeping Gabor kernel | Col 3: Live filtered response
ax_in   = fig.add_axes([0.075, 0.285, 0.310, 0.310])
ax_kern = fig.add_axes([0.425, 0.350, 0.150, 0.150])
ax_out  = fig.add_axes([0.615, 0.285, 0.310, 0.310])

for ax in (ax_in, ax_kern, ax_out):
    ax.set_facecolor(ALLOY)
    ax.set_xticks([])
    ax.set_yticks([])
    for spine in ax.spines.values():
        spine.set_edgecolor(INK)
        spine.set_linewidth(1.0)

# Column 1: Static Input Portrait
ax_in.imshow(face, cmap="gray", vmin=0, vmax=1, interpolation="bilinear")
ax_in.set_title("01 / ENTRADA", loc="left", fontsize=8.5, fontweight="bold", color=GRAPHITE, pad=7)

# Column 2: Rotating Gabor Kernel
im_kern = ax_kern.imshow(
    kernels[0], cmap=BLUEPRINT_DIV,
    vmin=-kernel_abs_max, vmax=kernel_abs_max,
    interpolation="nearest"
)
title_kern = ax_kern.set_title(
    "02 / KERNEL · θ=000°", loc="center",
    fontsize=8.5, fontweight="bold", color=INK, family="monospace", pad=7
)

# Parameter caption under kernel
fig.text(
    0.50, 0.315,
    f"λ={WAVELENGTH:g}px · σ={SIGMA:g}\nγ={GAMMA:g} · {KERNEL_SIZE}×{KERNEL_SIZE}",
    ha="center", va="top", fontsize=8, color=GRAPHITE, family="monospace"
)

# Column 3: Filtered Output
im_out = ax_out.imshow(responses[0], cmap=BLUEPRINT_HEAT, vmin=0, vmax=1, interpolation="bilinear")
ax_out.set_title("03 / RESPOSTA |I * g|", loc="left", fontsize=8.5, fontweight="bold", color=GRAPHITE, pad=7)

# Schematic flow arrows between columns
arrow_1_2 = FancyArrowPatch(
    (0.391, 0.425), (0.419, 0.425),
    transform=fig.transFigure,
    arrowstyle="-|>,head_length=4.5,head_width=3",
    color=INK, linewidth=1.3
)
arrow_2_3 = FancyArrowPatch(
    (0.581, 0.425), (0.609, 0.425),
    transform=fig.transFigure,
    arrowstyle="-|>,head_length=4.5,head_width=3",
    color=INK, linewidth=1.3
)
fig.add_artist(arrow_1_2)
fig.add_artist(arrow_2_3)

# Footer / live status
status = fig.text(
    0.075, 0.065, "INICIANDO VARREDURA ANGULAR...",
    fontsize=8, color=GRAPHITE, family="monospace"
)
fig.text(
    0.925, 0.065, "@paulo-rozatto",
    ha="right", fontsize=8, color=GRAPHITE,
    family="monospace"
)

# Progress track
# progress_bg = Rectangle(
#     (0.075, 0.075), 0.85, 0.006,
#     transform=fig.transFigure,
#     facecolor=ALLOY, edgecolor="none", zorder=20
# )
# progress_fg = Rectangle(
#     (0.075, 0.075), 0.0, 0.006,
#     transform=fig.transFigure,
#     facecolor=VOLTA, edgecolor="none", zorder=21
# )
# fig.add_artist(progress_bg)
# fig.add_artist(progress_fg)


# ── Animation Loop ────────────────────────────────────────────────────────────
def describe_orientation(deg: float) -> str:
    """Annotate dominant facial features aligned with the current wave angle."""
    if deg < 18 or deg > 162:
        return "BORDAS VERTICAIS · nariz e contorno lateral"
    if 72 <= deg <= 108:
        return "BORDAS HORIZONTAIS · olhos, sobrancelhas e lábios"
    return "BORDAS OBLÍQUAS · maçãs do rosto e pálpebras"


def update(frame_idx: int):
    deg = angles_deg[frame_idx]
    im_kern.set_data(kernels[frame_idx])
    im_out.set_data(responses[frame_idx])

    title_kern.set_text(f"02 / KERNEL · θ={int(round(deg)):03d}°")

    progress = (frame_idx + 1) / N_FRAMES
    #progress_fg.set_width(0.85 * progress)

    feature_note = describe_orientation(deg)
    status.set_text(f"θ = {deg:05.1f}°   ·   {feature_note}")

    return [im_kern, im_out, title_kern, status, 0]


ani = FuncAnimation(
    fig,
    update,
    frames=N_FRAMES,
    interval=1000 / FPS,
    blit=False,
    repeat=True,
)

ani.save(
    OUTPUT_GIF,
    writer=PillowWriter(fps=FPS),
    dpi=DPI,
    savefig_kwargs={"facecolor": PAPER},
)

print(f"Saved: {Path(OUTPUT_GIF).resolve()}")