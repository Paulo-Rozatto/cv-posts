from pathlib import Path
import matplotlib.pyplot as plt
from matplotlib import font_manager

# Editorial Blueprint Palette
PAPER    = "#F7F6F0"
ALLOY    = "#EAE7DC"
INK      = "#111214"
VOLTA    = "#FFD100"
GRAPHITE = "#5C626E"

def apply_blueprint_style():
    fonts_dir = Path(__file__).resolve().parent.parent / "fonts"
    for font_file in fonts_dir.rglob("*.ttf"):
        font_manager.fontManager.addfont(str(font_file))

    plt.rcParams.update({
        "figure.facecolor": PAPER,
        "axes.facecolor": ALLOY,
        "axes.edgecolor": INK,
        "axes.linewidth": 1.2,
        "axes.labelcolor": INK,
        "axes.titlecolor": INK,
        "axes.titleweight": "bold",
        "xtick.color": GRAPHITE,
        "ytick.color": GRAPHITE,
        "text.color": INK,
        "font.family": "sans-serif",
        "font.sans-serif": ["Space Grotesk", "Inter", "DejaVu Sans"],
        "savefig.facecolor": PAPER,
        "savefig.bbox": "tight",
        "savefig.pad_inches": 0.15,
    })