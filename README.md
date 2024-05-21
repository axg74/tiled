# Tiled Tilemaps

A basic idea for loading and rendering Tiled tilemaps for retro styled 2D games in BlitzMAX NG.

- load a Tiled TMX tilemap file and extract all data like
    - map-size (width & height in tiles)
    - layer-name
    - tile-layer data (tile-IDs)
    - load the TSX file from the TMX file
        - tile-size (width & heihgt in pixel)
        - tilesheet filename
        - calculates a position table for each tile of the tilesheet

Feel free to modify it for your needs.
