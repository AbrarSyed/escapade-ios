//
//  AirplaneMotionEngine.swift
//  Escapade
//
//  Created by Jeffrey Huang on 9/20/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit
import CoreMotion

protocol MotionEngineDelegate {
    func landed() -> Bool
}

class MotionEngine: NSObject {
    
    var manager:CMMotionActivityManager = CMMotionActivityManager()
    var altitudeManager:CMAltimeter = CMAltimeter()
    var delegate:MotionEngineDelegate! = nil
    var currentAltitude:NSNumber = 0
    var totalDelta:NSNumber = 0
    var totalMeasurements:Int = 0
    
    var prevAccelerometer:CMAccelerometerData! = nil
    enum state {
        case TakingOff
        case Cruising
        case Landing
    }
    
    var currState:state = state.TakingOff
    
    func delta(prev: Double, curr: Double) -> Double {
        return prev - curr
    }
    
    func initialize(del: MotionEngineDelegate) {
        self.delegate = del
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            altitudeManager.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data, error) -> Void in
                self.currentAltitude = self.currentAltitude.floatValue + data!.relativeAltitude.floatValue;
                var epoch:Int = Int(NSDate().timeIntervalSince1970)
                
                self.totalDelta = self.totalDelta.floatValue + data!.relativeAltitude.floatValue
                self.totalMeasurements += 1
                NSLog("%@", data!)
                
                // Check the delta once a minute
                if ((epoch % 6) == 0) {
                    
                    var averageDelta:NSNumber = self.totalDelta.floatValue/Float(self.totalMeasurements)
                    
                    switch (self.currState) {
                    case state.TakingOff:
                        if (averageDelta < 0.3) {
                            self.currState = state.Cruising
                        }
                        NSLog("Taken off");
                        break
                    case state.Cruising:
                        if (averageDelta < 0) {
                            self.currState = state.Landing
                        }
                        NSLog("Cruised")
                        break
                    case state.Landing:
                        if (averageDelta < 0.2) {
                            self.delegate.landed()
                        }
                        NSLog("Landed")
                        break
                    }
                    
                    self.totalDelta = 0.0
                    self.totalMeasurements = 0
                }
                
            })
        } else {
            self.manager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (activity) -> Void in
                
                
                NSLog("%@", activity!);
//                var xDelta = 0.0
//                var yDelta = 0.0
//                var zDelta = 0.0
//                if (self.prevAccelerometer != nil)
//                {
//                    xDelta = self.delta(self.prevAccelerometer.acceleration.x, curr: data!.acceleration.x)
//                    yDelta = self.delta(self.prevAccelerometer.acceleration.y, curr: data!.acceleration.y)
//                    zDelta = self.delta(self.prevAccelerometer.acceleration.z, curr: data!.acceleration.z)
//                }
//                
//                var inc = 0
//                var dec = 0
//                
//                // Not significant delta
////                if (!(xDelta < 0.01 && xDelta > -0.01)) {
////                    
////                } else {
////                    if (xDelta < 0) {
////                        dec++;
////                    } else {
////                        inc++;
////                    }
////                }
////                
////                if (!(yDelta < 0.01 && yDelta > -0.01)) {
////                    
////                } else {
////                    if (yDelta < 0) {
////                        dec++;
////                    } else {
////                        inc++;
////                    }
////                }
////                
////                if (!(zDelta < 0.01 && zDelta > -0.01)) {
////                    
////                } else {
////                    if (zDelta < 0) {
////                        dec++;
////                    } else {
////                        inc++;
////                    }
////                }
//                
//                if (yDelta < -0.05) {
//                    NSLog("Landing");
//                } else if (yDelta > 0.05) {
//                    NSLog("Taking off");
//                } else {
//                    NSLog("Cruising");
//                }
                
            })
        }
    }
    
}