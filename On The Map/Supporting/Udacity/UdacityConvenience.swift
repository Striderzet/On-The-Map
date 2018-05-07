//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Tony Buckner on 4/3/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct UConvenience {
    
    let udacity = Udacity()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func authenticateLogin(completionHandlerForAuth: @escaping (_ type: String, _ success: Bool) -> Void) {
        
        udacity.postUdacity(userName: appDelegate.userName, passWord: appDelegate.passWord) { (data, type, result) in
            
            if result == true {
                
                let range = Range(5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                
                /* Parse the data for 2 parts */
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    print("Could not parse the data as JSON: '\(newData)'")
                    return
                }
                
                //this will return the registered value and unique key
                let acct = parsedResult["account"] as! [String: Any]
                self.appDelegate.registered = acct["registered"]! as! Int
                self.appDelegate.key = acct["key"] as! String
                
                if self.appDelegate.registered == 1 {
                    completionHandlerForAuth(type, true)
                } else {
                    completionHandlerForAuth(type, false)
                }
                
            } else {
                completionHandlerForAuth(type, false)
            }
            
        }
        
    }
    
    func authenticateLogout (completionHandlerForOut: @escaping (_ type: String, _ success: Bool) -> Void) {
        udacity.deleteUdacity { (data, type, result) in
            
            completionHandlerForOut(type, result)
            
        }
    }
}
