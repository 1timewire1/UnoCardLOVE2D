#!/usr/bin/env python3
"""Generate new card art for resource/, matching the visual language of the
existing front_*.png / dark_*.png cards (sourced from a Wikipedia Commons
UNO SVG - see the README's Acknowledgements).

Two templates, both derived from the existing cards:

- Wild-type cards (WILD_SWAP/WILD_PASS): a black card with the classic
  four-color wild pie in the center, and a white infographic icon on top of
  it (the same convention Mattel's own Add-On Pack wild cards use) instead
  of a plain white icon patch with no color cue. Corner icons are the same
  infographic, scaled down.
- Colored cards (SWAP1/REFRESH_HAND): the same template Reverse/Skip/+2
  already use - a solid-color card with a white oval and a same-color
  silhouette icon on top, one card per UNO color.

This does NOT try to reproduce Mattel's actual card designs - new mechanics
get their own original icons in the same visual language, both because we
don't have the original vector art to match pixel-for-pixel and to avoid
reproducing Mattel's proprietary card designs.

Requires: rsvg-convert (Debian/Ubuntu: apt install librsvg2-bin).

Usage: python3 tools/gen_cards.py [resource_dir]   (defaults to ./resource)
"""
import math
import os
import re
import subprocess
import sys

W, H = 121, 181
CX, CY = 60.5, 90.5
ROT = -22

OUTLINE = "#111111"
INSET_BLACK = "#000000"
WHITE = "#ffffff"

# Sampled directly from resource/front_kw.png's pie (the classic Wild card):
# clockwise from local top-left quadrant (pre-rotation): red, blue, green,
# yellow/orange.
PIE_RED = "#ff5555"
PIE_BLUE = "#5555ff"
PIE_GREEN = "#11aa11"
PIE_YELLOW = "#ffaa11"

# Sampled from resource/front_r+.png etc: the solid colors used for colored
# cards (matching the pie's red/green/yellow but a brighter, pure blue).
CARD_COLORS = {"r": "#ff5555", "b": "#5555ff", "g": "#11aa11", "y": "#ffaa11"}

PIE_RX, PIE_RY = 42, 25


def darken(hexcolor: str, factor: float = 0.5) -> str:
    """Matches the existing dark_*.png convention: every channel roughly
    halved (verified against the shipped assets - dark_r0.png's colors are
    front_r0.png's colors at ~0.5x, e.g. 255->127, 85->42)."""
    hexcolor = hexcolor.lstrip("#")
    r, g, b = (int(hexcolor[i:i + 2], 16) for i in (0, 2, 4))
    return f"#{int(r * factor):02x}{int(g * factor):02x}{int(b * factor):02x}"


def darken_svg(svg: str, factor: float = 0.5) -> str:
    return re.sub(r"#[0-9a-fA-F]{6}", lambda m: darken(m.group(0), factor), svg)


# --------------------------------------------------------------------------
# Wild-type template (WILD_SWAP / WILD_PASS): black card, four-color pie,
# white infographic on top.
# --------------------------------------------------------------------------

def wild_pie_svg(clip_id: str) -> str:
    """The classic four-color wild pie - no white plate this time, so it
    still reads as a normal wild card even where the icon doesn't cover it."""
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
    <ellipse cx="0" cy="0" rx="{PIE_RX}" ry="{PIE_RY}" fill="none" stroke="{OUTLINE}" stroke-width="1.5"/>'''


def wild_card_svg(icon_svg: str, corner_icon_svg: str, clip_id: str) -> str:
    """icon_svg/corner_icon_svg draw a WHITE infographic (with a thin black
    outline for contrast on any background) around (0, 0)."""
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">
  <rect x="2" y="2" width="{W - 4}" height="{H - 4}" rx="15" ry="15"
        fill="#ffffff" stroke="{OUTLINE}" stroke-width="3"/>
  <rect x="14" y="14" width="{W - 28}" height="{H - 28}" rx="11" ry="11"
        fill="{INSET_BLACK}"/>
  <g transform="translate({CX},{CY}) rotate({ROT})">
    {wild_pie_svg(clip_id)}
    {icon_svg}
  </g>
  <g transform="translate(28,34)">
    {corner_icon_svg}
  </g>
  <g transform="translate({W - 28},{H - 34}) rotate(180)">
    {corner_icon_svg}
  </g>
</svg>'''


def _fat_arrow(x_tail: float, x_tip: float, y: float, thickness: float, head_len: float, head_half: float) -> str:
    """A rounded-tail, pointed-head arrow along a horizontal line from
    x_tail to x_tip (x_tip may be left or right of x_tail)."""
    direction = 1 if x_tip > x_tail else -1
    x_shoulder = x_tip - direction * head_len
    th = thickness / 2

    return (f'<rect x="{min(x_tail, x_shoulder):.1f}" y="{y - th:.1f}" '
            f'width="{abs(x_shoulder - x_tail):.1f}" height="{thickness}" rx="{th:.1f}"/>'
            f'<polygon points="{x_shoulder:.1f},{y - head_half:.1f} {x_shoulder:.1f},{y + head_half:.1f} '
            f'{x_tip:.1f},{y:.1f}"/>')


