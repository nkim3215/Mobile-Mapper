//
//  ViewController.swift
//  Mobile Mapper
//
//  Created by Nathan Kim on 3/2/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var parks: [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }
    
    @IBAction func whenSearchButtonPressed(_ sender: UIBarButtonItem) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Parks"
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        let search = MKLocalSearch(request: request)
        
        search.start { myResponse, myError in
            guard let response = myResponse else {return}
//            print(response)
            for currentMapItem in response.mapItems {
                self.parks.append(currentMapItem)
                let annotation = MKPointAnnotation()
                annotation.title = currentMapItem.name
                annotation.coordinate = currentMapItem.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    @IBAction func whenZoomButtonPressed(_ sender: UIBarButtonItem) {
        let center = currentLocation.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myRegion = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(myRegion, animated: true)
    }
    
    
}

