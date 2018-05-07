//
//  Parse.swift
//  On The Map
//
//  Created by Tony Buckner on 4/2/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct Parse {
    
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //nil data placeholder
    let holder: String = ""
    
    func getUserInformation(uniqueID: String, completionHandlerForID: @escaping(_ data: Data, _ type:String, _ good: Bool) -> Void){
        
        
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22" + uniqueID + "%22%7D"
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                completionHandlerForID(self.holder.data(using: .utf8)!, "net", false)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForID(self.holder.data(using: .utf8)!, "info", false)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandlerForID(self.holder.data(using: .utf8)!, "nil", false)
                return
            }
            
            completionHandlerForID(data, "good", true)
        }
        task.resume()
        
    }
    
    //working function
    func getLocationS(completionHandlerForDATA: @escaping (_ data: Data, _ type:String, _ result: Bool) -> Void) {
        
        //this gets multiple locations at once from the API
        
        //set up URL request
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        //application ID
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        //API ID
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        //setup shared URL session
        let session = URLSession.shared
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                completionHandlerForDATA(self.holder.data(using: .utf8)!, "net", false)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForDATA(self.holder.data(using: .utf8)!, "info", false)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandlerForDATA(self.holder.data(using: .utf8)!, "nil", false)
                return
            }
            
            //data completion handler
            completionHandlerForDATA(data, "good", true)
            
        }
        
        //run task
        task.resume()
    }
    
    //WORKING
    func postLocation(key: String, firstName: String, lastName: String, mapString: String, mediaURL: String, lat: Double, long: Double, completionHandlerGoodSend: @escaping (_ type:String, _ GO: Bool) -> Void){
        
        //this function posts a new location
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //real data
        request.httpBody = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(lat), \"longitude\": \(long)}".data(using: .utf8)
        
        //data template
        //request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                completionHandlerGoodSend("net", false)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerGoodSend("info", false)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandlerGoodSend("nil", true)
                return
            }
            
            //data went through good
            completionHandlerGoodSend("good", true)
        }
        task.resume()
    }
}
