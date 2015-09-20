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
    func landed() -> Void
}

class MotionEngine: NSObject {
    
    var manager:CMMotionActivityManager = CMMotionActivityManager()
    var altitudeManager:CMAltimeter = CMAltimeter()
    var delegate:MotionEngineDelegate! = nil
    var currentAltitude:NSNumber = 0
    var queue:NSMutableArray = NSMutableArray()
    var called:Bool = false
    
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
    
    func endTracking() {
        self.altitudeManager.stopRelativeAltitudeUpdates()
    }
    
    func initialize(del: MotionEngineDelegate) {
        
        if (EscapadeState.sharedInstance.currState != EscapadeState.state.InFlight) {
            self.endTracking()
            return
        }
        
        self.delegate = del
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            altitudeManager.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data, error) -> Void in
                
                
                self.currentAltitude = self.currentAltitude.floatValue + data!.relativeAltitude.floatValue;
                var epoch:Int = Int(NSDate().timeIntervalSince1970)
                
                self.queue.addObject(data!.relativeAltitude.floatValue)
                NSLog("%@", data!)
                
                // Check the delta once a minute
                var totalDelta:Float = 0.0
                for (var i = 0; i < self.queue.count; i++) {
                    totalDelta = Float(totalDelta) + self.queue[i].floatValue
                }
                
                var averageDelta:NSNumber = totalDelta/Float(self.queue.count)
                
                if (self.queue.count >= 5) {
                    self.queue.removeObjectAtIndex(0)
                }
                    
                switch (self.currState) {
                    case state.TakingOff:
                        if (averageDelta > 0.6) {
                            self.currState = state.Cruising
                        }
                        NSLog("Taken off");
                        break
                    case state.Cruising:
                        if (averageDelta < 0.3) {
                            self.currState = state.Landing
                        }
                        NSLog("Cruised")
                        break
                    case state.Landing:
                        if (averageDelta < 0.1) {
                            if (self.called == false) {
                                self.delegate.landed()
                                EscapadeState.sharedInstance.currState = EscapadeState.state.Landed
                                self.endTracking()
                                self.called = true
                            }
                            
                        }
                        NSLog("Landed")
                        break
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