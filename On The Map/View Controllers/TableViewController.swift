//
//  TableViewController.swift
//  On The Map
//
//  Created by Tony Buckner on 2/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UITableViewController {
    
    //set appdelegate variable
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //let studInfoClass = UIApplication.shared.delegate as! studentInformationClass
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformationClass.sharedInstance.studInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell")!
        let info = studentInformationClass.sharedInstance.studInfo[(indexPath as NSIndexPath).row]
        
        //Cell Name and URL info
        let firstName = info.firstName
        let lastName = info.lastName
        cell.textLabel?.text =  firstName + " " + lastName
        cell.detailTextLabel?.text = info.mediaURL
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let info = studentInformationClass.sharedInstance.studInfo[(indexPath as NSIndexPath).row]
        
        //nil double check
        //if let goURL = info["mediaURL"] as? String
            /*if let goURL = info.mediaURL {
                if goURL != ""{*/
        if info.mediaURL != "" {
            
            UIApplication.shared.open(URL(string: (info.mediaURL))!, options: [:], completionHandler: nil)
            
        }
    }
    @IBAction func logoutList(_ sender: Any) {
        logoutQuestion()
    }
    
}
