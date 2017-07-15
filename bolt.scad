/*
 * Bolt & Nut modules for OpenSCAD
 * Copyright 2017, Mitch Patenaude patenaude@gmail.com
 * Licensed under the LGPL 3.0
 */

// Example 15mm bolt
bolt(head_height=10,
     head_size=15,
     threads_per_cm=5,
     thread_depth=1,
     shaft_length=30,
     shaft_radius=8);

// Example 15mm Nut to fit bolt above
translate([0,50,0])
    nut(head_height=10,
        head_size=15,
        hole_radius=8,
        threads_per_cm=5,
        thread_depth=1);    

// Example 1/2" bolt
color("red") translate([50,0,0])
    bolt(head_height=1/4*25.4,
         head_size=1/2*25.4,
         threads_per_cm=20/2.54,
         thread_depth=1/32*25.4,
         shaft_length=3/4*25.4,
         shaft_radius=1/4*25.4);

// Example 1/2" nut
color("red") translate([50,50,0])
    nut(head_height=1/4*25.4,
        head_size=1/2*25.4,
        hole_radius=1/4*25.4,
        threads_per_cm=20/2.54,
        thread_depth = 1/32*25.4);

/*
 * Bolt module
 * All measurements are in mm, except for the thread pitch, which is 
 * in threads/cm, as labeled.
 *
 * head_height: how thick the head will be in mm
 * head_size: 9 here should yield a 9mm bolt head.  For a 1/4" bolt head
 *    use 1/4*25.4 (25.4 mm/inch)
 * threads_per_cm: raw measurement of thread pitch.  To get threads/inch divide
 *    the value by 2.54
 */
module bolt(head_height, head_size, threads_per_cm, thread_depth, shaft_length, shaft_radius) 
{
    
    head(head_height, head_size);
    translate([0,0,head_height])
        threaded_shaft(shaft_length, 
                       shaft_radius, 
                       threads_per_cm, 
                       thread_depth);
}

/*
 * Nut Module
 *
 * Similar to the bolt module
 *
 * head_height, head_size, thread_depth and threads_per_cm work
 *   the same as the bolt module
 * hole_radius: equivalent to shaft_radius in the bolt.  Will be expanded
 *  (or relieved) by the relief amount.
 *
 */
module nut(head_height, head_size, hole_radius, threads_per_cm, thread_depth, relief=0.25)
{
    difference() {
        head(head_height, head_size);
        translate([0,0,-10])
            threaded_shaft(head_height+20, hole_radius + relief, threads_per_cm, thread_depth); 
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
