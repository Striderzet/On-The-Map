//
//  Udacity.swift
//  On The Map
//
//  Created by Tony Buckner on 1/19/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct Udacity {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //nil data placeholder for escaping closure function
    let holder: String = ""
        
    //function to login to Udacity
    func postUdacity(userName: String, passWord:String, completionHandlerForGET: @escaping (_ data: Data,_ type: String, _ result: Bool) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(passWord)\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        //make request
        let task = session.dataTask(with: request) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                completionHandlerForGET(self.holder.data(using: .utf8)!, "net", false)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForGET(self.holder.data(using: .utf8)!, "log", false)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandlerForGET(self.holder.data(using: .utf8)!, "nil", false)
                return
            }
            
            completionHandlerForGET(data,"good", true)
            
        }
        task.resume()
    }
    
    //logout function
    func deleteUdacity (completionHandlerForDEL: @escaping (_ data: Data,_ type: String, _ result: Bool) -> Void) {
        
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
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                completionHandlerForDEL(self.holder.data(using: .utf8)!, "net", false)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completionHandlerForDEL(self.holder.data(using: .utf8)!, "con", false)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandlerForDEL(self.holder.data(using: .utf8)!, "con", false)
                return
            }
            
            completionHandlerForDEL(data,"good", true)
            
        }
        task.resume()
    }
        
}
