//
//  ViewController.swift
//  Food Bank System
//
//  Created by Riad El Mahmoudy on 5/30/20.
//  Copyright © 2020 MeetTheNeed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    //MARK: - Navigation
     @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }


}



