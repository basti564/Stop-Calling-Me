//
//  Scammer.swift
//  Stop Calling Me
//
//  Created by Bastian Oliver Schwickert on 24/12/2019.
//  Copyright © 2019 Bastian Oliver Schwickert. All rights reserved.
//

import Foundation

struct Scammers:Decodable {
    var rows:[ScammerDetail]
}

struct ScammerDetail:Decodable {
    var id:Int
    var Number:String
    var Message:String
    var CALLRef:Int
    var Pause:String
    var CallDuration:String
    var CallCount:String
    var Response:String? = nil
    var short:String
    var InvestigationNotes:String? = nil
}
