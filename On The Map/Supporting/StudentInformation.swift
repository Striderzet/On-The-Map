//
//  StudentInformation.swift
//  On The Map
//
//  Created by Tony Buckner on 4/24/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

class studentInformationClass {
    static let sharedInstance = studentInformationClass()
    var studInfo: [studentInfo] = []
}

struct studentInfo {
    
    var firstName = String()
    var lastName = String()
    var latitude = Double()
    var longitude = Double()
    var mediaURL = String()
    
    init(dictionary: [String:AnyObject]) {
        
        if let newFirst = dictionary["firstName"] as? String{
            firstName = newFirst
        }
        
        if let newLast = dictionary["lastName"] as? String{
            lastName = newLast
        }
        
        if let newLat = dictionary["latitude"] as? Double{
            latitude = newLat
        }
        
        if let newLong = dictionary["longitude"] as? Double{
            longitude = newLong
        }
        
        if let newURL = dictionary["mediaURL"] as? String{
            mediaURL = newURL
        }
        
    }
}


