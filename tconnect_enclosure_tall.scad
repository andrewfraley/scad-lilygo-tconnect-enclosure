// LillyGo T-Connect ESP32 Enclosure - TALL VERSION
// https://lilygo.cc/en-us/products/t-connect
// RJ45 modules mounted inverted in lid for compact length

/* [Rendering Options] */
// Which part to render for export
render_part = "enclosure"; // [enclosure:Enclosure, lid:Lid, light_pipes:Light Pipes]
// Show lid in preview when rendering enclosure
show_lid = false;
// Show lid flush (true) or offset above (false)
lid_flush = false;
// Show light pipes in preview
show_light_pipes = false;

/* [Board Dimensions] */
board_width = 83;
board_length = 94;
board_height = 13; // Total height with components above board
board_thickness = 4; // PCB thickness including underside protrusions
board_clearance = 1; // Clearance in width direction
terminal_block_clearance = 25; // Clearance on length ends

/* [Enclosure Parameters] */
wall_thickness = 3;
wall_height = 40; // Tall version for inverted RJ45 modules
corner_fillet = 2; // Fillet radius for vertical edges

/* [Lid Parameters] */
lid_thickness = 3; // Thickness of lid top
lip_depth = 2; // How far the lip extends down
lip_clearance = 0.2; // Clearance between lip and walls

/* [Snap Tabs] */
snap_tab_width = 15; // Width of each snap tab
snap_tab_depth = 0.6; // How far tab extends inward (creates interference)
snap_tab_height = 2; // Height of tab at bottom of lip

/* [Board Mounting] */
// Use heat inserts or pins
use_heat_inserts = false;
// Distance from board edge to mount center
board_pin_inset = 3;

/* [Mounting Pins] */
pin_diameter = 2.5;
pin_height = 5;

/* [Heat Insert Mounts] */
insert_outer_diameter = 4; // Widest diameter
insert_inner_diameter = 3.4; // Thinnest diameter
insert_height = 4;
mount_height = 5; // Height of post (matches pin height)
mount_diameter = 6; // Diameter of post base

/* [RJ45 Module Configuration] */
rj45_module_count = 3; // Number of modules
rj45_module_width = 34; // Internal width (reduced 1mm to close side gaps)
rj45_module_length = 29; // Internal length
ridge_thickness = 2; // Ridge thickness
ridge_height = 5; // Ridge height

/* [RJ45 Connector Cutouts] */
rj45_connector_width = 16.5; // Cutout width
rj45_connector_height = 14; // Cutout height

/* [RJ45 Pin Placement] */
pin_from_wall = 5; // Distance from wall to first pin pair
pin_from_ridge_side = 3; // Distance from side ridges
pin_pair_spacing = 11.5; // Distance between pin pairs

/* [Button Holes] */
button_diameter = 3;
button_height = mount_height + 1.5; // Height from floor
button1_from_power_side = 24; // Button 1 position
button2_from_power_side = 31; // Button 2 position

/* [LED Viewing Holes] */
led_hole_size = 2; // Size of square holes (2mm APA102 LEDs)
led_first_from_power_side = 8; // First LED edge position from power side (center at 9mm)
led_spacing = 3; // Center-to-center spacing between LEDs
led_from_bottom_edge = 2.5; // Distance from edge to LED center (1mm edge + 1mm LED center)

/* [Light Pipe Parameters] */
light_pipe_length = 34; // Length from bottom of flange to LED tops (44 - 1 - 11 = 32, +2mm for insertion)
light_pipe_flange_size = 5; // Flange size on lid
light_pipe_flange_thickness = 1; // Flange thickness
light_pipe_taper = 0.1; // Taper for insertion (mm/side)

/* [Power Cable Entry Hole] */
enable_power_hole = true; // [true,false] Enable/disable power input hole
power_hole_diameter = 7; // Diameter (for Cat6)
power_hole_from_led_edge = 8; // Position from edge
power_hole_height = 8; // Height from floor

/* [Wall Mounting Holes] */
enable_mounting_holes = true; // [true,false] Enable/disable wall mounting holes
mounting_hole_diameter = 5;
mounting_hole_inset = 10; // Distance from corners

/* [Hidden] */
// Calculated RJ45 dimensions
rj45_single_width = rj45_module_width + 2 * ridge_thickness;
rj45_row_length = (rj45_module_count * rj45_module_width) + ( (rj45_module_count + 1) * ridge_thickness);

