// LillyGo T-Connect ESP32 Enclosure
// https://lilygo.cc/en-us/products/t-connect
// Open shell for board placement

// Board dimensions
board_width = 83;
board_length = 94;
board_height = 13; // Total height with components
board_thickness = 1.6; // Actual PCB thickness
board_clearance = 1;

// Enclosure parameters
wall_thickness = 3;
wall_height = 20.5;
corner_fillet = 2; // Fillet radius for vertical edges

// Lid parameters
lid_thickness = 3; // Thickness of lid top
lip_depth = 2; // How far the lip extends down into the enclosure
lip_clearance = 0.2; // Clearance between lip and enclosure walls
pin_guide_inner_diameter = 2.7; // Inner diameter to fit over pins
pin_guide_outer_diameter = 5; // Outer diameter of pin guides
pin_guide_height = 6; // Height of pin guides extending down from lid

// Visualization options
show_lid = false; // Show/hide the lid in preview

// Clearance dimensions
terminal_clearance = 25;
rj45_connector_width = 16.5; // Width of RJ45 connector cutout
rj45_connector_height = 14; // Height of RJ45 connector cutout
rj45_connector_bottom_offset = 2.5; // Distance from floor to bottom of connector

// Button cutouts
button_diameter = 3; // Diameter of button holes
button_height = 3; // Height from floor to button center
button1_from_power_side = 24; // Distance from power input edge of board to first button
button2_from_power_side = 31; // Distance from power input edge of board to second button

// RJ45 module dimensions
rj45_module_width = 35; // Internal width for RJ45 module
rj45_module_length = 29; // Internal length for RJ45 module
ridge_thickness = 3; // Thickness of ridges around RJ45 modules
ridge_height = 5; // Height of ridges above base

// Calculated RJ45 dimensions (including ridges)
rj45_width = rj45_module_width + 2 * ridge_thickness; // Total width with ridges
rj45_length = rj45_module_length + ridge_thickness; // Total length with one ridge
board_to_rj45_gap = 15; // Gap between main board and RJ45 modules

// Mounting holes
board_holes = 3;
pin_diameter = 2.5;
pin_height = 5;

// Pin placement for RJ45 modules
pin_from_wall = 5; // Distance from wall with opening to first pin pair
pin_from_ridge_side = 3.5; // Distance from side ridges to pins
pin_pair_spacing = 11.5; // Distance between first and second pin pair

// Pin placement for main board
board_pin_inset = 3; // Distance from board edge to pin center

// Calculated dimensions
inner_width = board_width + 2 * board_clearance;
// Extended for RJ45 modules on both sides with gaps
inner_length = rj45_length + board_to_rj45_gap + board_clearance + board_length + board_clearance + board_to_rj45_gap + rj45_length;
outer_width = inner_width + 2 * wall_thickness;
outer_length = inner_length + 2 * wall_thickness;

// Module to create a pin with a rounded top
module rounded_pin(diameter, height) {
  cylinder(d=diameter, h=height, $fn=20);
  translate([0, 0, height])
    sphere(d=diameter, $fn=20);
}