def swap_icon(scale: float = 1.0) -> str:
    """Two opposite-pointing fat arrows (a generic bidirectional-exchange
    glyph), white with a thin black outline so it reads on both the pie and
    the black background."""
    s = scale
    top = _fat_arrow(30 * s, -18 * s, -13 * s, 11 * s, 13 * s, 9 * s)
    bottom = _fat_arrow(-30 * s, 18 * s, 13 * s, 11 * s, 13 * s, 9 * s)

    return f'<g fill="{WHITE}" stroke="{OUTLINE}" stroke-width="{2 * s:.1f}" stroke-linejoin="round">{top}{bottom}</g>'


def _ring_arrows(radius: float, n: int, span_deg: float, thickness: float,
                  head_len: float, head_half: float, start_deg: float = -90) -> str:
    """n arc segments evenly spaced around a full circle, each ending in an
    arrowhead - a segmented "cycle" ring (as opposed to one long arc)."""
    gap = 360 / n
    parts = []

    for i in range(n):
        start = math.radians(start_deg + i * gap)
        end = start + math.radians(span_deg)
        x1, y1 = radius * math.cos(start), radius * math.sin(start)
        x2, y2 = radius * math.cos(end), radius * math.sin(end)
        tangent = end + math.radians(90)
        hx, hy = math.cos(tangent), math.sin(tangent)
        px, py = -math.sin(tangent), math.cos(tangent)
        tipx, tipy = x2 + hx * head_len, y2 + hy * head_len
        base1x, base1y = x2 + px * head_half, y2 + py * head_half
        base2x, base2y = x2 - px * head_half, y2 - py * head_half

        parts.append(f'<path d="M {x1:.1f},{y1:.1f} A {radius:.1f},{radius:.1f} 0 0 1 {x2:.1f},{y2:.1f}" '
                      f'fill="none" stroke="{OUTLINE}" stroke-width="{thickness + 3:.1f}" stroke-linecap="butt"/>')
        parts.append(f'<path d="M {x1:.1f},{y1:.1f} A {radius:.1f},{radius:.1f} 0 0 1 {x2:.1f},{y2:.1f}" '
                      f'fill="none" stroke="{WHITE}" stroke-width="{thickness:.1f}" stroke-linecap="butt"/>')
        parts.append(f'<polygon points="{tipx:.1f},{tipy:.1f} {base1x:.1f},{base1y:.1f} {base2x:.1f},{base2y:.1f}" '
                      f'fill="{WHITE}" stroke="{OUTLINE}" stroke-width="1.2" stroke-linejoin="round"/>')

    return "".join(parts)


def pass_icon(scale: float = 1.0) -> str:
    """A full circle made of 4 discrete arrow segments (a segmented "cycle"
    ring), distinct from swap's two-arrow exchange glyph."""
    return _ring_arrows(radius=19 * scale, n=4, span_deg=62, thickness=8 * scale,
                         head_len=9 * scale, head_half=7 * scale)


CARDS = {}


def swap_corner() -> str:
    return swap_icon(scale=0.32)


def pass_corner() -> str:
    return pass_icon(scale=0.34)


CARDS["ksw"] = wild_card_svg(swap_icon(), swap_corner(), "pie-sw")  # Wild Swap Hands
CARDS["kph"] = wild_card_svg(pass_icon(), pass_corner(), "pie-ph")  # Wild Pass Hands


# --------------------------------------------------------------------------
# Colored template (SWAP1 / REFRESH_HAND): solid color card, white oval,
# same-color silhouette icon - exactly how Reverse/Skip/+2 already look.
# --------------------------------------------------------------------------

def colored_card_svg(icon_svg: str, corner_icon_svg: str, color: str) -> str:
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">
  <rect x="2" y="2" width="{W - 4}" height="{H - 4}" rx="15" ry="15"
        fill="{color}" stroke="{OUTLINE}" stroke-width="3"/>
  <g transform="translate({CX},{CY}) rotate({ROT})">
    <ellipse cx="0" cy="0" rx="{PIE_RX}" ry="{PIE_RY}" fill="{WHITE}" stroke="{OUTLINE}" stroke-width="1.5"/>
    {icon_svg}
  </g>
  <g transform="translate(20,26)">
    {corner_icon_svg}
  </g>
  <g transform="translate({W - 20},{H - 26}) rotate(180)">
    {corner_icon_svg}
  </g>