// RJ45 connector cutout positioning
rj45_connector_top_offset = wall_height - 2.5;

// Calculated enclosure dimensions
min_length_for_board = board_length + 2 * terminal_block_clearance;
min_length_for_rj45 = rj45_row_length + 4;
inner_length = max(min_length_for_board, min_length_for_rj45);
inner_width = board_width + 2 * board_clearance;
outer_width = inner_width + 2 * wall_thickness;
outer_length = inner_length + 2 * wall_thickness;

// Unused legacy variable
terminal_clearance = 25;

// Module to create a pin with a rounded top
module rounded_pin(diameter, height) {
  cylinder(d=diameter, h=height, $fn=20);
  translate([0, 0, height])
    sphere(d=diameter, $fn=20);
}

// Module to create a heat insert mount post
module heat_insert_mount() {
  difference() {
    // Mounting post
    cylinder(d=mount_diameter, h=mount_height, $fn=30);
    // Hole for heat insert (sized for press fit, goes all the way through)
    translate([0, 0, -0.1])
      cylinder(d=insert_outer_diameter - 0.2, h=mount_height + 0.2, $fn=30);
  }
}

// Module to create a solid standoff (for pin mounting)
module solid_standoff() {
  cylinder(d=mount_diameter, h=mount_height, $fn=30);
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

  // Create horizontal ridges parallel to the wall (front is 1mm and extended 1mm forward, back is full thickness moved back 1mm)
  translate([base_x, base_y - 1, -ridge_height])
    cube([rj45_row_length, 1, ridge_height]);
  translate([base_x, base_y + rj45_module_length - ridge_thickness + 1, -ridge_height])
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

      // Mounting holes in bottom (near corners for wall mounting) - optional
      if (enable_mounting_holes) {
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

      // Hole on short edge (power input side), near corner on LED side (optional)
      if (enable_power_hole) {
        translate(
          [
            -1,
            wall_thickness + board_clearance + power_hole_from_led_edge,
            power_hole_height,
          ]
        )
          rotate([0, 90, 0])
            cylinder(d=power_hole_diameter, h=wall_thickness + 2, $fn=20);
      }
    }

    // Main board mounting (4 corners) - standoffs always present
    // Bottom-left corner
    translate(
      [
        wall_thickness + terminal_block_clearance + board_pin_inset,
        wall_thickness + board_clearance + board_pin_inset,
        wall_thickness,
      ]
    ) {
      if (use_heat_inserts) {
        heat_insert_mount();
      } else {
        solid_standoff();
        translate([0, 0, mount_height])
          rounded_pin(pin_diameter, pin_height);
      }
    }

    // Bottom-right corner
    translate(
      [
        wall_thickness + terminal_block_clearance + board_length - board_pin_inset,
        wall_thickness + board_clearance + board_pin_inset,
        wall_thickness,
      ]
    ) {
      if (use_heat_inserts) {
        heat_insert_mount();
      } else {
        solid_standoff();
        translate([0, 0, mount_height])
          rounded_pin(pin_diameter, pin_height);
      }
    }

    // Top-left corner
    translate(
      [
        wall_thickness + terminal_block_clearance + board_pin_inset,
        wall_thickness + board_clearance + board_width - board_pin_inset,
        wall_thickness,
      ]
    ) {
      if (use_heat_inserts) {
        heat_insert_mount();
      } else {
        solid_standoff();
        translate([0, 0, mount_height])
          rounded_pin(pin_diameter, pin_height);
      }
    }

    // Top-right corner
    translate(
      [
        wall_thickness + terminal_block_clearance + board_length - board_pin_inset,
        wall_thickness + board_clearance + board_width - board_pin_inset,
        wall_thickness,
      ]
    ) {
      if (use_heat_inserts) {
        heat_insert_mount();
      } else {
        solid_standoff();
        translate([0, 0, mount_height])
          rounded_pin(pin_diameter, pin_height);
      }
    }
  }
}

// Board placeholder module
module board_placeholder() {
  color("green", 0.7)
    translate([wall_thickness + terminal_block_clearance, wall_thickness + board_clearance, wall_thickness + mount_height])
      cube([board_length, board_width, 1.5]);
}

