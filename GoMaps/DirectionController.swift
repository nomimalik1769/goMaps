//
//  DirectionController.swift
//  GoMaps
//
//  Created by Admin on 21/12/2017.
//  Copyright © 2017 globiaTechnologies. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import CoreData

enum Location {
    case startLocation
    case destinationLocation
}

var startname = ""
var endname = ""
var scord = ""
var ecord = ""
var distance = ""
@available(iOS 10.0, *)
class DirectionController: UIViewController,  GMSMapViewDelegate ,  CLLocationManagerDelegate  {

    @IBOutlet weak var googleMaps: GMSMapView!
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var favB: UIButton!
    @IBOutlet weak var plane: UIButton!
    @IBOutlet weak var timetxt: UILabel!
    @IBOutlet weak var distxt: UILabel!
    
    var coordinate = CLLocation()
    var coordinate1 = CLLocation()
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //Your map initiation code
      //  let camera = GMSCameraPosition.camera(withLatitude: -7.9293122, longitude: 112.5879156, zoom: 15.0)
        
      //  self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps?.isMyLocationEnabled = true
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.zoomGestures = true
       // self.googleMaps.addSubview(start)
        self.googleMaps.addSubview(favB)
        self.googleMaps.addSubview(plane)
       
        if orig != "" && dest != ""
        {
        let lat = orig.components(separatedBy: ",")[0]
        let long = orig.components(separatedBy: ",")[1]
        coordinate = CLLocation(latitude:  Double(lat)!, longitude:  Double(long)!)
        
        let lat1 = dest.components(separatedBy: ",")[0]
        let long1 = dest.components(separatedBy: ",")[1]
        coordinate1 = CLLocation(latitude:  Double(lat1)!, longitude:  Double(long1)!)
       
            drawPath(startLocation: coordinate, endLocation: coordinate1)
        }
    }
    
    
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = googleMaps
    }
    
    @IBAction func show(_ sender: UIButton)
    {
        if(GMSGeometryIsLocationOnPath(p, path, true))
        {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    
    var p = CLLocationCoordinate2D()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
       
        let location = locations.last
        

                let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.googleMaps.camera = camera
        p = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
        
        let locationTujuan = CLLocation(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        if GMSGeometryIsLocationOnPath(p,path,true)
        {
            let s = locationTujuan.distance(from: locationEnd)
           distxt.text = String(s)
            var time = 0.0
            let mark = GMSMarker(position: self.position)
            mark.title = "Starting Point"
            if travel == "driving"
            {
                mark.icon = UIImage(named: "car-1")
                time = s/80.0
            }
            else if travel == "transit"
            {
                mark.icon = UIImage(named: "bus")
                time = s/50.0
            }
            else if travel == "walking"
            {
                mark.icon = UIImage(named: "walking-1")
                time = s/5.0
            }
            else if travel == "bicycling"
            {
                mark.icon = UIImage(named: "traveler")
                time = s/16.0
            }
            mark.map = self.googleMaps
            distxt.text = distxt.text! + "km/h (" + String(format: "%.1f", time) + "hr)"
        }
        createMarker(titleMarker: "Lokasi Tujuan", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: locationTujuan.coordinate.latitude, longitude: locationTujuan.coordinate.longitude)
        
        createMarker(titleMarker: "Lokasi Aku", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        drawPath(startLocation: location!, endLocation: locationTujuan)
       
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMaps.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker:  GMSMarker) -> Bool {
        googleMaps.isMyLocationEnabled = true
        //   print("tappp")
        return false
    }
    var point = CLLocationCoordinate2D()
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        point = coordinate
        print("COORDINATE \(coordinate)") // when you tapped coordinate
        let coord1 = CLLocation(latitude: position.latitude, longitude: position.longitude)
        let coord2 = CLLocation(latitude: point.latitude, longitude: point.longitude)
        print(path)
        if(GMSGeometryContainsLocation(coordinate, path, true))
        {
            let distance = coord1.distance(from: coord2)/1000
            let action = UIAlertController(title: "Distance", message: "Calculated Distance: \(String(format: "%.2f",distance)) km/h", preferredStyle: .alert)
            let ok:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            action.addAction(ok)
            self.present(action, animated: true, completion: nil)
            //  print(GMSGeometryInterpolate(position,points, 100.0))
        }
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
    
    var travel = "driving"
    
    @IBAction func transit(_ sender: UIButton) {
   if (startLocation.text != "") && (destinationLocation.text != "")
         {
            if sender.tag == 0
            {
                self.travel = "driving"
            }
            else if sender.tag == 1
            {
                self.travel = "transit"
            }
            else if sender.tag == 2
            {
                self.travel = "walking"
            }
            else if sender.tag == 3
            {
                self.travel = "bicycling"
            }
            drawPath(startLocation: locationStart, endLocation: locationEnd)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please Select Points First", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - this is function for create direction path, from start location to desination location
    var path = GMSPath()
    var position = CLLocationCoordinate2D()
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        googleMaps.clear()
        print(travel)
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
       
        var s = locationStart.distance(from: locationEnd)/1000
        if orig != "" && dest != ""
        {
         s = coordinate.distance(from: coordinate1)/1000
        }
        distxt.text = "0.0km/h (0.0 hr)"
        print(String(format: "%.2f", s))
        distxt.text = String(format: "%.1f", s)
        if s > 400
        {
            distance = String(format: "%.1f", s)
        }
        var time = 0.0
        let mark = GMSMarker(position: self.position)
        mark.title = "Starting Point"
        if travel == "driving"
        {
          mark.icon = UIImage(named: "car-1")
          time = s/80.0
        }
        else if travel == "transit"
        {
          mark.icon = UIImage(named: "bus")
          time = s/50.0
        }
        else if travel == "walking"
        {
          mark.icon = UIImage(named: "walking-1")
            time = s/5.0
        }
        else if travel == "bicycling"
        {
            mark.icon = UIImage(named: "traveler")
            time = s/16.0
        }
        mark.map = self.googleMaps
        distxt.text = distxt.text! + "km/h (" + String(format: "%.1f", time) + "hr)"
        print(time)
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=\(travel)&alternatives=true&units=metric"
        
        //transit_mode
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization
            //    let image = UIImage(cgImage: #imageLiteral(resourceName: "man.png") as! CGImage)
            
            let json = JSON(response.value!)
            let routes = json["routes"].arrayValue
            print(routes.count)
            if routes.count > 0
            {
                self.position = CLLocationCoordinate2D(latitude: startLocation.coordinate.latitude, longitude: startLocation.coordinate.longitude)
                let marker = GMSMarker(position: self.position)
                marker.title = "Starting Point"
                marker.icon = UIImage(named: "car-1")
                marker.map = self.googleMaps
                
                var count = 0
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                     let points = routeOverviewPolyline!["points"]?.stringValue
                    self.path = GMSPath.init(fromEncodedPath: points!)!
                    let polyline = GMSPolyline.init(path: self.path)
                   
                    if(count == 0)
                    {
                        polyline.strokeWidth = 10
                        polyline.strokeColor = UIColor.green
                        polyline.map = self.googleMaps
                        count += 1
                    }
                    else if count == 1
                    {
                        polyline.strokeWidth = 10
                        polyline.strokeColor = UIColor.blue
                        polyline.map = self.googleMaps
                        count+=1
                    }
                    
                }
              //  let dest = CLLocationCoordinate2DMake(endLocation.coordinate.latitude, endLocation.coordinate.longitude)
            //    var i = 0
            //    var camera = GMSCameraPosition()
                
           /*
                while(i<3)
                {
                    var marker = GMSMarker(position: self.position)
                    if (i == 0)
                    {
                        marker.map = nil
                        camera = GMSCameraPosition.camera(withLatitude: self.position.latitude,longitude: self.position.longitude,zoom: 10)
                        marker = GMSMarker(position: self.position)
                        self.googleMaps.camera = camera
                    }
                    else if (i == 1)
                    {
                        marker.map = nil
                        camera = GMSCameraPosition.camera(withLatitude: GMSGeometryInterpolate(self.position,dest, 100.0).latitude,longitude: GMSGeometryInterpolate(self.position,dest, 100.0).longitude,zoom: 10)
                        marker = GMSMarker(position: GMSGeometryInterpolate(self.position,dest, 100.0))
                        self.googleMaps.camera = camera
                    }
                    else
                    {
                        marker.map = nil
                       camera = GMSCameraPosition.camera(withLatitude: dest.latitude,longitude: dest.longitude,zoom: 10)
                        marker = GMSMarker(position: dest)
                        self.googleMaps.camera = camera
                    }
                    let degrees = 90.0
                    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                    marker.rotation = degrees
                    marker.title = self.travel
                    marker.icon = UIImage(named: "circle-left")
                    marker.map = self.googleMaps
                    i = i + 1
                }
            
            */
            }
        }
    }
    
    // MARK: when start location tap, this will open the search location
    @IBAction func openStartLocation(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .startLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    // MARK: when destination location tap, this will open the search location
    
    
    @IBAction func planeBtn(_ sender: UIButton) {
        let total = Int(distance)!
        if total >= 450
        {
         performSegue(withIdentifier: "plane", sender: self)
        }
        else
        {
           let alert = UIAlertController(title: "Alert", message: "Distance is too short for flight", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func openDestinationLocation(_ sender: UIButton) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .destinationLocation
        
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func favbtn(_ sender: UIButton) {
      if startLocation.text != "" && destinationLocation.text != ""
      {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let favrecord = NSEntityDescription.insertNewObject(forEntityName: "Favourite", into: context)
        favrecord.setValue(scord, forKey: "scord")
        favrecord.setValue(ecord, forKey: "ecord")
        favrecord.setValue(startname, forKey: "sname")
        favrecord.setValue(endname, forKey: "ename")
        do{
            try context.save()
            let alert = UIAlertController(title: "Favourite", message: "Place Added", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        catch{
            print("Access Denied")
        }
        }
    }
    //AIzaSyAlhRhTekTbiL65tERjeZVOaXcghcIXaVI
    // MARK: SHOW DIRECTION WITH BUTTON
    @IBAction func showDirection(_ sender: UIButton) {
        
        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
        
    }
    
    
}


// MARK: - GMS Auto Complete Delegate, for autocomplete search location
@available(iOS 10.0, *)
extension DirectionController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
        )
        print("\(place.coordinate.latitude),\(place.coordinate.longitude)")
        // set coordinate to text
        if locationSelected == .startLocation {
            startLocation.text = "\(place.name), \(place.formattedAddress!)"
            startname = place.name
            scord = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
            locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "\(place.name)", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        } else {
            destinationLocation.text = "\(place.name), \(place.formattedAddress!)"
            endname = place.name
            ecord = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
            locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "\(place.name)", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        }
        
        
        self.googleMaps.camera = camera
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
    
}
