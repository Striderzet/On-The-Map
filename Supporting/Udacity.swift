//
//  Udacity.swift
//  On The Map
//
//  Created by Tony Buckner on 1/19/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class Udacity {
    
    struct Resquests {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //------------------------------------API Request functions----------------------------------------
        
        //working function
        func getLocationS() {
            
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
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    print("Your request returned a status code other than 2xx!")
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                
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
                //print(results)
                performUIUpdatesOnMain {
                    //self.mapView.reloadInputViews()
                    self.appDelegate.infoArray = results
                }
            }
            
            //run task
            task.resume()
        }
        
        func getLocation(){
            
            //this gets one locations at once from the API
            
            //set up URL request
            var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D")!)
            //application ID
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            //API ID
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            
            //setup shared URL session
            let session = URLSession.shared
            
            //start task session exception handler and task code
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error...
                    return
                }
                print(String(data: data!, encoding: .utf8)!)
            }
            
            //run task
            task.resume()
            
        }
        
        func postLocation(key: String, firstName: String, lastName: String, mapString: String, mediaURL: String, lat: Double, long: Double){
            
            //this function posts a new location
            
            var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
            
            request.httpMethod = "POST"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //real data
            request.httpBody = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \"\(lat)\", \"longitude\": \"\(long)\"}".data(using: .utf8)
            
            //data template
            //request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    print("There was an error with your request: \(error!)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    print("Your request returned a status code other than 2xx!")
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                
                print(String(data: data, encoding: .utf8)!)
            }
            task.resume()
            
        }
        
        func updateLocation(key: String, firstName: String, lastName: String, mapString: String, mediaURL: String, lat: Double, long: Double) {
            
            //this updates a current location
            
            let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
            
            request.httpMethod = "PUT"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //real data
            request.httpBody = "{\"uniqueKey\": \"\(key)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \"\(lat)\", \"longitude\": \"\(long)\"}".data(using: .utf8)
            
            //data template
            //request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error…
                    return
                }
                print(String(data: data!, encoding: .utf8)!)
            }
            task.resume()
            
        }
        
        //function to login to Udacity 
        func postUdacity(userName: String, passWord:String) {
            
            var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(passWord)\"}}".data(using: String.Encoding.utf8)
            //request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
            let session = URLSession.shared
            
            //make request
            let task = session.dataTask(with: request) { data, response, error in
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    print("There was an error with your request: \(error!)")
                    self.appDelegate.registered = 0
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    print("Your request returned a status code other than 2xx!")
                    self.appDelegate.registered = 0
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    self.appDelegate.registered = 0
                    return
                }
                
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
                
                print("it worked")
                //print(self.appDelegate.registered)
                print(acct)
                //print(String(data: newData, encoding: .utf8)!)
                //print(parsedResult)
                print("done")
            }
            task.resume()
        }
        
        func deleteUdacity() {
            
            //function to delete session so user can logout
            
            var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
            request.httpMethod = "DELETE"
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error…
                    return
                }
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print(String(data: newData!, encoding: .utf8)!)
            }
            task.resume()
            
        }
        
        func getUdacity() {
            
            //function gets data after logged in
            
            let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/3903878747")!)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error...
                    return
                }
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range) /* subset response data! */
                print(String(data: newData!, encoding: .utf8)!)
            }
            task.resume()
            
        }

    }
}
