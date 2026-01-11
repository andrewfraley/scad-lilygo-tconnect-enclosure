# LillyGo T-Connect ESP32 Enclosure

3D printable enclosure for the LillyGo T-Connect ESP32 board. Tall version features RJ45 modules mounted inverted in the lid for a more compact design.

**LilyGo T-connect:** https://amzn.to/3Laaei9

**RJ45 Modules:** https://amzn.to/49rEJbe

## Getting Started

1. **Download OpenSCAD**: Visit [https://www.openscad.org/](https://www.openscad.org/)
2. **Open the file**: Launch OpenSCAD and open `tconnect_enclosure_tall.scad`
3. **Use Customizer**: Press `Alt+C` or go to `Window > Customizer` to adjust parameters
4. **Preview**: Press `F5` to preview the model
5. **Render & Export**: Press `F6` to render, then `File > Export > Export as STL...` to save

## Key Parameters

### Rendering Options
- `render_part`: Choose which part to export (Enclosure, Lid, or Light Pipes)
- `show_lid`: Show lid in preview when rendering enclosure
- `show_light_pipes`: Show light pipes in preview

### Optional Features
- `enable_power_hole`: Enable/disable power input hole (default: true)
- `enable_antenna_hole`: Enable/disable antenna hole (default: false)
- `enable_mounting_holes`: Enable/disable wall mounting holes (default: true)

### Board Mounting
- `use_heat_inserts`: Use heat inserts or pins (default: false)
- `board_pin_inset`: Distance from board edge to mount center (default: 3mm)

### RJ45 Modules
- `rj45_module_count`: Number of modules (default: 3)
- `rj45_module_width`: Internal width (default: 34.5mm)
- `rj45_module_length`: Internal length (default: 29mm)

### Button & LED Holes
- `button1_from_power_side`: Button 1 position from power side (default: 24mm)
- `button2_from_power_side`: Button 2 position from power side (default: 31mm)
- `led_hole_size`: Size of square LED holes (default: 2mm)
- `led_spacing`: Center-to-center spacing between LEDs (default: 3mm)

### Fit Adjustments
- `lip_clearance`: Clearance between lid and walls (default: 0.2mm) - increase if lid is too tight
- `snap_tab_depth`: Snap tab interference depth (default: 0.7mm) - adjust if lid is too loose/tight

## Printing & Export

1. Set `render_part` to the component you want (Enclosure, Lid, or Light Pipes)
2. Press `F6` to render
3. Go to `File > Export > Export as STL...`
4. Print each part separately
5. Recommended: 0.2-0.3mm layer height, 20-30% infill, PLA or PETG
