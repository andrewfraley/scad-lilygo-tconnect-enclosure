// LillyGo T-Connect ESP32 Enclosure
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

// Lid parameters
lid_thickness = 3; // Thickness of lid top
lip_depth = 2; // How far the lip extends down into the enclosure
lip_clearance = 0.2; // Clearance between lip and enclosure walls

// Visualization options
show_lid = false; // Show/hide the lid in preview

// Clearance dimensions
terminal_clearance = 25;
rj45_width = 35; // Width of RJ45 module board
rj45_length = 28;
rj45_connector_width = 16.5; // Width of RJ45 connector cutout
rj45_connector_height = 14; // Height of RJ45 connector cutout
rj45_connector_bottom_offset = 2.5; // Distance from floor to bottom of connector

rj45_module_length = 28; // Length of RJ45 module boards
ridge_thickness = 3; // Thickness of ridges around RJ45 modules
ridge_height = 5; // Height of ridges above base
board_to_rj45_gap = 15; // Gap between main board and RJ45 modules

// Mounting holes
board_holes = 3;
pin_diameter = 2.5;
pin_height = 5;

// Pin placement for RJ45 modules
pin_from_wall = 5; // Distance from wall with opening to first pin pair
pin_from_ridge_side = 3; // Distance from side ridges to pins
pin_pair_spacing = 11.5; // Distance between first and second pin pair

// Calculated dimensions
inner_width = board_width + 2 * board_clearance;
// Extended for RJ45 modules on both sides with gaps
inner_length = rj45_module_length + board_to_rj45_gap + board_clearance + board_length + board_clearance + board_to_rj45_gap + rj45_module_length;
outer_width = inner_width + 2 * wall_thickness;
outer_length = inner_length + 2 * wall_thickness;

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
      cube([rj45_module_length, ridge_thickness, ridge_height]);
    // Bottom side ridge
    translate([base_x, base_y, wall_thickness])
      cube([rj45_module_length, ridge_thickness, ridge_height]);

    // Four mounting pins (measured from inner edge of ridges)
    translate([base_x + rj45_module_length - pin_from_wall, base_y + ridge_thickness + pin_from_ridge_side, 0])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
    translate([base_x + rj45_module_length - pin_from_wall, base_y + rj45_width - ridge_thickness - pin_from_ridge_side, 0])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
    translate([base_x + rj45_module_length - pin_from_wall - pin_pair_spacing, base_y + ridge_thickness + pin_from_ridge_side, 0])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
    translate([base_x + rj45_module_length - pin_from_wall - pin_pair_spacing, base_y + rj45_width - ridge_thickness - pin_from_ridge_side, 0])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
  } else {
    // Power input side: wall is on -X side
    // Three ridges (excluding wall side)
    // Right side ridge (away from wall, toward main board)
    translate([base_x + rj45_module_length - ridge_thickness, base_y, wall_thickness])
      cube([ridge_thickness, rj45_width, ridge_height]);
    // Top side ridge
    translate([base_x, base_y + rj45_width - ridge_thickness, wall_thickness])
      cube([rj45_module_length, ridge_thickness, ridge_height]);
    // Bottom side ridge
    translate([base_x, base_y, wall_thickness])
      cube([rj45_module_length, ridge_thickness, ridge_height]);

    // Four mounting pins (measured from inner edge of ridges)
    translate([base_x + pin_from_wall, base_y + ridge_thickness + pin_from_ridge_side, 0])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
    translate([base_x + pin_from_wall, base_y + rj45_width - ridge_thickness - pin_from_ridge_side, 0])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
    translate([base_x + pin_from_wall + pin_pair_spacing, base_y + ridge_thickness + pin_from_ridge_side, 0])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
    translate([base_x + pin_from_wall + pin_pair_spacing, base_y + rj45_width - ridge_thickness - pin_from_ridge_side, 0])
      cylinder(d=pin_diameter, h=pin_height, $fn=20);
  }
}

// Main enclosure shell
module enclosure_shell() {
  union() {
    difference() {
      // Outer box
      cube([outer_length, outer_width, wall_height]);

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
    }

    // All RJ45 module mounts (ridges + pins)
    // Terminal block side - Left
    rj45_module_mount(
      wall_thickness + rj45_module_length + board_to_rj45_gap + board_clearance + board_length + board_to_rj45_gap,
      wall_thickness,
      0
    );

    // Terminal block side - Right
    rj45_module_mount(
      wall_thickness + rj45_module_length + board_to_rj45_gap + board_clearance + board_length + board_to_rj45_gap,
      outer_width - wall_thickness - rj45_width,
      0
    );

    // Power input side - Center
    rj45_module_mount(
      wall_thickness,
      (outer_width - rj45_width) / 2,
      180
    );
  }
}

// Board placeholder module
module board_placeholder() {
  color("green", 0.7)
    translate([wall_thickness + rj45_module_length + board_to_rj45_gap + board_clearance, wall_thickness + board_clearance, wall_thickness])
      cube([board_length, board_width, board_thickness]);
}

// RJ45 module placeholder boards
module rj45_modules_placeholder() {
  // Terminal block side - Left RJ45 module
  color("blue", 0.7)
    translate([wall_thickness + rj45_module_length + board_to_rj45_gap + board_clearance + board_length + board_to_rj45_gap, wall_thickness, wall_thickness])
      cube([rj45_module_length, rj45_width, board_thickness]);

  // Terminal block side - Right RJ45 module
  color("blue", 0.7)
    translate([wall_thickness + rj45_module_length + board_to_rj45_gap + board_clearance + board_length + board_to_rj45_gap, outer_width - wall_thickness - rj45_width, wall_thickness])
      cube([rj45_module_length, rj45_width, board_thickness]);

  // Power input side - Center RJ45 module
  color("blue", 0.7)
    translate([wall_thickness, (outer_width - rj45_width) / 2, wall_thickness])
      cube([rj45_module_length, rj45_width, board_thickness]);
}

// Lid module
module lid() {
  difference() {
    union() {
      // Lid top plate
      cube([outer_length, outer_width, lid_thickness]);

      // Lip that fits inside the enclosure
      translate([wall_thickness + lip_clearance, wall_thickness + lip_clearance, -lip_depth])
        cube([inner_length - 2 * lip_clearance, inner_width - 2 * lip_clearance, lip_depth]);
    }
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
