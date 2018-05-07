//
//  ViewController.swift
//  On The Map
//
//  Created by Tony Buckner on 12/27/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit
//import MapKit

class MainViewController: UIViewController {
    
    //view controller objects
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var quickButton: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
    //set appdelegate variable
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //API's
    let udacityRequest = Udacity()
    let parseRequest = Parse()
    
    //Convenience Vars
    let udacityConvenience = UConvenience()
    let parseConvenience = PConvenience()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        signUp.titleLabel?.adjustsFontSizeToFitWidth = true
        quickButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        //set global names
        appDelegate.userName = userName.text!
        appDelegate.passWord = passWord.text!
        
        //login to Udacity authenticator
        udacityConvenience.authenticateLogin{ (type, success) in
            performUIUpdatesOnMain {
                if success {
                    self.go(type: type)
                } else {
                    self.stop(type: type)
                }
            }
        }
    }
    
    func go(type: String) {
        
        //after sucessfull login, get info
        parseConvenience.authenticateGetLocations{ (type, OK) in
            performUIUpdatesOnMain {
                if OK {
                    self.performSegue(withIdentifier: "TBController", sender: self)
                } else {
                    self.alerts(type: type)
                }
            }
        }
    }
    
    func stop(type: String){
        alerts(type: type)
    }
    
    //create new Udacity account
    @IBAction func signUpButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    //test button for direct info
    @IBAction func quickTest(_ sender: Any) {
        
        parseConvenience.authenticateGetLocations{ (type, OK) in
            performUIUpdatesOnMain {
                if OK {
                    self.performSegue(withIdentifier: "TBController", sender: self)
                } else {
                    self.alerts(type: type)
                }
            }
        }
    }
}

