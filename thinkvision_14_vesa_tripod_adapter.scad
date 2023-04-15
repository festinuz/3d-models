$fn=64;


module thinkvision_vesa_adapter() {
    base_h=4;
    legs_h=8;
    vesa_small_d=4;
    vesa_small_rad=5;
    vesa_big_rad=9;
    hex_d=6;
    hex_w=12;
  
    difference() {
        base(base_h, legs_h);
        translate([50, 20, legs_h])
            fhex(hex_w, 2*hex_d);
        translate([0, 72.5, 0])
            bolt_hole(legs_h, vesa_small_d, vesa_small_rad, vesa_big_rad);
        translate([100, 72.5, 0])
            bolt_hole(legs_h, vesa_small_d, vesa_small_rad, vesa_big_rad);
        translate([50, 50, legs_h-1.1])
            cylinder(2, d=24);
    }

    //color("#335791")
    translate([50, 50, legs_h-2])
        signature();
}


module base(base_h, legs_h) {
    inner_base_w=100;
    outer_base_d=80;
    outer_legs_dia=15;
    
    inner_base_d=outer_base_d - outer_legs_dia;
    outer_bolt_rad=outer_legs_dia/2;
    
    cube([inner_base_w, outer_base_d, base_h]);

    // Add round leg edges
    translate([0,outer_bolt_rad,0])
        cylinder(legs_h, d=outer_legs_dia);
    
    translate([inner_base_w,outer_bolt_rad,0])
        cylinder(legs_h, d=outer_legs_dia);
    
    translate([0,outer_base_d-outer_bolt_rad,0])
        cylinder(legs_h, d=outer_legs_dia);
    
    translate([inner_base_w,outer_base_d-outer_bolt_rad,0])
        cylinder(legs_h, d=outer_legs_dia);

    // Add leg edge connections
    translate([0, inner_base_d, 0])
        cube([inner_base_w, outer_legs_dia, legs_h]);

    translate([-outer_bolt_rad, outer_bolt_rad,0])
        cube([outer_legs_dia, inner_base_d, legs_h]);
    
    translate([inner_base_w-outer_bolt_rad, outer_bolt_rad,0])
        cube([outer_legs_dia, inner_base_d, legs_h]);
        
    // Add center leg and connections
    center_dia = 20;
    center_d_offset = 20;
    
    center_rad = center_dia / 2;
    center_w = inner_base_w / 2;
 
    translate([center_w,center_d_offset,0])
        cylinder(legs_h, d=center_dia);
        
    linear_extrude(legs_h) {
        polygon(
        [
            [0, inner_base_d],
            [center_w-center_rad, center_d_offset],
            [center_w+center_rad, center_d_offset],
            [inner_base_w, inner_base_d],
        ]
        );
    }

    translate([86.5, 40.8, 0])
        round_inner_corner(6,legs_h, 5,4.2);

    translate([13.5, 40.8, 0])
        mirror([1,0,0])
        round_inner_corner(6,legs_h, 5,4.2);
}


module fhex(wid,height){
hull(){
cube([wid/1.7,wid,height],center = true);
rotate([0,0,120])cube([wid/1.7,wid,height],center = true);
rotate([0,0,240])cube([wid/1.7,wid,height],center = true);
}
}

module bolt_hole(legs_h, vesa_small_d, vesa_small_rad, vesa_big_rad) {
    translate([0,0,-0.5]) 
        cylinder(legs_h+1, d=vesa_small_rad);
    
    translate([0,0,vesa_small_d])
        cylinder(legs_h-vesa_small_d+0.5, d=vesa_big_rad);
}

module signature() {
    cylinder(1, d=24);
    linear_extrude(2) {
        difference() {
            circle(10);
            circle(8);
            square([2,20], center=true);
        }
        translate([-2, 0, 0])
            square([2,16], center=true);
        translate([2, 0, 0])
            square([2,16], center=true);
    }
}

module round_inner_corner(rad, h, w, neg_w) {
    linear_extrude(h) {
        difference() {
            translate([-neg_w,0,0])
                square([rad+w+neg_w, rad+w+neg_w+4]);
            circle(rad);
        }
    }
}

thinkvision_vesa_adapter();