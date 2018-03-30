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

class ViewController: UIViewController {
    
    //view controller objects
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    //set appdelegate variable
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let requests = Udacity.Resquests()
    
    //alert setup for incorrect login
    let alert = UIAlertController(title: "Notification", message: "Invalid Login", preferredStyle: .alert)
    //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {

        //login to Udacity
        requests.postUdacity(userName: userName.text!, passWord: passWord.text!)
        sleep(2)
        
        if appDelegate.registered == 1 {
            
            //after sucessfull login, get info
            requests.getLocationS()
            //print(appDelegate.infoArray)
            
            //this is needed so the getLocationS has time to finish before the segue initiates
            sleep(2)
            performSegue(withIdentifier: "TBController", sender: self)
            
        } else {
            //error popup
            self.present(alert, animated: true)
        }
        //print(appDelegate.registered)
        
    }
    
    @IBAction func quickTest(_ sender: Any) {
        
        //after sucessfull login, get info
        requests.getLocationS()
        //print(appDelegate.infoArray)
        
        //this is needed so the getLocationS has time to finish before the segue initiates
        sleep(2)
        
        performSegue(withIdentifier: "TBController", sender: self)
        
    }
    

}

