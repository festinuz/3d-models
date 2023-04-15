include <./lib/polyround.scad>

$fn=64;

Include_Logo = true;

/* [Legs] */
Leg_width = 16; // [14:1:30]

// Print rounded plastic legs or leave space for leg cutouts
Leg_type = "cutout"; // [cutout, flat, elevated]

// Print leg-sized tool to help making leg cutouts
Include_leg_cutout_helper_tool = true;

/* [Finger grips] */
// Add two holes that can be used as finger grips
Add_finger_grips = true;
Finger_grip_radius = 9; // [4:12]


mountOuterRad = 8; // [7:15]


// Legs
legsHeight = 7; // Just enough space for vesa bolt head
isRoundedLegs = false;

// Finger grips
fingerGripRad = 9;
fingerGripHeight = 5;

/* [Hidden] */
vesaMountingPointDistance = 100;
roundingRad = 2;

// Base
standDepth = 89;
baseHeight = 4;

// Bolt mount
boltBodyHoleRad = 1.9;
boltCapHoleRad = 3.8;
boltBodyLength = 4;

// Nut mount
nutMountHeight = 4;
nutSideToSideLen = 12;
nutMountOuterRad = 15;
nutMountBorderOffset = 10;

module thinkvisionVesaAdapter() {
    difference() {
        union() {
            basePlate();
            standLegs(legsHeight);
            truncatedNutMount();
            fingerGrips();
        }
        lowerPlateRounding();
        mountHoles();
        nutHole();
        fingerGripHoles();
        logo();
    }
}

module legCutoutTool() {
    x = 2*mountOuterRad;
    y = standDepth;

    legPoints = [
        [0, 0, mountOuterRad],
        [0, y, mountOuterRad],
        [x, y, mountOuterRad],
        [x, 0, mountOuterRad]
    ];

    xOffset = -(vesaMountingPointDistance / 2 + mountOuterRad);
    yOffset = -(standDepth/2 + mountOuterRad);
    translate([xOffset, yOffset, 0])
    rotate(270)
    polyRoundExtrude(
        legPoints,
        2,
        roundingRad,
        0
    );
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

module standLegs(height) {
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
        height,
        legRoundingRad,
        0
    );

    mirror([1, 0, 0])
    polyRoundExtrude(
        legPoints,
        height,
        legRoundingRad,
        0
    );
}

module truncatedNutMount() {
    difference() {
        nutMount();
        standLegs(nutMountHeight+baseHeight);
    }
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
        [-nutMountOuterRad, yMountCenter, nutMountOuterRad]
    ];

    translate([0,0,baseHeight])
    polyRoundExtrude(
        nutMountRightHalfPlatePoints,
        nutMountHeight,
        roundingRad,
        0
    );

    mirror([1, 0, 0])
    translate([0,0,baseHeight])
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
        [x+mountOuterRad, yOuter,              0],
        [xNutMount,       yOuter,              0]
    ];

    translate([0,0,baseHeight])
    polyRoundExtrude(
        nutMountLegConnectorRightHalfPlatePoints,
        nutMountHeight,
        roundingRad,
        0
    );

    mirror([1, 0, 0])
    translate([0,0,baseHeight])
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

module mountHoles() {
    x = vesaMountingPointDistance / 2;
    y = 36.25;

    translate([x, y, 0])
    boltHole();


    translate([-x, y, 0])
    boltHole();
}

module boltHole() {
    translate([0,0,-0.5])
    cylinder(legsHeight+1, r=boltBodyHoleRad);

    translate([0,0, boltBodyLength])
    cylinder(legsHeight-boltBodyLength+0.5, r=boltCapHoleRad);
}

module nutHole() {
    wid = nutSideToSideLen;
    yOffset = -(standDepth/2 - nutMountBorderOffset - nutMountOuterRad);
    bottomOffset = 2;  // Minimum 3d-printable offset
    height = baseHeight + nutMountHeight - bottomOffset+0.5;

    translate([0,yOffset, bottomOffset + height/2])
    hull() {
        cube([wid/1.7,wid,height],center = true);
        rotate([0,0,120])cube([wid/1.7,wid,height],center = true);
        rotate([0,0,240])cube([wid/1.7,wid,height],center = true);
    }
}

module fingerGrips() {
    rad = fingerGripRad;
    height = fingerGripHeight;
    xOffset = (
        (vesaMountingPointDistance/2 - mountOuterRad)
        + nutMountOuterRad
    ) / 2;
    yOffset = -(
        standDepth/2 - nutMountBorderOffset - fingerGripRad
    );

    points = [
        [-rad, -rad, rad],
        [rad, -rad, rad],
        [rad, rad, rad],
        [-rad, rad, rad],
    ];

    translate([xOffset, yOffset, 0])
    polyRoundExtrude(
        points,
        height,
        roundingRad,
        0
    );

    mirror([1, 0, 0])
    translate([xOffset, yOffset, 0])
    polyRoundExtrude(
        points,
        height,
        roundingRad,
        0
    );
}

module fingerGripHoles() {
    rad = fingerGripRad - 2*roundingRad;
    height = fingerGripHeight;
    xOffset = (
        (vesaMountingPointDistance/2 - mountOuterRad)
        + nutMountOuterRad
    ) / 2;
    yOffset = -(
        standDepth/2 - nutMountBorderOffset - fingerGripRad
    );

    points = [
        [-rad, -rad, rad],
        [rad, -rad, rad],
        [rad, rad, rad],
        [-rad, rad, rad],
    ];

    translate([xOffset, yOffset, 0])
    polyRoundExtrude(
        points,
        height,
        -roundingRad,
        0
    );

    mirror([1, 0, 0])
    translate([xOffset, yOffset, 0])
    polyRoundExtrude(
        points,
        height,
        -roundingRad,
        0
    );
}

module logo() {
    if (Include_Logo) {
        getLogo();
    }
}

module getLogo() {
    depth = 2;
    outerRad = 5.5;
    lineWidth = 2;

    outerDia = outerRad * 2;
    sideLen = outerDia * 2 - lineWidth;
    yMountCenter = (
        standDepth / 2 - nutMountBorderOffset - nutMountOuterRad
    );

    translate([0,yMountCenter,6])
    linear_extrude(depth+0.5) {
        difference() {
            circle(outerDia+lineWidth);
            union() {
                difference() {
                    rotate(22.5)
                    circle(outerDia, $fn=8);
                    rotate(22.5)
                    circle(outerDia-lineWidth, $fn=8);
                    square([lineWidth,outerDia*2], center=true);
                }
                translate([-lineWidth, 0, 0])
                    square([lineWidth,sideLen], center=true);
                translate([lineWidth, 0, 0])
                    square([lineWidth,sideLen], center=true);
            }

        }
        
    }
}

thinkvisionVesaAdapter();
legCutoutTool();
