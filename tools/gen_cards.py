#!/usr/bin/env python3
"""Generate new card art for resource/, matching the visual language of the
existing front_*.png / dark_*.png cards (sourced from a Wikipedia Commons
UNO SVG - see the README's Acknowledgements): a white rounded card, a dark
outline, an inset rounded rect in the card's color (black for wild-type
cards), a big white rotated ellipse, a colored icon on the ellipse, and
small matching icons in two opposite corners.

This does NOT try to reproduce Mattel's actual card designs - new mechanics
get their own original icons in the same visual language, both because we
don't have the original vector art to match pixel-for-pixel and to avoid
reproducing Mattel's proprietary card designs.

Requires: rsvg-convert (Debian/Ubuntu: apt install librsvg2-bin).

Usage: python3 tools/gen_cards.py [resource_dir]   (defaults to ./resource)

To add a new card, add a CARDS entry below (see the Wild Swap Hands /
Wild Pass Hands examples) with a center icon and a small corner icon, both
drawn around (0, 0) in their own local coordinates.
"""
import os
import re
import subprocess
import sys

W, H = 121, 181
CX, CY = 60.5, 90.5
ROT = -22

OUTLINE = "#111111"
INSET_BLACK = "#000000"


def darken(hexcolor: str, factor: float = 0.5) -> str:
    """Matches the existing dark_*.png convention: every channel roughly
    halved (verified against the shipped assets - dark_r0.png's colors are
    front_r0.png's colors at ~0.5x, e.g. 255->127, 85->42)."""
    hexcolor = hexcolor.lstrip("#")
    r, g, b = (int(hexcolor[i:i + 2], 16) for i in (0, 2, 4))
    return f"#{int(r * factor):02x}{int(g * factor):02x}{int(b * factor):02x}"


def darken_svg(svg: str, factor: float = 0.5) -> str:
    return re.sub(r"#[0-9a-fA-F]{6}", lambda m: darken(m.group(0), factor), svg)


def card_svg(icon_svg: str, corner_icon_svg: str, inset_fill: str = INSET_BLACK) -> str:
    """icon_svg is drawn inside a group already translated to the card's
    center and rotated by ROT, so it should just draw around (0, 0) at
    roughly +-30 units. corner_icon_svg is drawn unrotated around (0, 0) at
    roughly +-9 units; it's placed in both corners (the bottom-right copy
    rotated 180 automatically)."""
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">
  <rect x="2" y="2" width="{W - 4}" height="{H - 4}" rx="15" ry="15"
        fill="#ffffff" stroke="{OUTLINE}" stroke-width="3"/>
  <rect x="14" y="14" width="{W - 28}" height="{H - 28}" rx="11" ry="11"
        fill="{inset_fill}"/>
  <g transform="translate({CX},{CY}) rotate({ROT})">
    <ellipse cx="0" cy="0" rx="42" ry="25" fill="#ffffff"/>
    {icon_svg}
  </g>
  <g transform="translate(16,24)">
    {corner_icon_svg}
  </g>
  <g transform="translate({W - 16},{H - 24}) rotate(180)">
    {corner_icon_svg}
  </g>
</svg>'''


def swap_icon(red: str = "#ff5555", blue: str = "#5555ff") -> str:
    """Two rounded-rect "cards" trading places, with arrowheads showing the
    exchange direction."""
    return f'''
    <g stroke="{OUTLINE}" stroke-width="2" stroke-linejoin="round">
      <rect x="-26" y="-15" width="22" height="30" rx="4" fill="{red}" transform="rotate(-8 -15 0)"/>
      <rect x="4" y="-15" width="22" height="30" rx="4" fill="{blue}" transform="rotate(8 15 0)"/>
    </g>
    <g fill="{OUTLINE}">
      <path d="M -2,-19 L 8,-19 L 8,-25 L 18,-15 L 8,-5 L 8,-11 L -2,-11 Z"/>
      <path d="M 2,19 L -8,19 L -8,25 L -18,15 L -8,5 L -8,11 L 2,11 Z"/>
    </g>'''


def swap_corner_icon() -> str:
    return f'''
    <g stroke="{OUTLINE}" stroke-width="1" stroke-linejoin="round">
      <rect x="-8" y="-5" width="7" height="10" rx="1.5" fill="#ff5555" transform="rotate(-8 -5 0)"/>
      <rect x="1" y="-5" width="7" height="10" rx="1.5" fill="#5555ff" transform="rotate(8 5 0)"/>
    </g>'''


def pass_icon(color: str = "#55aa55") -> str:
    """A circular arrow (rotate/cycle), evoking hands passing around the
    table - visually distinct from the swap icon's two-card exchange."""
    return f'''
    <g fill="none" stroke="{OUTLINE}" stroke-width="13" stroke-linecap="round">
      <path d="M 0,-24 A 24,24 0 1 1 -22,-11"/>
    </g>
    <g fill="none" stroke="{color}" stroke-width="9" stroke-linecap="round">
      <path d="M 0,-24 A 24,24 0 1 1 -22,-11"/>
    </g>
    <path d="M -22,-11 L -34,-11 L -28,-24 Z" fill="{color}" stroke="{OUTLINE}" stroke-width="2" stroke-linejoin="round"/>'''


def pass_corner_icon(color: str = "#55aa55") -> str:
    return f'''
    <g fill="none" stroke="{OUTLINE}" stroke-width="4" stroke-linecap="round">
      <path d="M 0,-7 A 7,7 0 1 1 -6.5,-3.3"/>
    </g>
    <g fill="none" stroke="{color}" stroke-width="2.2" stroke-linecap="round">
      <path d="M 0,-7 A 7,7 0 1 1 -6.5,-3.3"/>
    </g>
    <path d="M -6.5,-3.3 L -10.5,-3.3 L -8.5,-7.3 Z" fill="{color}" stroke="{OUTLINE}" stroke-width="0.8" stroke-linejoin="round"/>'''


# One entry per new card: the front SVG is built from card_svg(...); the
# dark variant is derived automatically by halving every color.
CARDS = {
    "ksw": card_svg(swap_icon(), swap_corner_icon()),   # Wild Swap Hands (Swap Pack)
    "kph": card_svg(pass_icon(), pass_corner_icon()),   # Wild Pass Hands (Swap Pack)
}


def render(svg_text: str, out_png: str) -> None:
    svg_path = out_png[:-4] + ".svg"
    with open(svg_path, "w") as f:
        f.write(svg_text)
    subprocess.run(["rsvg-convert", "-w", str(W), "-h", str(H), "-o", out_png, svg_path], check=True)
    print("wrote", out_png)


def main(resource_dir: str) -> None:
    os.makedirs(resource_dir, exist_ok=True)
    for code, front_svg in CARDS.items():
        render(front_svg, os.path.join(resource_dir, f"front_{code}.png"))
        render(darken_svg(front_svg), os.path.join(resource_dir, f"dark_{code}.png"))


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "resource")
