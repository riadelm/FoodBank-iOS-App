//
//  Info.swift
//  Food Bank System
//
//  Created by Riad El Mahmoudy on 6/29/20.
//  Copyright © 2020 MeetTheNeed. All rights reserved.
//

import UIKit

final class Info: Codable{
    var id: Int?
    var firstName: String?
    var lastName: String?
    var dateOfBirth: String?
    var email: String?
    var homeAddress: String?
    var currentWeek: String?
    var numberOfBaskets: Int?
    var registrationDate: String?
    var residencyProofStatus: String?
    var studentStatus:String?
    
    init(id: Int?){
        self.id = id
    }

}
