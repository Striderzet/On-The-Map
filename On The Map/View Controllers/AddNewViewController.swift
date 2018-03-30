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

class AddNewViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var locationEntry: UITextField!
    @IBOutlet weak var URLEntry: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let requests = Udacity.Resquests()
    
    //alerts
    let alert = UIAlertController(title: "", message: "Location Cannot Be Found", preferredStyle: .alert)
    let added = UIAlertController(title: "", message: "Your Location Has Been Added!!", preferredStyle: .alert)
    
    //geocoder variable
    var locationFinder = CLGeocoder()
    
    //new values dictionary
    var newValues: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //alert buttons
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        added.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    //find location and place on map
    @IBAction func findLocation(_ sender: Any) {
        
        locationFinder.geocodeAddressString(locationEntry.text!) { (placemark, error) in
            self.locationProccess(withPlacemark: placemark, error: error)
        }
    }
    
    //send location to list of student locations
    @IBAction func submitLocation(_ sender: Any) {
        
        requests.postLocation(key: newValues["key"] as! String, firstName: newValues["firstName"] as! String, lastName: newValues["lastName"] as! String, mapString: newValues["mapString"] as! String, mediaURL: newValues["URL"] as! String, lat: newValues["lat"] as! Double, long: newValues["long"] as! Double)
        
        sleep(2)
        requests.getLocationS()
        sleep(2)
        
        //self.present(added, animated: true)
        performSegue(withIdentifier: "mainMap", sender: self)
    }
    
    
    //location proccess function to get lat lon
    func locationProccess(withPlacemark placemark: [CLPlacemark]?, error: Error?) {
        
        if error != nil {
            self.present(alert, animated: true)
            
        } else {
            var location: CLLocation?
            
            if let placemark = placemark, placemark.count > 0 {
                location = placemark.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                print("\(coordinate.latitude), \(coordinate.longitude)")
                addNewPin(lat: coordinate.latitude, long: coordinate.longitude)
                
            } else {
                self.present(alert, animated: true)
            }
        }
    }
    
    //function to add pin to the map to show new location
    func addNewPin(lat: Double, long: Double){
        
        //declare annotation
        let annotation = MKPointAnnotation()
        
        //location and key values
        newValues["mapString"] = locationEntry.text
        newValues["key"] = appDelegate.key
        
        //Name
        let first = firstName.text!
        newValues["firstName"] = first
        let last = lastName.text!
        newValues["lastName"] = last
        annotation.title = "\(first) \(last)"
        
        //Coordinates
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        newValues["lat"] = lat
        newValues["long"] = long
        annotation.coordinate = coordinate
        
        //URL
        annotation.subtitle = URLEntry.text
        newValues["URL"] = URLEntry.text
        
        //add annotation pin to map
        self.mapView.addAnnotation(annotation)
        print(newValues)
    }
    
    //------------------------------Pin and annotation functions--------------------------
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.detailCalloutAccessoryView = UIButton(type: .detailDisclosure)
            //pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
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
    
}


