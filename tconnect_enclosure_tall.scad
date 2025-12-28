// LillyGo T-Connect ESP32 Enclosure - TALL VERSION
// https://lilygo.cc/en-us/products/t-connect
// RJ45 modules mounted inverted in lid for compact length

// Visualization options
show_lid = false; // Show/hide the lid in preview
// render_part = "enclosure"; // "enclosure" or "lid" - controls what gets rendered for export
render_part = "enclosure"; // "enclosure" or "lid" - controls what gets rendered for export

// Board dimensions
board_width = 83;
board_length = 94;
board_height = 13; // Total height with components above board
board_thickness = 2; // Actual PCB thickness
board_clearance = 1; // Clearance in length direction
terminal_block_clearance = 12; // Clearance on each side for terminal blocks

// Enclosure parameters
wall_thickness = 3;
wall_height = 40; // Tall version for inverted RJ45 modules (reduced from 60mm)
corner_fillet = 2; // Fillet radius for vertical edges

// Lid parameters
lid_thickness = 3; // Thickness of lid top
lip_depth = 2; // How far the lip extends down into the enclosure
lip_clearance = 0.2; // Clearance between lip and enclosure walls

// Clearance dimensions
terminal_clearance = 25;
rj45_connector_width = 16.5; // Width of RJ45 connector cutout
rj45_connector_height = 14; // Height of RJ45 connector cutout

// Button cutouts
button_diameter = 3; // Diameter of button holes
button_height = 3; // Height from floor to button center
button1_from_power_side = 24; // Distance from power input edge of board to first button
button2_from_power_side = 31; // Distance from power input edge of board to second button

// LED viewing holes in lid
led_hole_diameter = 3; // Diameter of LED viewing holes
led_first_from_power_side = 10; // Distance from power input edge of board to first LED
led_spacing = 4; // Spacing between LED holes
led_from_bottom_edge = 9; // Distance from bottom edge of board to LEDs

// Mounting holes in bottom
mounting_hole_diameter = 3; // Diameter of mounting holes in bottom
mounting_hole_inset = 8; // Distance from corner to mounting hole center (increased for screw head clearance)

// Board retention clips
clip_width = 5; // Width of clip
clip_thickness = 1.5; // Thickness of clip
clip_overhang = 1; // How much clip extends over board edge
clip_height = 2; // Height of clip above board surface

// RJ45 module dimensions (now mounted in lid on one edge)
rj45_module_width = 35; // Internal width for RJ45 module
rj45_module_length = 29; // Internal length for RJ45 module
ridge_thickness = 2; // Thickness of ridges around RJ45 modules
ridge_height = 5; // Height of ridges above base
rj45_module_count = 3; // Number of RJ45 modules in a row

// Calculated RJ45 dimensions
rj45_single_width = rj45_module_width + 2 * ridge_thickness; // Width of single module with side ridges
// For a row of modules: width = (modules * module_width) + ((modules + 1) * ridge_thickness)
// This accounts for one ridge between each pair, plus one on each end
rj45_row_length = (rj45_module_count * rj45_module_width) + ( (rj45_module_count + 1) * ridge_thickness);

// Mounting holes
board_holes = 3;
pin_diameter = 2.5;
pin_height = 5;

// Pin placement for RJ45 modules (now in lid)
pin_from_wall = 5; // Distance from wall with opening to first pin pair
pin_from_ridge_side = 3.5; // Distance from side ridges to pins
pin_pair_spacing = 11.5; // Distance between first and second pin pair

// Pin placement for main board
board_pin_inset = 3; // Distance from board edge to pin center

// RJ45 connector cutout positioning (for inverted modules in lid)
// Lid bottom is at wall_height, cutout should start 2.5mm below
// With rotate([-90,0,0]), the Z position is the TOP of the cutout
rj45_connector_top_offset = wall_height - 2.5;

// Calculated dimensions
// Length needs to fit: board + terminal blocks + some extra for RJ45 row if needed
min_length_for_board = board_length + 2 * terminal_block_clearance;
min_length_for_rj45 = rj45_row_length + 2 * wall_thickness + 2 * lip_clearance;
inner_length = max(min_length_for_board, rj45_row_length + 4); // Use larger + some clearance
inner_width = board_width + 2 * board_clearance;
outer_width = inner_width + 2 * wall_thickness;
outer_length = inner_length + 2 * wall_thickness;

// Module to create a pin with a rounded top
module rounded_pin(diameter, height) {
  cylinder(d=diameter, h=height, $fn=20);
  translate([0, 0, height])
    sphere(d=diameter, $fn=20);
}

