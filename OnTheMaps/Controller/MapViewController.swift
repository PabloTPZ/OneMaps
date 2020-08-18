//
//  MapViewController.swift
//  OnTheMaps
//
//  Created by Pablo Perez Zeballos on 8/10/20.
//  Copyright © 2020 Pablo Perez Zeballos. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlets and properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsPins()
    }
    
    // MARK: Logout
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.activityIndicator.startAnimating()
        UdacityClient.logout { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                           let alertVC = UIAlertController(title: "Error", message: "Error logging out.", preferredStyle: .alert)
                           alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                           self.present(alertVC, animated: false)
                }
            }
        }
    }
    
    // MARK: Refresh map
    
    @IBAction func refreshMap(_ sender: UIBarButtonItem) {
        getStudentsPins()
    }
    
    // MARK: Add map annotations
    
    func getStudentsPins() {
        self.activityIndicator.startAnimating()
        UdacityClient.getStudentLocations() { locations, error in
            if error == nil {
                self.mapView.removeAnnotations(self.annotations)
                self.annotations.removeAll()
                self.locations = locations ?? []
                for dictionary in locations ?? [] {
                    let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                    let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let first = dictionary.firstName
                    let last = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    self.annotations.append(annotation)
                }
                DispatchQueue.main.async {
                    self.mapView.addAnnotations(self.annotations)
                    self.activityIndicator.stopAnimating()
                }
                
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(message: "Could not load locations try later", title: "Error")
                }
            }
        }
    }
    
    // MARK: Map view data source
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle {
                openLink(toOpen ?? "")
            }
        }
    }
    
}

