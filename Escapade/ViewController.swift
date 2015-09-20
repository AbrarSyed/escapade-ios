//
//  ViewController.swift
//  Escapade
//
//  Created by Mosab Elagha on 9/19/15.
//  Copyright © 2015 Mosab Elagha. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var uberButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func uberAction(sender: AnyObject) {
        performSegueWithIdentifier("loginSuccess", sender: self)
    }
}