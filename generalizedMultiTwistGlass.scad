/*
 * A simple mutli-twist glass/vase model.
 * Copyright 2017, Mitch Patenaude patenaude@gmail.com
 * Licensed under the LGPL 3.0
 */

num_sides=7;
radius=15;
wall_thickness=1;
section_height=20;
base_thickness=2;
num_sections=3;
twist=90;
num_slices=100;


// Solid base
linear_extrude(height=base_thickness, 
               twist = twist*base_thickness/section_height, 
               slices=num_slices*base_thickness/section_height)
    circle(r=radius, center = true, $fn=num_sides);

// Hollow for the remainder of the bottom section
translate([0,0,base_thickness])
     rotate([0,0,-1*twist*base_thickness/section_height])
         linear_extrude(height = section_height-base_thickness,
                        twist = twist-twist*base_thickness/section_height, 
                        slices=num_slices-num_slices*base_thickness/section_height) 
            difference() {
                circle(r = radius, $fn=num_sides);
                circle(r = radius-wall_thickness, $fn=num_sides);
            }

// hollow for all upper sections
if (num_sections > 1) 
    for (n=[1:num_sections-1]) {
        num_twists = n%2;
        dir = 1-2*num_twists;
        translate([0,0,n*section_height])
            rotate([0,0,-1*num_twists*twist])
                linear_extrude(height = section_height, 
                               twist = dir*twist,
                               slices = num_slices) 
                    difference() {
                        circle(r = radius, $fn=num_sides);
                        circle(r = radius-wall_thickness, $fn=num_sides);
                    }
    }
