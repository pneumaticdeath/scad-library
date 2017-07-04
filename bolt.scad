/*
 * Bolt & Nut modules for OpenSCAD
 * Copyright 2017, Mitch Patenaude patenaude@gmail.com
 * Licensed under the LGPL 3.0
 */

// Example bolt
bolt(head_height=10,
     head_size=15,
     threads_per_cm=5,
     thread_depth=1,
     shaft_length=30,
     shaft_radius=8);

// Example Nut
translate([0,50,0])
    nut(head_height=10,
        head_size=15,
        hole_radius=8,
        threads_per_cm=5,
        thread_depth=1);    

module bolt(head_height, head_size, threads_per_cm, thread_depth, shaft_length, shaft_radius) 
{
    
    head(head_height, head_size);
    translate([0,0,head_height])
        threaded_shaft(shaft_length, 
                       shaft_radius*1.05, 
                       threads_per_cm, 
                       thread_depth);
}

module nut(head_height, head_size, hole_radius, threads_per_cm, thread_depth)
{
    difference() {
        head(head_height, head_size);
        translate([0,0,-10])
            threaded_shaft(head_height+20, hole_radius, threads_per_cm, thread_depth);                                 
    }                                                                
}
module head(height, size) {
    head_radius = size/(2*sin(30));

    linear_extrude(height=height)
        circle(r=head_radius, $fn=6);
}
module threaded_shaft(length, 
                      radius, 
                      threads_per_cm, 
                      thread_depth) 
{
    twists = length*threads_per_cm*360/10;

    linear_extrude(height=length, 
                   twist=twists) 
        translate([0,thread_depth,0]) 
                circle(radius-thread_depth);
}
