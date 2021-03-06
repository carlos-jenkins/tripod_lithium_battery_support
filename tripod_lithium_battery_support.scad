/**
 * Calculate the hypotenuse of a right triangle given its two cathetus.
 */
function hypotenuse(cathetus1, cathetus2) =
    sqrt(pow(cathetus1, 2) + pow(cathetus2, 2));

/**
 * Creates a square truncated pyramid given its base and top sides and height.
 */
module truncated_pyramid(base_side, top_side, height) {
    rotate(a=45) cylinder(
        h=height,
        r1=(hypotenuse(base_side, base_side) / 2),
        r2=(hypotenuse(top_side, top_side) / 2),
        $fn=4
    );
}

/**
 * Creates the piece that hooks into the tripod quick release bay.
 * This is for Dolica ST-500 or compatible tripods.
 */
module tripod_base(base_side, top_side, height, wall) {
    scaling = (base_side - wall * 2) / base_side;
    union() {
        difference() {
            truncated_pyramid(base_side, top_side, height);
            translate([0, 0, -0.1]) scale(scaling) {
                truncated_pyramid(base_side, top_side, height);
            }
        }
        translate([0, 0, height]) {
            cube([top_side, top_side, 1], center=true);
        }
    }
}

/**
 * Creates the piece that supports the battery.
 */
module battery_support(width, length, height) {
    translate([width / -2, length / -2, 0]) {
        cube([width, length, height]);
    }
}

/**
 * Creates the final piece with the tripod quick release plate and the battery
 * support.
 */
module tripod_lithium_battery_support(
        base_bottom, base_top, base_height, base_wall,
        support_width, support_length, support_height,
        base_distance_from_edge) {
    support_translate = (
        (support_length / 2) - (base_distance_from_edge + (base_bottom / 2))
    );

    union() {
        translate([0, 0, -base_height]) {
            tripod_base(base_bottom, base_top, base_height, base_wall);
        }
        translate([0, support_translate, 0]) {
            battery_support(support_width, support_length, support_height);
        }
    }
}


/**
 * This are the main dimensions of the tripod support for a large lithium
 * battery. See README.rst for details.
 */
base_bottom = 43.30;
base_top = 35.20;
base_height = 8.6;
base_wall = 3;

support_width = 55;
support_length = 90;
support_height = 4;

base_distance_from_edge = 16;

tripod_lithium_battery_support(
    base_bottom, base_top, base_height, base_wall,
    support_width, support_length, support_height,
    base_distance_from_edge
);
