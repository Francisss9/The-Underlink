# raycast.awk — minimal Doom/Wolfenstein-style raycaster renderer.
#
# Reads a rectangular ASCII map from stdin ('#' = wall, '.' = floor)
# and renders one first-person frame to stdout based on the player
# state passed in via -v variables:
#   PX, PY   player position (map cell coordinates, float)
#   PA       player facing angle in radians (0 = +x/east)
#   FOV      field of view in radians
#   SW, SH   output width/height in characters
#   DEPTH    max ray travel distance, in map cells
#
# Walls are shaded by distance (closer = denser character), giving a
# cheap sense of depth without any textures or color.

BEGIN {
    mh = 0
    while ((getline line) > 0) {
        mh++
        mw = length(line)
        for (c = 1; c <= mw; c++) {
            MAP[mh - 1, c - 1] = substr(line, c, 1)
        }
    }
    MW = mw
    MH = mh

    px = PX + 0; py = PY + 0; pa = PA + 0
    fov = FOV + 0
    W = SW + 0; H = SH + 0
    depth = DEPTH + 0
    step = 0.05

    shades = " .:-=+*#%@"
    nshades = length(shades)

    for (x = 0; x < W; x++) {
        rayAngle = (pa - fov / 2.0) + (x / (W + 0.0)) * fov
        eyeX = cos(rayAngle)
        eyeY = sin(rayAngle)

        dist = 0
        hit = 0
        while (hit == 0 && dist < depth) {
            dist += step
            tx = int(px + eyeX * dist)
            ty = int(py + eyeY * dist)
            if (tx < 0 || ty < 0 || tx >= MW || ty >= MH) {
                hit = 1; dist = depth
            } else if (MAP[ty, tx] == "#") {
                hit = 1
            }
        }

        # correct fisheye distortion
        dist = dist * cos(rayAngle - pa)
        if (dist < 0.0001) dist = 0.0001

        ceil = int(H / 2.0 - H / dist)
        flor = H - ceil
        if (ceil < 0) ceil = 0
        if (flor > H) flor = H

        shadeIdx = int((1 - dist / depth) * (nshades - 1))
        if (shadeIdx < 0) shadeIdx = 0
        if (shadeIdx >= nshades) shadeIdx = nshades - 1
        wallChar = substr(shades, shadeIdx + 1, 1)

        for (y = 0; y < H; y++) {
            if (y < ceil) SCREEN[y, x] = " "
            else if (y < flor) SCREEN[y, x] = wallChar
            else SCREEN[y, x] = "."
        }
    }

    for (y = 0; y < H; y++) {
        outline = ""
        for (x = 0; x < W; x++) outline = outline SCREEN[y, x]
        print outline
    }
}
