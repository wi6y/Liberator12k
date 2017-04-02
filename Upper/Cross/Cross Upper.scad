//$t=0.8;
use <../../Meta/Manifold.scad>;
use <../../Meta/Resolution.scad>;
use <../../Vitamins/Pipe.scad>;
use <../../Vitamins/Rod.scad>;
use <../../Lower/Receiver Lugs.scad>;
use <../../Lower/Lower.scad>;
use <../../Lower/Trigger.scad>;
use <Reference.scad>;
use <Frame.scad>;
use <Sidebars.scad>;

module CrossFittingQuadrail2d(rod=Spec_RodFiveSixteenthInch(),
                     rodClearance=RodClearanceLoose()) {
  hull() {
    Quadrail2d(rod=rod, rodClearance=rodClearance, wallTee=WallTee(),
               clearFloor=true, clearCeiling=false);

    // Grip flat
    translate([ReceiverCenter()-0.1,-GripWidth()/2])
    square([0.1, GripWidth()]);
  }
}

module CrossInserts(width=0.25, height=0.75, slotHeight=1.25,
                    angles=[90, 270], clearance=0.005,
                    cutter=false, alpha=1) {

  color("SteelBlue", alpha)
  translate([-ReceiverCenter(),0,0])
  Sidebars(width=width, height=height,
           length=ReceiverLugFrontMaxX()+ReceiverCenter(),
           angles=angles, clearance=clearance);

  if (cutter)
  translate([-slotHeight/2,0,0])
  Sidebars(width=width, height=height, length=slotHeight,
           angles=angles, cutter=true, clearance=clearance);
}

module CrossUpperFront($fn=40, alpha=1) {
  color("Orange", alpha)
  render(convexity=4)
  difference() {
    union() {
      translate([ReceiverLugFrontMaxX(),0,0])
      mirror([1,0,0])
      rotate([0,90,0])
      hull() {
        linear_extrude(height=ReceiverLugFrontMaxX())
        CrossFittingQuadrail2d();

        // Protect the charging handle
        translate([0,0,ReceiverLugFrontMaxX()-0.1-ReceiverIR()])
        linear_extrude(height=ReceiverIR()+0.1)
        translate([0,-ReceiverIR()])
        mirror([1,0])
        square([ReceiverCenter()+0.5,ReceiverID()]);
      }

      translate([0,0,-ReceiverCenter()])
      ReceiverLugFront(extraTop=ManifoldGap());
    }

    translate([-ManifoldGap(),0,0])
    Frame();

    Breech();

    CrossInserts(cutter=true);

    ChargingHandleCutout();

    // Tee
    ReferenceTeeCutter(topLength=0.01);
  }
}

module ChargingHandleCutout(width=0.25) {
  translate([ReceiverLugRearMinX(), -width*0.55, ReceiverCenter()])
  cube([abs(ReceiverLugRearMinX())+ReceiverIR(), width*1.1, 0.75]);
}

module CrossUpperBack(alpha=1) {

  color("Gold", alpha)
  render(convexity=4)
  difference() {
    union() {

      translate([ReceiverLugRearMinX(),0,0])
      rotate([0,90,0])
        linear_extrude(height=abs(ReceiverLugRearMinX()))
      hull() {
        CrossFittingQuadrail2d();


        // Protect the charging handle
        translate([0,-ReceiverIR()])
        mirror([1,0])
        square([ReceiverCenter()+0.5,ReceiverID()]);
      }

      translate([0,0,-ReceiverCenter()])
      ReceiverLugRear(extraTop=1, teardropAngle=-90);
    }

    ChargingHandleCutout();

    Stock(ReceiverTee(), StockPipe());

    ReferenceTeeCutter(topLength=0.01);

    CrossInserts(cutter=true);

    translate([-ManifoldGap(),0,0])
    Frame();
  }
}

Frame();
Receiver();
Breech();
Stock();
CrossInserts();
CrossUpperFront(alpha=0.25);
CrossUpperBack(alpha=0.25);


// Plated Front
*!scale(25.4)
translate([0,0,ReceiverCenter()+WallFrameFront()])
rotate([0,90,0])
CrossUpperFront();

// Plated Back
*!scale(25.4)
translate([0,0,-ReceiverLugRearMinX()])
rotate([0,-90,0])
CrossUpperBack();

// Plated Back Modifier
*!scale(25.4)
render()
intersection() {
  translate([0,0,ReceiverCenter()+WallFrameBack()])
  rotate([0,-90,0])
  CrossUpperBack();

  translate([0.7,-2,-ManifoldGap()])
  cube([2,4,0.75+ManifoldGap(2)]);
}