// Module for a row of 4 RJ45 modules with shared ridges (inverted for lid)
// base_x, base_y: starting position (left edge of first module)
// Ridges and pins point DOWN from lid
module rj45_row_inverted(base_x, base_y) {
  // Create ridges - one at each end, one between each pair
  for (i = [0:rj45_module_count]) {
    // Vertical ridges perpendicular to the wall
    x_pos = base_x + (i * (rj45_module_width + ridge_thickness));
    translate([x_pos, base_y, -ridge_height])
      cube([ridge_thickness, rj45_module_length, ridge_height]);
  }

  // Create two horizontal ridges parallel to the wall (front and back of modules)
  translate([base_x, base_y, -ridge_height])
    cube([rj45_row_length, ridge_thickness, ridge_height]);
  translate([base_x, base_y + rj45_module_length - ridge_thickness, -ridge_height])
    cube([rj45_row_length, ridge_thickness, ridge_height]);

  // Create pins for each module
  for (i = [0:rj45_module_count - 1]) {
    module_x = base_x + ridge_thickness + (i * (rj45_module_width + ridge_thickness));

    // Four pins per module
    translate([module_x + pin_from_ridge_side, base_y + pin_from_wall, -pin_height])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
    translate([module_x + rj45_module_width - pin_from_ridge_side, base_y + pin_from_wall, -pin_height])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
    translate([module_x + pin_from_ridge_side, base_y + pin_from_wall + pin_pair_spacing, -pin_height])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
    translate([module_x + rj45_module_width - pin_from_ridge_side, base_y + pin_from_wall + pin_pair_spacing, -pin_height])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
  }
}

// Module to create a box with filleted vertical edges
module rounded_box(length, width, height, fillet) {
  hull() {
    // Four corner cylinders for the fillets
    translate([fillet, fillet, 0])
      cylinder(r=fillet, h=height, $fn=20);
    translate([length - fillet, fillet, 0])
      cylinder(r=fillet, h=height, $fn=20);
    translate([fillet, width - fillet, 0])
      cylinder(r=fillet, h=height, $fn=20);
    translate([length - fillet, width - fillet, 0])
      cylinder(r=fillet, h=height, $fn=20);
  }
}

// Main enclosure shell
module enclosure_shell() {
  union() {
    difference() {
      // Outer box with filleted edges
      rounded_box(outer_length, outer_width, wall_height, corner_fillet);

      // Inner cavity
      translate([wall_thickness, wall_thickness, wall_thickness])
        cube([inner_length, inner_width, wall_height]);

      // RJ45 connector cutouts on opposite side from buttons (3 connectors in a row)
      // Center the cutouts to match the centered RJ45 mounts in the lid
      for (i = [0:rj45_module_count - 1]) {
        cutout_x = (outer_length - rj45_row_length) / 2 + ridge_thickness + (i * (rj45_module_width + ridge_thickness)) + (rj45_module_width - rj45_connector_width) / 2;
        translate(
          [
            cutout_x,
            -1,
            rj45_connector_top_offset,
          ]
        )
          rotate([-90, 0, 0])
            cube([rj45_connector_width, rj45_connector_height, wall_thickness + 2]);
      }

      // Button holes on button side wall (long edge) - positioned to avoid RJ45 cutouts
      // Button 1
      translate(
        [
          wall_thickness + terminal_block_clearance + button1_from_power_side,
          outer_width + 1,
          wall_thickness + button_height,
        ]
      )
        rotate([90, 0, 0])
          cylinder(d=button_diameter, h=wall_thickness + 2, $fn=20);

      // Button 2
      translate(
        [
          wall_thickness + terminal_block_clearance + button2_from_power_side,
          outer_width + 1,
          wall_thickness + button_height,
        ]
      )
        rotate([90, 0, 0])
          cylinder(d=button_diameter, h=wall_thickness + 2, $fn=20);

      // Mounting holes in bottom (near corners for wall mounting)
      // Bottom-left corner
      translate([mounting_hole_inset, mounting_hole_inset, -1])
        cylinder(d=mounting_hole_diameter, h=wall_thickness + 2, $fn=20);

      // Bottom-right corner
      translate([outer_length - mounting_hole_inset, mounting_hole_inset, -1])
        cylinder(d=mounting_hole_diameter, h=wall_thickness + 2, $fn=20);

      // Top-left corner
      translate([mounting_hole_inset, outer_width - mounting_hole_inset, -1])
        cylinder(d=mounting_hole_diameter, h=wall_thickness + 2, $fn=20);

      // Top-right corner
      translate([outer_length - mounting_hole_inset, outer_width - mounting_hole_inset, -1])
        cylinder(d=mounting_hole_diameter, h=wall_thickness + 2, $fn=20);
    }

