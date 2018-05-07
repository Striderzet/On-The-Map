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
    //let studInfoClass = UIApplication.shared.delegate as! studentInformationClass
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var annotations = [MKPointAnnotation]()
        
        //new StudentInfo Array
        //old:appDelegate.studInfo
        for element in studentInformationClass.sharedInstance.studInfo {
            
            let annotation = MKPointAnnotation()
            
            let first = element.firstName
            let last = element.lastName
            annotation.title = "\(first) \(last)"
            
            let lat = CLLocationDegrees(element.latitude)
            let long = CLLocationDegrees(element.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.coordinate = coordinate
            
            annotation.subtitle = element.mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        var annotations = [MKPointAnnotation]()
        
        //new StudentInfo Array
        //appdelegate.studinfo
        for element in studentInformationClass.sharedInstance.studInfo {
            
            let annotation = MKPointAnnotation()
            
            let first = element.firstName
            let last = element.lastName
            annotation.title = "\(first) \(last)"
            
            let lat = CLLocationDegrees(element.latitude)
            let long = CLLocationDegrees(element.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.coordinate = coordinate
            
            annotation.subtitle = element.mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        mapView.delegate = self

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
    @IBAction func logoutMap(_ sender: Any) {
        logoutQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

