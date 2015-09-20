//
//  State.swift
//  Escapade
//
//  Created by Jeffrey Huang on 9/20/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import Foundation

class EscapadeState : NSObject {
    
    enum state {
        case AtHome
        case AtAirport
        case InFlight
        case Landed
        case AtSecondAirport
        case WaitingOnUber
        case AtHotel
    }
    
    var currState:state = state.AtHome
    
    static let sharedInstance = EscapadeState()
}
