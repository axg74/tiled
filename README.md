# Tiled Tilemaps

A basic idea for loading and rendering Tiled tilemaps for retro styled 2D games in BlitzMAX NG.

- loads a Tiled TMX tilemap file and extract all data like
    - map-size (width & height in tiles)
    - layer-name
    - tile-layer data (tile-IDs)
    - loads the TSX file from the TMX file
        - tile-size (width & heihgt in pixel)
        - tilesheet filename
        - calculates a position table for each tile of the tilesheet
        - loads the tilesheet image (per map one tileset at the moment, only)

Feel free to modify it for your own needs.