// RJ45 module mount (ridges + pins for one module)
// base_x, base_y: bottom-left corner of the RJ45 module area
// rotation: 0 for wall on +X side (terminal block), 180 for wall on -X side (power input)
module rj45_module_mount(base_x, base_y, rotation) {
  if (rotation == 0) {
    // Terminal block side: wall is on +X side
    // Three ridges (excluding wall side)
    // Left side ridge
    translate([base_x, base_y, wall_thickness])
      cube([ridge_thickness, rj45_width, ridge_height]);
    // Top side ridge
    translate([base_x, base_y + rj45_width - ridge_thickness, wall_thickness])
      cube([rj45_length, ridge_thickness, ridge_height]);
    // Bottom side ridge
    translate([base_x, base_y, wall_thickness])
      cube([rj45_length, ridge_thickness, ridge_height]);

    // Four mounting pins (measured from inner edge of ridges)
    translate([base_x + rj45_length - pin_from_wall, base_y + ridge_thickness + pin_from_ridge_side, wall_thickness])
      rounded_pin(pin_diameter, pin_height);
    translate([base_x + rj45_length - pin_from_wall, base_y + rj45_width - ridge_thickness - pin_from_ridge_side, wall_thickness])
      rounded_pin(pin_diameter, pin_height);
    translate([base_x + rj45_length - pin_from_wall - pin_pair_spacing, base_y + ridge_thickness + pin_from_ridge_side, wall_thickness])
      rounded_pin(pin_diameter, pin_height);
    translate([base_x + rj45_length - pin_from_wall - pin_pair_spacing, base_y + rj45_width - ridge_thickness - pin_from_ridge_side, wall_thickness])
      rounded_pin(pin_diameter, pin_height);
  } else {
    // Power input side: wall is on -X side
    // Three ridges (excluding wall side)
    // Right side ridge (away from wall, toward main board)
    translate([base_x + rj45_length - ridge_thickness, base_y, wall_thickness])
      cube([ridge_thickness, rj45_width, ridge_height]);
    // Top side ridge
    translate([base_x, base_y + rj45_width - ridge_thickness, wall_thickness])
      cube([rj45_length, ridge_thickness, ridge_height]);
    // Bottom side ridge
    translate([base_x, base_y, wall_thickness])
      cube([rj45_length, ridge_thickness, ridge_height]);

    // Four mounting pins (measured from inner edge of ridges)
    translate([base_x + pin_from_wall, base_y + ridge_thickness + pin_from_ridge_side, wall_thickness])
      rounded_pin(pin_diameter, pin_height);
    translate([base_x + pin_from_wall, base_y + rj45_width - ridge_thickness - pin_from_ridge_side, wall_thickness])
      rounded_pin(pin_diameter, pin_height);
    translate([base_x + pin_from_wall + pin_pair_spacing, base_y + ridge_thickness + pin_from_ridge_side, wall_thickness])
      rounded_pin(pin_diameter, pin_height);
    translate([base_x + pin_from_wall + pin_pair_spacing, base_y + rj45_width - ridge_thickness - pin_from_ridge_side, wall_thickness])
      rounded_pin(pin_diameter, pin_height);
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

      // RJ45 connector cutouts on terminal block side
      // Left RJ45 connector cutout
      translate(
        [
          outer_length - wall_thickness - 1,
          wall_thickness + (rj45_width - rj45_connector_width) / 2,
          rj45_connector_bottom_offset,
        ]
      )
        cube([wall_thickness + 2, rj45_connector_width, rj45_connector_height]);

      // Right RJ45 connector cutout
      translate(
        [
          outer_length - wall_thickness - 1,
          outer_width - wall_thickness - rj45_width + (rj45_width - rj45_connector_width) / 2,
          rj45_connector_bottom_offset,
        ]
      )
        cube([wall_thickness + 2, rj45_connector_width, rj45_connector_height]);

      // Power input side - centered RJ45 connector cutout
      translate(
        [
          -1,
          (outer_width - rj45_connector_width) / 2,
          rj45_connector_bottom_offset,
        ]
      )
        cube([wall_thickness + 2, rj45_connector_width, rj45_connector_height]);

      // Button holes on top side wall (long edge)
      // Button 1
      translate(
        [
          wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + button1_from_power_side,
          outer_width + 1,
          wall_thickness + button_height,
        ]
      )
        rotate([90, 0, 0])
          cylinder(d=button_diameter, h=wall_thickness + 2, $fn=20);

      // Button 2
      translate(
        [
          wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + button2_from_power_side,
          outer_width + 1,
          wall_thickness + button_height,
        ]
      )
        rotate([90, 0, 0])
          cylinder(d=button_diameter, h=wall_thickness + 2, $fn=20);
    }

    // All RJ45 module mounts (ridges + pins)
    // Terminal block side - Left
    rj45_module_mount(
      wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length + board_to_rj45_gap,
      wall_thickness,
      0
    );

    // Terminal block side - Right
    rj45_module_mount(
      wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length + board_to_rj45_gap,
      outer_width - wall_thickness - rj45_width,
      0
    );

    // Power input side - Center
    rj45_module_mount(
      wall_thickness,
      (outer_width - rj45_width) / 2,
      180
    );

    // Main board mounting pins (4 corners)
    // Bottom-left corner
    translate(
      [
        wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_pin_inset,
        wall_thickness + board_clearance + board_pin_inset,
        wall_thickness,
      ]
    )
      rounded_pin(pin_diameter, pin_height);

    // Bottom-right corner
    translate(
      [
        wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length - board_pin_inset,
        wall_thickness + board_clearance + board_pin_inset,
        wall_thickness,
      ]
    )
      rounded_pin(pin_diameter, pin_height);

    // Top-left corner
    translate(
      [
        wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_pin_inset,
        wall_thickness + board_clearance + board_width - board_pin_inset,
        wall_thickness,
      ]
    )
      rounded_pin(pin_diameter, pin_height);