// Module for a single light pipe
module light_pipe() {
  // Shaft dimensions
  top_size = led_hole_size + light_pipe_taper;
  bottom_size = led_hole_size - 0.2;

  union() {
    // Flange that sits on lid surface - extends beyond shaft on 3 sides only (one edge flush)
    // Offset so one edge is flush with shaft for printability (aligned with bottom_size)
    flange_offset = (light_pipe_flange_size - bottom_size) / 2;
    translate([0, flange_offset, -light_pipe_flange_thickness])
      cube([light_pipe_flange_size, light_pipe_flange_size, light_pipe_flange_thickness], center=true);

    // Tapered shaft - flat on flush side (-Y), tapered on other 3 sides

    hull() {
      // Top profile (at lid) - polygon with one flat edge
      translate([0, 0, -light_pipe_flange_thickness])
        linear_extrude(height=0.1)
          polygon(
            [
              // Flush edge (stays vertical, no taper on -Y side)
              [-top_size / 2, -bottom_size / 2],
              [top_size / 2, -bottom_size / 2],
              // Tapered edges
              [top_size / 2, top_size / 2],
              [-top_size / 2, top_size / 2],
            ]
          );

      // Bottom profile (at board) - square
      translate([0, 0, -light_pipe_length])
        linear_extrude(height=0.1)
          square([bottom_size, bottom_size], center=true);
    }
  }
}

// Light pipes module (4 pipes for 4 LEDs)
module light_pipes() {
  for (i = [0:3]) {
    translate(
      [
        wall_thickness + terminal_block_clearance + led_first_from_power_side + (i * led_spacing) + led_hole_size / 2,
        wall_thickness + board_clearance + board_width - led_from_bottom_edge + led_hole_size / 2,
        wall_height + lid_thickness + light_pipe_flange_thickness,
      ]
    )
      light_pipe();
  }
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
          cube([led_hole_size, led_hole_size, lid_thickness + lip_depth + 2]);
      }
    }

    // Row of 3 inverted RJ45 module mounts on opposite side from buttons (hanging down from lid)
    // Center the row horizontally within the lid, pulled back 1mm from wall for clearance
    rj45_row_inverted(
      (outer_length - rj45_row_length) / 2,
      wall_thickness + lip_clearance + 1
    );

    // Snap tabs at bottom of lip (one centered on each side)
    // These extend outward beyond the lip to catch on the enclosure wall edge

    // Tab on short edge (power input side) - centered, extends toward wall
    translate([outer_length / 2 - snap_tab_width / 2, wall_thickness + lip_clearance - snap_tab_depth, -lip_depth])
      cube([snap_tab_width, snap_tab_depth, snap_tab_height]);

    // Tab on short edge (opposite side) - centered, extends toward wall
    translate([outer_length / 2 - snap_tab_width / 2, outer_width - wall_thickness - lip_clearance, -lip_depth])
      cube([snap_tab_width, snap_tab_depth, snap_tab_height]);

    // Tab on long edge (RJ45 side) - centered, extends toward wall
    translate([wall_thickness + lip_clearance - snap_tab_depth, outer_width / 2 - snap_tab_width / 2, -lip_depth])
      cube([snap_tab_depth, snap_tab_width, snap_tab_height]);

    // Tab on long edge (button side) - centered, extends toward wall
    translate([outer_length - wall_thickness - lip_clearance, outer_width / 2 - snap_tab_width / 2, -lip_depth])
      cube([snap_tab_depth, snap_tab_width, snap_tab_height]);
  }
}

// Render only the selected part (for export)
if (render_part == "enclosure") {
  enclosure_shell();
} else if (render_part == "lid") {
  lid();
} else if (render_part == "light_pipes") {
  light_pipes();
}

// Preview visualizations (only visible in preview mode, not render)
// Show the boards for context (only when rendering enclosure)
if (render_part == "enclosure") {
  %board_placeholder();
  %rj45_modules_placeholder();
}

// Show the lid above enclosure if enabled
if (show_lid && render_part == "enclosure") {
  translate([0, 0, lid_flush ? wall_height : wall_height + 5])
    %lid();
}

// Show light pipes if enabled
if (show_light_pipes && render_part == "enclosure") {
  translate([0, 0, lid_flush ? 0 : 5])
    %light_pipes();
}
