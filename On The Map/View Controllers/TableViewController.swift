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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.infoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //"TCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell")!
        let info = self.appDelegate.infoArray[(indexPath as NSIndexPath).row]
        
        if (info["firstName"] != nil) && (info["lastName"] != nil) && (info["mediaURL"] != nil) {
            //Cell Name and URL info
            let firstName = info["firstName"] as? String
            let lastName = info["lastName"] as? String
            cell.textLabel?.text =  firstName! + " " + lastName!
            cell.detailTextLabel?.text = info["mediaURL"] as? String
            
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let info = self.appDelegate.infoArray[(indexPath as NSIndexPath).row]
        
        UIApplication.shared.open(URL(string: (info["mediaURL"] as? String)!)!, options: [:], completionHandler: nil)
        
    }
    
    
    
    
    
    
}