    // Main board mounting pins (4 corners)
    // Bottom-left corner
    translate(
      [
        wall_thickness + terminal_block_clearance + board_pin_inset,
        wall_thickness + board_clearance + board_pin_inset,
        wall_thickness,
      ]
    )
      rounded_pin(pin_diameter, pin_height);

    // Bottom-right corner
    translate(
      [
        wall_thickness + terminal_block_clearance + board_length - board_pin_inset,
        wall_thickness + board_clearance + board_pin_inset,
        wall_thickness,
      ]
    )
      rounded_pin(pin_diameter, pin_height);

    // Top-left corner
    translate(
      [
        wall_thickness + terminal_block_clearance + board_pin_inset,
        wall_thickness + board_clearance + board_width - board_pin_inset,
        wall_thickness,
      ]
    )
      rounded_pin(pin_diameter, pin_height);

    // Top-right corner
    translate(
      [
        wall_thickness + terminal_block_clearance + board_length - board_pin_inset,
        wall_thickness + board_clearance + board_width - board_pin_inset,
        wall_thickness,
      ]
    )
      rounded_pin(pin_diameter, pin_height);

    // Board retention clips (hold board down without lid pins)
    // Clips at the halfway point on both long sides to avoid LEDs and buttons
    // Clips sit on top of the board surface
    // Bottom side - Center clip
    translate(
      [
        wall_thickness + terminal_block_clearance + board_length / 2 - clip_width / 2,
        wall_thickness + board_clearance - clip_thickness,
        wall_thickness + board_thickness,
      ]
    )
      cube([clip_width, clip_thickness + clip_overhang, clip_height]);

    // Top side - Center clip
    translate(
      [
        wall_thickness + terminal_block_clearance + board_length / 2 - clip_width / 2,
        wall_thickness + board_clearance + board_width - clip_overhang,
        wall_thickness + board_thickness,
      ]
    )
      cube([clip_width, clip_thickness + clip_overhang, clip_height]);
  }
}

// Board placeholder module
module board_placeholder() {
  color("green", 0.7)
    translate([wall_thickness + terminal_block_clearance, wall_thickness + board_clearance, wall_thickness])
      cube([board_length, board_width, board_thickness]);
}

// RJ45 module placeholder boards - NO LONGER USED (modules in lid)
module rj45_modules_placeholder() {
  // Modules now mounted in lid - see lid module
}

// Lid module with inverted RJ45 mounts
module lid() {
  union() {
    difference() {
      union() {
        // Lid top plate with filleted edges
        rounded_box(outer_length, outer_width, lid_thickness, corner_fillet);

        // Lip that fits inside the enclosure
        translate([wall_thickness + lip_clearance, wall_thickness + lip_clearance, -lip_depth])
          cube([inner_length - 2 * lip_clearance, inner_width - 2 * lip_clearance, lip_depth]);
      }

      // LED viewing holes (4 LEDs in a row between pin and buttons)
      // LEDs are on the same side as the buttons (button side)
      for (i = [0:3]) {
        translate(
          [
            wall_thickness + terminal_block_clearance + led_first_from_power_side + (i * led_spacing),
            wall_thickness + board_clearance + board_width - led_from_bottom_edge,
            -lip_depth - 1,
          ]
        )
          cylinder(d=led_hole_diameter, h=lid_thickness + lip_depth + 2, $fn=20);
      }
    }

    // Row of 3 inverted RJ45 module mounts on opposite side from buttons (hanging down from lid)
    // Center the row horizontally within the lid
    rj45_row_inverted(
      (outer_length - rj45_row_length) / 2,
      wall_thickness + lip_clearance
    );
  }
}

// Render only the selected part (for export)
if (render_part == "enclosure") {
  enclosure_shell();
} else if (render_part == "lid") {
  lid();
}

// Preview visualizations (only visible in preview mode, not render)
// Show the boards for context (only when rendering enclosure)
if (render_part == "enclosure") {
  %board_placeholder();
  %rj45_modules_placeholder();
}

// Show the lid above enclosure if enabled
if (show_lid && render_part == "enclosure") {
  translate([0, 0, wall_height + 5])
    %lid();
}
