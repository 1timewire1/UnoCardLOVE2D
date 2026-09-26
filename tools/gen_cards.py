#!/usr/bin/env python3
"""Generate new card art for resource/, matching the visual language of the
existing front_*.png / dark_*.png cards (sourced from a Wikipedia Commons
UNO SVG - see the README's Acknowledgements): a white rounded card, a dark
outline, an inset rounded rect in the card's color (black for wild-type
cards), a big white/four-color rotated ellipse ("the pie"), and small
matching icons in two opposite corners.

New wild-type cards (see src/defs.lua's comment on why any new card must be
wild-type) keep the classic four-color pie so they still read as "wild" at a
glance, with a black-and-white infographic icon on a white plate over the
pie's center - the same convention Mattel's own Swap Pack/Add-On cards use
(a normal wild card face with the pie mostly covered by a monochrome icon).
The corner icons are that same monochrome infographic, scaled down, in place
of the standard corner mini-pie.

This does NOT try to reproduce Mattel's actual card designs - new mechanics
get their own original icons in the same visual language, both because we
don't have the original vector art to match pixel-for-pixel and to avoid
reproducing Mattel's proprietary card designs.

Requires: rsvg-convert (Debian/Ubuntu: apt install librsvg2-bin).

Usage: python3 tools/gen_cards.py [resource_dir]   (defaults to ./resource)

To add a new card, add a CARDS entry below (see the Wild Swap Hands /
Wild Pass Hands examples) with a center icon and a small corner icon, both
drawn around (0, 0) in their own local coordinates, and both monochrome
(black outline, white fill) so they read clearly on the white plate/black
background.
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

# Sampled directly from resource/front_kw.png's pie (the classic Wild card):
# clockwise from local top-left quadrant (pre-rotation): red, blue, green,
# yellow/orange.
PIE_RED = "#ff5555"
PIE_BLUE = "#5555ff"
PIE_GREEN = "#11aa11"
PIE_YELLOW = "#ffaa11"

PIE_RX, PIE_RY = 42, 25
PLATE_RX, PLATE_RY = 37, 22


def darken(hexcolor: str, factor: float = 0.5) -> str:
    """Matches the existing dark_*.png convention: every channel roughly
    halved (verified against the shipped assets - dark_r0.png's colors are
    front_r0.png's colors at ~0.5x, e.g. 255->127, 85->42)."""
    hexcolor = hexcolor.lstrip("#")
    r, g, b = (int(hexcolor[i:i + 2], 16) for i in (0, 2, 4))
    return f"#{int(r * factor):02x}{int(g * factor):02x}{int(b * factor):02x}"


def darken_svg(svg: str, factor: float = 0.5) -> str:
    return re.sub(r"#[0-9a-fA-F]{6}", lambda m: darken(m.group(0), factor), svg)


def pie_svg(clip_id: str) -> str:
    """The classic four-color wild pie plus a white "plate" on top, sized to
    leave a visible colored rim so the card still reads as wild even with
    most of the pie covered by an icon."""
    return f'''
    <clipPath id="{clip_id}">
      <ellipse cx="0" cy="0" rx="{PIE_RX}" ry="{PIE_RY}"/>
    </clipPath>
    <g clip-path="url(#{clip_id})">
      <rect x="-{PIE_RX}" y="-{PIE_RY}" width="{PIE_RX}" height="{PIE_RY}" fill="{PIE_RED}"/>
      <rect x="0" y="-{PIE_RY}" width="{PIE_RX}" height="{PIE_RY}" fill="{PIE_BLUE}"/>
      <rect x="-{PIE_RX}" y="0" width="{PIE_RX}" height="{PIE_RY}" fill="{PIE_YELLOW}"/>
      <rect x="0" y="0" width="{PIE_RX}" height="{PIE_RY}" fill="{PIE_GREEN}"/>
    </g>
    <ellipse cx="0" cy="0" rx="{PIE_RX}" ry="{PIE_RY}" fill="none" stroke="{OUTLINE}" stroke-width="1.5"/>
    <ellipse cx="0" cy="0" rx="{PLATE_RX}" ry="{PLATE_RY}" fill="#ffffff" stroke="{OUTLINE}" stroke-width="2"/>'''


def card_svg(icon_svg: str, corner_icon_svg: str, clip_id: str, inset_fill: str = INSET_BLACK) -> str:
    """icon_svg is drawn on the white plate, inside a group already
    translated to the card's center and rotated by ROT, so it should draw
    around (0, 0) at roughly +-30 units, monochrome (black outline, white
    fill) so the plate shows through as highlights. corner_icon_svg is the
    same infographic scaled down, drawn unrotated around (0, 0) at roughly
    +-9 units; it's placed in both corners (the bottom-right copy rotated
    180 automatically), offset enough to stay clear of the white border."""
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">
  <rect x="2" y="2" width="{W - 4}" height="{H - 4}" rx="15" ry="15"
        fill="#ffffff" stroke="{OUTLINE}" stroke-width="3"/>
  <rect x="14" y="14" width="{W - 28}" height="{H - 28}" rx="11" ry="11"
        fill="{inset_fill}"/>
  <g transform="translate({CX},{CY}) rotate({ROT})">
    {pie_svg(clip_id)}
    {icon_svg}
  </g>
  <g transform="translate(28,34)">
    {corner_icon_svg}
  </g>
  <g transform="translate({W - 28},{H - 34}) rotate(180)">
    {corner_icon_svg}
  </g>
</svg>'''


def swap_icon() -> str:
    """Two card-backs trading places along a circular two-arrow loop (a
    full loop reads as a two-way exchange), monochrome so it reads as an
    infographic over the wild pie rather than a colored illustration."""
    return f'''
    <g fill="none" stroke="{OUTLINE}" stroke-width="4" stroke-linecap="round">
      <path d="M -30,-6 A 30,30 0 0 1 20,-26"/>
      <path d="M 30,6 A 30,30 0 0 1 -20,26"/>
    </g>
    <path d="M 20,-33 L 30,-24 L 17,-19 Z" fill="{OUTLINE}"/>
    <path d="M -20,33 L -30,24 L -17,19 Z" fill="{OUTLINE}"/>
    <g stroke="{OUTLINE}" stroke-width="2" stroke-linejoin="round">
      <rect x="-25" y="-16" width="20" height="27" rx="3" fill="#ffffff" transform="rotate(-8 -15 -2)"/>
      <rect x="5" y="-11" width="20" height="27" rx="3" fill="#ffffff" transform="rotate(8 15 2)"/>
    </g>
    <g stroke="{OUTLINE}" stroke-width="1">
      <line x1="-21" y1="-9" x2="-9" y2="-9" transform="rotate(-8 -15 -2)"/>
      <line x1="-21" y1="-3" x2="-9" y2="-3" transform="rotate(-8 -15 -2)"/>
      <line x1="9" y1="-4" x2="21" y2="-4" transform="rotate(8 15 2)"/>
      <line x1="9" y1="2" x2="21" y2="2" transform="rotate(8 15 2)"/>
    </g>'''


def swap_corner_icon() -> str:
    return f'''
    <g fill="none" stroke="{OUTLINE}" stroke-width="1.4" stroke-linecap="round">
      <path d="M -9,-2 A 9,9 0 0 1 6,-8"/>
      <path d="M 9,2 A 9,9 0 0 1 -6,8"/>
    </g>
    <path d="M 6,-10 L 9.5,-7 L 5,-5 Z" fill="{OUTLINE}"/>
    <path d="M -6,10 L -9.5,7 L -5,5 Z" fill="{OUTLINE}"/>
    <g stroke="{OUTLINE}" stroke-width="0.8" stroke-linejoin="round">
      <rect x="-8" y="-5" width="6.5" height="9" rx="1" fill="#ffffff" transform="rotate(-8 -5 -1)"/>
      <rect x="1.5" y="-4" width="6.5" height="9" rx="1" fill="#ffffff" transform="rotate(8 5 1)"/>
    </g>'''


def pass_icon() -> str:
    """A single stack of cards with one curved arrow going around it in one
    direction - a one-way hand-off, visually distinct from swap's two-way
    loop."""
    return f'''
    <g fill="none" stroke="{OUTLINE}" stroke-width="4" stroke-linecap="round">
      <path d="M 0,-30 A 30,30 0 1 1 -26,-15"/>
    </g>
    <path d="M -26,-15 L -38,-15 L -32,-28 Z" fill="{OUTLINE}"/>
    <g stroke="{OUTLINE}" stroke-width="2" stroke-linejoin="round">
      <rect x="-19" y="-4" width="26" height="34" rx="3" fill="#ffffff" transform="translate(-4,-4)"/>
      <rect x="-19" y="-4" width="26" height="34" rx="3" fill="#ffffff"/>
    </g>
    <g stroke="{OUTLINE}" stroke-width="1">
      <line x1="-15" y1="4" x2="3" y2="4"/>
      <line x1="-15" y1="12" x2="3" y2="12"/>
      <line x1="-15" y1="20" x2="3" y2="20"/>
    </g>'''


def pass_corner_icon() -> str:
    return f'''
    <g fill="none" stroke="{OUTLINE}" stroke-width="1.4" stroke-linecap="round">
      <path d="M 0,-9 A 9,9 0 1 1 -7.8,-4.5"/>
    </g>
    <path d="M -7.8,-4.5 L -11.8,-4.5 L -9.8,-8.5 Z" fill="{OUTLINE}"/>
    <g stroke="{OUTLINE}" stroke-width="0.8" stroke-linejoin="round">
      <rect x="-6" y="-1" width="8" height="10.5" rx="1" fill="#ffffff" transform="translate(-1.2,-1.2)"/>
      <rect x="-6" y="-1" width="8" height="10.5" rx="1" fill="#ffffff"/>
    </g>
    <g stroke="{OUTLINE}" stroke-width="0.5">
      <line x1="-4.5" y1="1.5" x2="1" y2="1.5"/>
      <line x1="-4.5" y1="4.2" x2="1" y2="4.2"/>
    </g>'''


# One entry per new card: the front SVG is built from card_svg(...); the
# dark variant is derived automatically by halving every color.
CARDS = {
    "ksw": card_svg(swap_icon(), swap_corner_icon(), "pie-sw"),  # Wild Swap Hands (Swap Pack)
    "kph": card_svg(pass_icon(), pass_corner_icon(), "pie-ph"),  # Wild Pass Hands (Swap Pack)
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
