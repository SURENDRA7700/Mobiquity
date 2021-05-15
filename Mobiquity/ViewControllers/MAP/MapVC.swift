//
//  MapVC.swift
//  Mobiquity
//
//  Created by surendra on 14/05/21.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(tap)
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        
        loadLocations()
    }
    
    func loadLocations() {

        for eachAddObj in ApiService.sharedManager.locationArray {
            var position = CLLocationCoordinate2D()
            position.latitude = (eachAddObj.location?.coordinate.latitude)!
            position.longitude = (eachAddObj.location?.coordinate.longitude)!
            addAnnotation(location: position)
        }
        
    }

    @objc func longTap(sender: UIGestureRecognizer){
        let locationInView = sender.location(in: mapView)
        let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
        addAnnotation(location: locationOnMap)
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.getAddressFromLatLon(userLatitude: location.latitude, withLongitude: location.longitude) { (addressObj) in
            annotation.title = "\(addressObj.name ?? ""),\(addressObj.locality ?? ""),\(addressObj.subLocality ?? "")"
            annotation.subtitle = addressObj.subLocality
            
            if let index = ApiService.sharedManager.locationArray.firstIndex(where: {$0.name == addressObj.name})
            {
//                ApiService.sharedManager.locationArray.remove(at: index)
            }else{
                ApiService.sharedManager.locationArray.append(addressObj)
            }
            self.mapView.addAnnotation(annotation)
        }
    }

    func getAddressFromLatLon(userLatitude: CLLocationDegrees, withLongitude userLangitude: CLLocationDegrees,completionBlock: @escaping (_: CLPlacemark) ->Void)
    {
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:userLatitude, longitude: userLangitude)
        ceo.reverseGeocodeLocation(loc) {
            (placemarks, error) in
            if error == nil && placemarks!.count > 0 {
                let pm = placemarks! as [CLPlacemark]
                let address = pm.first
                completionBlock(address!)
            }
        }
    }

    
    @IBAction func backTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension MapVC: MKMapViewDelegate,CLLocationManagerDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.black
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
               print("do something")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }

}


class ApiService: NSObject {
    static let sharedManager = ApiService()
    var locationArray : [CLPlacemark] = []
    private override init() {
    }
}