    // Top-right corner
    translate(
      [
        wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length - board_pin_inset,
        wall_thickness + board_clearance + board_width - board_pin_inset,
        wall_thickness,
      ]
    )
      rounded_pin(pin_diameter, pin_height);
  }
}

// Board placeholder module
module board_placeholder() {
  color("green", 0.7)
    translate([wall_thickness + rj45_length + board_to_rj45_gap + board_clearance, wall_thickness + board_clearance, wall_thickness])
      cube([board_length, board_width, board_thickness]);
}

// RJ45 module placeholder boards
module rj45_modules_placeholder() {
  // Terminal block side - Left RJ45 module
  color("blue", 0.7)
    translate([wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length + board_to_rj45_gap, wall_thickness, wall_thickness])
      cube([rj45_length, rj45_width, board_thickness]);

  // Terminal block side - Right RJ45 module
  color("blue", 0.7)
    translate([wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length + board_to_rj45_gap, outer_width - wall_thickness - rj45_width, wall_thickness])
      cube([rj45_length, rj45_width, board_thickness]);

  // Power input side - Center RJ45 module
  color("blue", 0.7)
    translate([wall_thickness, (outer_width - rj45_width) / 2, wall_thickness])
      cube([rj45_length, rj45_width, board_thickness]);
}

// Lid module
module lid() {
  difference() {
    union() {
      // Lid top plate with filleted edges
      rounded_box(outer_length, outer_width, lid_thickness, corner_fillet);

      // Lip that fits inside the enclosure
      translate([wall_thickness + lip_clearance, wall_thickness + lip_clearance, -lip_depth])
        cube([inner_length - 2 * lip_clearance, inner_width - 2 * lip_clearance, lip_depth]);

      // Pin guides (hollow cylinders) at main board pin locations
      // Bottom-left corner
      translate(
        [
          wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_pin_inset,
          wall_thickness + board_clearance + board_pin_inset,
          -pin_guide_height,
        ]
      )
        cylinder(d=pin_guide_outer_diameter, h=pin_guide_height, $fn=20);

      // Bottom-right corner
      translate(
        [
          wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length - board_pin_inset,
          wall_thickness + board_clearance + board_pin_inset,
          -pin_guide_height,
        ]
      )
        cylinder(d=pin_guide_outer_diameter, h=pin_guide_height, $fn=20);

      // Top-left corner
      translate(
        [
          wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_pin_inset,
          wall_thickness + board_clearance + board_width - board_pin_inset,
          -pin_guide_height,
        ]
      )
        cylinder(d=pin_guide_outer_diameter, h=pin_guide_height, $fn=20);

      // Top-right corner
      translate(
        [
          wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length - board_pin_inset,
          wall_thickness + board_clearance + board_width - board_pin_inset,
          -pin_guide_height,
        ]
      )
        cylinder(d=pin_guide_outer_diameter, h=pin_guide_height, $fn=20);
    }

    // Hollow out the pin guides
    // Bottom-left corner
    translate(
      [
        wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_pin_inset,
        wall_thickness + board_clearance + board_pin_inset,
        -pin_guide_height - 1,
      ]
    )
      cylinder(d=pin_guide_inner_diameter, h=pin_guide_height + 2, $fn=20);

    // Bottom-right corner
    translate(
      [
        wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length - board_pin_inset,
        wall_thickness + board_clearance + board_pin_inset,
        -pin_guide_height - 1,
      ]
    )
      cylinder(d=pin_guide_inner_diameter, h=pin_guide_height + 2, $fn=20);

    // Top-left corner
    translate(
      [
        wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_pin_inset,
        wall_thickness + board_clearance + board_width - board_pin_inset,
        -pin_guide_height - 1,
      ]
    )
      cylinder(d=pin_guide_inner_diameter, h=pin_guide_height + 2, $fn=20);

    // Top-right corner
    translate(
      [
        wall_thickness + rj45_length + board_to_rj45_gap + board_clearance + board_length - board_pin_inset,
        wall_thickness + board_clearance + board_width - board_pin_inset,
        -pin_guide_height - 1,
      ]
    )
      cylinder(d=pin_guide_inner_diameter, h=pin_guide_height + 2, $fn=20);
  }
}

// Render the enclosure and board
enclosure_shell();

// Show the boards for visualization (comment out for final export)
%board_placeholder();
%rj45_modules_placeholder();

// Show the lid (positioned above the enclosure for visualization)
if (show_lid) {
  translate([0, 0, wall_height + 5])
    %lid();
}