</svg>'''


def swap1_icon(color: str, scale: float = 1.0) -> str:
    """Two overlapping cards, one moving up and one moving down - "swap a
    single card" as opposed to Wild Swap Hands' whole-hand exchange loop."""
    s = scale

    def card(x, y, rot, fill):
        return (f'<rect x="{-9 * s:.1f}" y="{-13 * s:.1f}" width="{18 * s:.1f}" height="{26 * s:.1f}" '
                f'rx="{3 * s:.1f}" fill="{fill}" stroke="{OUTLINE}" stroke-width="{1.6 * s:.1f}" '
                f'transform="translate({x:.1f},{y:.1f}) rotate({rot})"/>')

    # Vertical arrows (drawn directly, since _fat_arrow is horizontal-only)
    def varrow(x, y_tail, y_tip):
        direction = 1 if y_tip > y_tail else -1
        head_len, head_half, thickness = 8 * s, 6 * s, 7 * s
        y_shoulder = y_tip - direction * head_len
        th = thickness / 2

        return (f'<rect x="{x - th:.1f}" y="{min(y_tail, y_shoulder):.1f}" width="{thickness:.1f}" '
                f'height="{abs(y_shoulder - y_tail):.1f}" rx="{th:.1f}"/>'
                f'<polygon points="{x - head_half:.1f},{y_shoulder:.1f} {x + head_half:.1f},{y_shoulder:.1f} '
                f'{x:.1f},{y_tip:.1f}"/>')

    return (f'<g fill="{WHITE}" stroke="{OUTLINE}" stroke-width="{1.6 * s:.1f}" stroke-linejoin="round">'
            f'{card(-9 * s, 6 * s, -10, WHITE)}{card(9 * s, -6 * s, -10, WHITE)}'
            f'</g>'
            f'<g fill="{color}" stroke="{OUTLINE}" stroke-width="{1.2 * s:.1f}" stroke-linejoin="round">'
            f'{varrow(-9 * s, 20 * s, 4 * s)}{varrow(9 * s, -20 * s, -4 * s)}'
            f'</g>')


def refresh_icon(color: str, scale: float = 1.0) -> str:
    """A stack of cards with a full circular arrow (2 arcs) around it -
    "discard your hand and draw the same number of new cards"."""
    s = scale
    stack = "".join(
        f'<rect x="{-10 * s:.1f}" y="{-13 * s + i * 2.5 * s:.1f}" width="{20 * s:.1f}" height="{16 * s:.1f}" '
        f'rx="{2.5 * s:.1f}" fill="{WHITE}" stroke="{OUTLINE}" stroke-width="{1.4 * s:.1f}"/>'
        for i in range(3)
    )
    # Radius kept within the oval's ry=25 (unlike pass_icon, this ring shares
    # the oval with a card stack, so it can't use the full height).
    ring = _ring_arrows(radius=14 * s, n=2, span_deg=140, thickness=5 * s,
                         head_len=5 * s, head_half=4 * s, start_deg=-70)
    # Recolor the ring to the card's own color (it was built for white-on-black).
    ring = ring.replace(OUTLINE, "#333333").replace(WHITE, color)

    return ring + stack


CARDS["rs1"] = colored_card_svg(swap1_icon(CARD_COLORS["r"]), swap1_icon(CARD_COLORS["r"], 0.34), CARD_COLORS["r"])
CARDS["bs1"] = colored_card_svg(swap1_icon(CARD_COLORS["b"]), swap1_icon(CARD_COLORS["b"], 0.34), CARD_COLORS["b"])
CARDS["gs1"] = colored_card_svg(swap1_icon(CARD_COLORS["g"]), swap1_icon(CARD_COLORS["g"], 0.34), CARD_COLORS["g"])
CARDS["ys1"] = colored_card_svg(swap1_icon(CARD_COLORS["y"]), swap1_icon(CARD_COLORS["y"], 0.34), CARD_COLORS["y"])

CARDS["rrf"] = colored_card_svg(refresh_icon(CARD_COLORS["r"]), refresh_icon(CARD_COLORS["r"], 0.34), CARD_COLORS["r"])
CARDS["brf"] = colored_card_svg(refresh_icon(CARD_COLORS["b"]), refresh_icon(CARD_COLORS["b"], 0.34), CARD_COLORS["b"])
CARDS["grf"] = colored_card_svg(refresh_icon(CARD_COLORS["g"]), refresh_icon(CARD_COLORS["g"], 0.34), CARD_COLORS["g"])
CARDS["yrf"] = colored_card_svg(refresh_icon(CARD_COLORS["y"]), refresh_icon(CARD_COLORS["y"], 0.34), CARD_COLORS["y"])


def render(svg_text: str, out_png: str) -> None:
    svg_path = out_png[:-4] + ".svg"
    with open(svg_path, "w") as f:
        f.write(svg_text)
    subprocess.run(["rsvg-convert", "-w", str(W), "-h", str(H), "-o", out_png, svg_path], check=True)
    os.remove(svg_path)
    print("wrote", out_png)


def main(resource_dir: str) -> None:
    os.makedirs(resource_dir, exist_ok=True)
    for code, front_svg in CARDS.items():
        render(front_svg, os.path.join(resource_dir, f"front_{code}.png"))
        render(darken_svg(front_svg), os.path.join(resource_dir, f"dark_{code}.png"))


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "resource")
