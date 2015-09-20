//
//  AppDelegate.swift
//  Escapade
//
//  Created by Mosab Elagha on 9/19/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit
import AudioToolbox
import Alamofire
import SwiftyJSON
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MotionEngineDelegate {

    var window: UIWindow?
    var motion:MotionEngine! = nil


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: (
            UIUserNotificationType.Alert), categories: nil))  // types are UIUserNotificationType members
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: (
            UIUserNotificationType.Sound), categories: nil))
        
        return true
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func landed() {
        localNotification("Escapade", body: "We noticed you landed, open our app again and we'll call you an Uber", delay: 3)
    }
    
    func localNotification(action: String, body:String, delay: NSTimeInterval) {
        var localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = action
        localNotification.alertBody = body
        localNotification.fireDate = NSDate(timeIntervalSinceNow: delay)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        AudioServicesPlayAlertSound(1100)
        
        if (EscapadeState.sharedInstance.currState == EscapadeState.state.WaitingOnUber) {
            EscapadeState.sharedInstance.currState = EscapadeState.state.AtHotel
            self.localNotification("Escapade", body: "Your Uber is arriving now, have a great Escapade!", delay: 10);
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.sharedApplication().setKeepAliveTimeout(1000) { () -> Void in
            NSLog("Started tracking");
        }
        
        var backgroundTask = application.beginBackgroundTaskWithExpirationHandler({ () -> Void in
        })
        
        
        switch (EscapadeState.sharedInstance.currState) {
        case EscapadeState.state.AtHome:
            let url = "https://escapade.abrarsyed.com/uber/uberXtime?longitude=-71.05888010000001&latitude=42.3600825"
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                request(.GET, url)
                    .response { (request, response, result, error) -> Void in
                        //                print("\nrepsone", response, "\nrequest", request, "\nresult", result, "\nerror", error)
                        //                print( JSON(data: result!))
                        let ok = JSON(data: result!)
                        self.localNotification("Escapade", body: "Your flight is in two hours and your Uber will be arriving in " + String(Int(ok["estimate"].stringValue)!/60) + " minutes", delay: 5)
                }
            }
            
            break
        case EscapadeState.state.AtAirport:
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                
                self.localNotification("Escapade", body: "Reminder! Your flight is at gate B6 and it is now boarding", delay: 30)
            }
            break
        case EscapadeState.state.InFlight:
            self.motion = MotionEngine()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                self.motion.initialize(self)
            }
            break
        case EscapadeState.state.Landed:
            
            break
        case EscapadeState.state.WaitingOnUber:
            break
        case EscapadeState.state.AtHotel:
            break
        default:
            break
        }
        
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        switch (EscapadeState.sharedInstance.currState) {
        case EscapadeState.state.AtHome:
            EscapadeState.sharedInstance.currState = EscapadeState.state.AtAirport
            break
        case EscapadeState.state.AtAirport:
            EscapadeState.sharedInstance.currState = EscapadeState.state.InFlight
            break
        case EscapadeState.state.InFlight:
            self.motion.endTracking()
            EscapadeState.sharedInstance.currState = EscapadeState.state.Landed
            break
        case EscapadeState.state.Landed:
            let url = "https://escapade.abrarsyed.com/uber/uberXtime?longitude=-71.0064&latitude=42.3631"
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                request(.GET, url)
                    .response { (request, response, result, error) -> Void in
                        //                print("\nrepsone", response, "\nrequest", request, "\nresult", result, "\nerror", error)
                        //                print( JSON(data: result!))
                        let ok = JSON(data: result!)
                        self.localNotification("Escapade", body: "Your Uber will arrive to pick you up from the departure area in " + String(Int(ok["estimate"].stringValue)!/60) + " minutes", delay: 10)
                }
            }
            break
        default:
            break
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

