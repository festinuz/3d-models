include <./lib/polyround.scad>

$fn=64;

// Consts
vesaMountingPointDistance = 100;
roundingRad = 2;

// If 86: no lower rounding for base plate needed
// If 89: matches closed display with curve,lower rounding
// for base plate needed
// If 94 matches open display with curve, lower rounding
// for base plate needed
standDepth = 89; //[85:94]
mountOuterRad = 8; // [7:15]
baseHeight = 4; // [3:8]

// Legs
legsHeight = 8;
isRoundedLegs = false;

// Nut mount
nutMountHeight = 4;
nutSideToSideSize = 12;
nutMountOuterRad = 15;
nutMountBorderOffset = 10;

module thinkvisionVesaAdapter() {
    difference() {
        union() {
            basePlate();
            standLegs();
            nutMount();
        }
        lowerPlateRounding();
    }
}

module basePlate() {
    xOffset = vesaMountingPointDistance / 2 + mountOuterRad;
    yOffset = standDepth / 2;
    platePoints = [
        [-xOffset, -yOffset, mountOuterRad],
        [-xOffset, yOffset, mountOuterRad],
        [xOffset, yOffset, mountOuterRad],
        [xOffset, -yOffset, mountOuterRad]
    ];
    

    xBeamOffset = vesaMountingPointDistance / 2;
    yBeamOffset = yOffset;
    frontRoundingBeamPoints = [
        [-xBeamOffset, -yBeamOffset, 0],
        [xBeamOffset, -yBeamOffset, 0],
        [xBeamOffset, -yBeamOffset-roundingRad, 0],
        [-xBeamOffset, -yBeamOffset-roundingRad, 0]
    ];

    difference() {
        linear_extrude(baseHeight)
            polygon(polyRound(platePoints,30));
        
        // Base top side front edge rounding
        polyRoundExtrude(
            frontRoundingBeamPoints,
            baseHeight,
            -roundingRad,
            0
        );
    }
}

module standLegs() {
    xOuter = vesaMountingPointDistance / 2 + mountOuterRad;
    xInner = vesaMountingPointDistance / 2 - mountOuterRad;
    y = standDepth / 2;
    legRoundingRad = isRoundedLegs? roundingRad : 0;

    legPoints = [
        [-xOuter, -y, mountOuterRad],
        [-xOuter, y, mountOuterRad],
        [-xInner, y, mountOuterRad],
        [-xInner, -y, mountOuterRad]
    ];

    polyRoundExtrude(
        legPoints,
        legsHeight,
        legRoundingRad,
        0
    );

    mirror([1, 0, 0])
    polyRoundExtrude(
        legPoints,
        legsHeight,
        legRoundingRad,
        0
    );
}

module nutMount() {
    x = vesaMountingPointDistance / 2 - mountOuterRad;
    yOuter = standDepth / 2;
    yInner = standDepth / 2 - 2*mountOuterRad;
    yMountCenter = -yOuter + nutMountBorderOffset;

    nutMountRightHalfPlatePoints = [
        [-nutMountOuterRad, yOuter, 0],
        [x+mountOuterRad, yOuter, 0],
        [x, yInner, 0],
        [nutMountOuterRad, yMountCenter+nutMountOuterRad, 0],
        [nutMountOuterRad, yMountCenter, nutMountOuterRad],
        [0, yMountCenter, 0],
        [-nutMountOuterRad, yMountCenter+nutMountOuterRad, 0]
    ];

    translate([0,0,4])
    polyRoundExtrude(
        nutMountRightHalfPlatePoints,
        nutMountHeight,
        roundingRad,
        0
    );

    mirror([1, 0, 0])
    translate([0,0,4])
    polyRoundExtrude(
        nutMountRightHalfPlatePoints,
        nutMountHeight,
        roundingRad,
        0
    );

    xLegInner = vesaMountingPointDistance/2 - mountOuterRad;
    xNutMount = (nutMountOuterRad + xLegInner) / 2;
    xMiddlePoint = (xLegInner + xNutMount) / 2;

    legConRad = (xLegInner - xNutMount) / 2;

    yMiddlePoint = (
        (yMountCenter + nutMountOuterRad + yInner) / 2 + legConRad
    );
    yLegInner = yMiddlePoint - legConRad;
    yNutMount = yLegInner;
    
    nutMountLegConnectorRightHalfPlatePoints = [
        [nutMountOuterRad, yMountCenter+nutMountOuterRad, 0],
        [xNutMount,       yNutMount,           0],
        [xMiddlePoint,    yMiddlePoint,        legConRad],
        [xLegInner,       yLegInner,           legConRad],
        [xLegInner,       yLegInner-legConRad, 0],
        [x+mountOuterRad, yLegInner-legConRad, 0],
        [x,               yOuter,              0],
        [xNutMount,       yOuter,              0]
    ];

    translate([0,0,4])
    polyRoundExtrude(
        nutMountLegConnectorRightHalfPlatePoints,
        nutMountHeight,
        roundingRad,
        0
    );

    mirror([1, 0, 0])
    translate([0,0,4])
    polyRoundExtrude(
        nutMountLegConnectorRightHalfPlatePoints,
        nutMountHeight,
        roundingRad,
        0
    );
}

module lowerPlateRounding() {
    xInner = vesaMountingPointDistance / 2 + mountOuterRad;
    xOuter = xInner + roundingRad;
    yInner = standDepth / 2;
    yOuter = yInner + roundingRad;
    
    backRoundingPoints = [
        [-xInner, yInner, mountOuterRad],
        [xInner, yInner, mountOuterRad],
        [xInner, yInner-mountOuterRad, 0],
        [xOuter, yInner-mountOuterRad, 0],
        [xOuter, yOuter, 0],
        [-xOuter, yOuter, 0],
        [-xOuter, yInner-mountOuterRad, 0],
        [-xInner, yInner-mountOuterRad, 0]
    ];
    
    polyRoundExtrude(
        backRoundingPoints,
        roundingRad,
        0,
        -roundingRad
    );

    mirror([0, 1, 0])
    polyRoundExtrude(
        backRoundingPoints,
        roundingRad,
        0,
        -roundingRad
    );
}

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

thinkvisionVesaAdapter();