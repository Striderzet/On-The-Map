//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Tony Buckner on 4/3/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct PConvenience {
    
    let parse = Parse()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //GetLocations completion handler for the data
    func authenticateGetLocations (competionHandlerForLocations: @escaping (_ type:String, _ OK: Bool) -> Void){

        parse.getLocationS{ (data, type, result) in
            
            if result == true{
                
                /* Parse the data for 2 parts */
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                let results: [[String:AnyObject]]! = parsedResult["results"] as! [[String:AnyObject]]
                
                /* Use the data! */
                performUIUpdatesOnMain {
                    //put info in StudentInfo Array
                    for dictionary in results{
                        
                        studentInformationClass.sharedInstance.studInfo.append(studentInfo(dictionary: dictionary))
                        //self.appDelegate.studInfo.append(studentInfo(dictionary: dictionary))
                        
                    }
                    //old working array
                    //self.appDelegate.studentInformation = results
                }
                
                
                
                competionHandlerForLocations(type, true)
                
            } else {
                competionHandlerForLocations(type, false)
            }
        }
    }
    
    //PostLocations completion handler
    func authenticatePostLocations (key: String, firstName: String, lastName: String, mapString: String, mediaURL: String, lat: Double, long: Double, competionHandlerPutLocations: @escaping (_ type:String, _ OK: Bool) -> Void){
    
        parse.postLocation(key: key, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, lat: lat, long: long) { (type, OK) in
            
            if OK{
                competionHandlerPutLocations(type, true)
            } else {
                competionHandlerPutLocations(type, false)
            }
            
        }
    
    }
    
    func authenticateUserInformation(uniqueID: String, completionHandlerForNames: @escaping (_ first: String, _ last: String,_ type:String, _ OK: Bool) -> Void) {
        
        parse.getUserInformation(uniqueID: uniqueID) { (data, type, good) in
            
            if good{
                
                /* Parse the data for 2 parts */
                let parsedResult: [String:AnyObject]!
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                } catch {
                    print("Could not parse the data as JSON: '\(data)'")
                    return
                }
                
                var fName = String()
                var lName = String()
                
                //let results = parsedResult["results"]
                let results: [[String:AnyObject]]! = parsedResult["results"] as! [[String:AnyObject]]
                for dict in results{
                    
                    if let newFirstName = dict["firstName"] {
                        fName = newFirstName as! String
                    }
                    
                    if let newLastName = dict["lastName"] {
                        lName = newLastName as! String
                    }
                }
                
                completionHandlerForNames(fName, lName, type, true)
                
            } else {
                completionHandlerForNames("", "", type, false)
            }
            
        }
        
    }
}
