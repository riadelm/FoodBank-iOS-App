//
//  ManualView.swift
//  Food Bank System
//
//  Created by Riad El Mahmoudy on 8/31/20.
//  Copyright © 2020 MeetTheNeed. All rights reserved.
//

import Foundation
import UIKit

class ManualViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextView!
    @IBOutlet weak var lastName: UITextView!
    @IBOutlet weak var dateOfBirth: UITextView!
    
    @IBOutlet weak var moneySent: UITextView!
    
    
    @IBOutlet weak var typeOfBasketButton: UIButton!
    
    @IBOutlet weak var typeOfBasketScroll: UIPickerView!
    
}
