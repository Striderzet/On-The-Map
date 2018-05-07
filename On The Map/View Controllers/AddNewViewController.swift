//
//  AddNewViewController.swift
//  On The Map
//
//  Created by Tony Buckner on 3/27/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddNewViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var locationEntry: UITextField!
    @IBOutlet weak var URLEntry: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
     //API's
    let udacityRequest = Udacity()
    let parseRequest = Parse()
    
    //Convenience Vars
    let udacityConvenience = UConvenience()
    let parseConvenience = PConvenience()
    
    //code for activity indicator
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    //alerts
    let alert = UIAlertController(title: "", message: "Location Cannot Be Found", preferredStyle: .alert)
    let added = UIAlertController(title: "", message: "Your Location Has Been Added!!", preferredStyle: .alert)
    
    //geocoder variable
    var locationFinder = CLGeocoder()
    
    //new values dictionary
    var newValues: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //alert buttons
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        added.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    //find location and place on map
    @IBAction func findLocation(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        //get user info will go here
        parseConvenience.authenticateUserInformation(uniqueID: appDelegate.key) { (first, last, type, OK) in
            
            if OK {
                performUIUpdatesOnMain {
                    if (self.locationEntry.text != "") && (self.URLEntry.text != "") {
                        
                        self.locationFinder.geocodeAddressString(self.locationEntry.text!) { (placemark, error) in
                            if error != nil {
                                self.alerts(type: "geo")
                                //present(self.alert, animated: true)
                            }
                            self.locationProccess(fName: first, lName: last, withPlacemark: placemark, error: error)
                        }
                    }else {
                        self.activityIndicator.stopAnimating()
                        self.submitInfoAlert()
                    }
                }
            } else {
                self.alerts(type: type)
            }
        }
    }
    
    //send location to list of student locations
    @IBAction func submitLocation(_ sender: Any) {
        
        parseConvenience.authenticatePostLocations(key: newValues["key"] as! String, firstName: newValues["firstName"] as! String, lastName: newValues["lastName"] as! String, mapString: newValues["mapString"] as! String, mediaURL: newValues["URL"] as! String, lat: newValues["lat"] as! Double, long: newValues["long"] as! Double){ (type, GO) in
            
            if GO {
                
                self.parseConvenience.authenticateGetLocations{ (type, OK) in
                    performUIUpdatesOnMain {
                        if OK {
                            self.present(self.added, animated: true)
                        } else {
                            self.alerts(type: type)
                        }
                    }
                }
                
            } else{
                performUIUpdatesOnMain {
                    self.alerts(type: type)
                }
            }
        }
    }
    
    //location proccess function to get lat lon
    func locationProccess(fName: String, lName:String, withPlacemark placemark: [CLPlacemark]?, error: Error?) {
        
        if error != nil {
            self.alerts(type: "geo")
            //self.present(alert, animated: true)
            
        } else {
            
            var location: CLLocation?
            
            if let placemark = placemark, placemark.count > 0 {
                location = placemark.first?.location
            }
            
            if let location = location {
                
                let coordinate = location.coordinate
                addNewPin(first: fName, last: lName, lat: coordinate.latitude, long: coordinate.longitude)
                
                //activate button
                submitButton.isEnabled = true
                submitButton.isHidden = false
                
                //zoom into location
                let span = MKCoordinateSpanMake(10.00, 10.00)
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), span: span)
                mapView.setRegion(region, animated: true)
                
                 self.activityIndicator.stopAnimating()
                
            } else {
                
                self.present(alert, animated: true)
            }
            
        }
    }
    
    //function to add pin to the map to show new location
    func addNewPin(first:String, last:String, lat: Double, long: Double){
        
        //declare annotation
        let annotation = MKPointAnnotation()
        
        //location and key values
        newValues["mapString"] = locationEntry.text
        newValues["key"] = appDelegate.key
        
        //Name
        //let first = firstName.text!
        newValues["firstName"] = first
        //let last = lastName.text!
        newValues["lastName"] = last
        annotation.title = "\(first) \(last)"
        
        //Coordinates
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        newValues["lat"] = lat
        newValues["long"] = long
        annotation.coordinate = coordinate
        
        //URL
        annotation.subtitle = "https://" + URLEntry.text!
        newValues["URL"] = "https://" + URLEntry.text!
        
        //add annotation pin to map
        self.mapView.addAnnotation(annotation)
        
    }
    
    //------------------------------Pin and annotation functions--------------------------
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .purple
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("pintapped")
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showActivityIndicator(uiView: UIViewController) {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .clear
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        
        container.addSubview(activityView)
        self.view.addSubview(container)
        
        //actInd.startAnimating()
    }
    
    
}


