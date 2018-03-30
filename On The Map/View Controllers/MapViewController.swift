//
//  MapViewController.swift
//  On The Map
//
//  Created by Tony Buckner on 2/8/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //set appdelegate variable
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //let req: Udacity.Resquests!
    var NL: [[String: Any]] = []
    //var NL: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //real data
        //getLocationS()
        //print(appDelegate.infoArray)
        
        //test data
        let locations = hardCodedLocationData()
        //appDelegate.infoArray = hardCodedLocationData()
        
        var annotations = [MKPointAnnotation]()
        
        for dictionary in appDelegate.infoArray {
        //for dictionary in locations {
            
            //In testing, there have been nil values that throw fatal errors when trying to do a simple run. I have placed value nil checks to stop the program from trying to populate a field if it is nil, so the appdoesnt get killed while testing.
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            
            if (dictionary["firstName"] != nil) && (dictionary["lastName"] != nil) {
                let first = dictionary["firstName"] as! String
                let last = dictionary["lastName"] as! String
                
                annotation.title = "\(first) \(last)"
            }
            
            if (dictionary["latitude"] != nil) && (dictionary["longitude"] != nil) {
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                annotation.coordinate = coordinate
            }
            
            //checking media URL for nil
            if dictionary["mediaURL"] != nil{
                let mediaURL = dictionary["mediaURL"] as! String
                annotation.subtitle = mediaURL
            }
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //test data for map pin population
    func hardCodedLocationData() -> [[String : Any]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z",
                "firstName" : "Jessica",
                "lastName" : "Uelmen",
                "latitude" : 28.1461248,
                "longitude" : -82.75676799999999,
                "mapString" : "Tarpon Springs, FL",
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
                "objectId" : "kj18GEaWD8",
                "uniqueKey" : 872458750,
                "updatedAt" : "2015-03-09T22:07:09.593Z"
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z",
                "firstName" : "Gabrielle",
                "lastName" : "Miller-Messner",
                "latitude" : 35.1740471,
                "longitude" : -79.3922539,
                "mapString" : "Southern Pines, NC",
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                "objectId" : "8ZEuHF5uX8",
                "uniqueKey" : 2256298598,
                "updatedAt" : "2015-03-11T03:23:49.582Z"
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z",
                "firstName" : "Jason",
                "lastName" : "Schatz",
                "latitude" : 37.7617,
                "longitude" : -122.4216,
                "mapString" : "18th and Valencia, San Francisco, CA",
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                "objectId" : "hiz0vOTmrL",
                "uniqueKey" : 2362758535,
                "updatedAt" : "2015-03-10T17:20:31.828Z"
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z",
                "firstName" : "Jarrod",
                "lastName" : "Parkes",
                "latitude" : 34.73037,
                "longitude" : -86.58611000000001,
                "mapString" : "Huntsville, Alabama",
                "mediaURL" : "https://linkedin.com/in/jarrodparkes",
                "objectId" : "CDHfAy8sdp",
                "uniqueKey" : 996618664,
                "updatedAt" : "2015-03-13T03:37:58.389Z"
            ] , [
                "createdAt" : "2017-03-11T02:48:18.321Z",
                "firstName" : "Tony",
                "lastName" : "Buckner",
                "latitude" : 34.73037,
                "longitude" : -106.58611000000001,
                "mapString" : "Nowhere, Alabama",
                "mediaURL" : "https://linkedin.com/in/tbuckner26",
                "objectId" : "CDHfAy8sdp",
                "uniqueKey" : 996618665,
                "updatedAt" : "2017-03-13T03:37:58.389Z"
            ]
        ]
    }
}

