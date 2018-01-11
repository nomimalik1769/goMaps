//
//  ViewController.swift
//  GoMaps
//
//  Created by Admin on 13/12/2017.
//  Copyright © 2017 globiaTechnologies. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import GooglePlacePicker
import Alamofire
import AlamofireImage
import SwiftyJSON
import Firebase
import GoogleSignIn

class ViewController: UIViewController,CLLocationManagerDelegate, GMSPlacePickerViewControllerDelegate, UITableViewDelegate,UITableViewDataSource, GIDSignInUIDelegate,GIDSignInDelegate,GMSMapViewDelegate{
    
    //sidemenu controls
    @IBOutlet weak var sidetable: UITableView!
     @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var googleView: GIDSignInButton!
    @IBOutlet weak var TapView: UIButton!
    @IBOutlet weak var MappVieww: GMSMapView!
    var sideplaces = ["Image and Email","Your Location","Share Location","Map Type","Traffic Model", "Air Distance","Saved Maps","Sign Out"]
    var sidetemp = ["Image and Email","Your Location","Share Location","Map Type","Traffic Model", "Air Distance","Saved Maps",""]
    var sideimages = ["","current","share.png","layer.png","lights.png","airplane-icon.png","list.png","logout.png"]
    var sideimage = ["","current","share.png","layer.png","lights.png","airplane-icon.png","list.png",""]
    ///////////////////////////
    
    var x = -250.0
    @IBOutlet weak var searchtxt: UITextField!
    let config = GMSPlacePickerConfig(viewport: nil)
     var locationStart = CLLocation()
    @IBOutlet weak var Mapview: UIView!
    @IBOutlet weak var searchbtn: UIButton!
     @IBOutlet weak var directiontxt: UIButton!
    
    @IBOutlet weak var voiceControl: UIButton!
    @IBOutlet weak var menucontrol: UIButton!
    @IBOutlet weak var maptype: UIButton!
     var locationSelected = Location.startLocation
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
   // var mapView: GMSMapView!
    var zoomLevel: Float = 13.0
    var images = ""
    var names = ""
    var imageUrl = URL(string: "")
   
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print(error)
            return
        }
        guard let authentication = (user.authentication)  else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        print(credential)
        /* if let prevUser =  Auth.auth().currentUser
         {
         let alert = UIAlertController(title: "Dear \(String(describing: prevUser.displayName))", message: "Already SignIn", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default , handler: nil)
         alert.addAction(action)
         self.window?.rootViewController?.present(alert, animated: true, completion: nil)
         }
         else { */
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            self.images = (user?.photoURL?.absoluteString)!
            self.names = (user?.displayName)!
            print(self.images)
            self.imageUrl = URL(string: self.images)!
            self.TapView.isUserInteractionEnabled = true
            self.googleView.frame = CGRect(x: 60.0, y: 665.0, width: 250.0, height: 150.0)
            self.y = 665.0
            self.sidetable.reloadData()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User Dissconnected From App")
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0)
        {
          
        }
        else if (indexPath.row == 1)
        {
       let camera = GMSCameraPosition.camera(withLatitude: center.latitude,longitude: center.longitude, zoom: zoomLevel)
            print(center)
            MappVieww = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            MappVieww.isMyLocationEnabled = true
            MappVieww.camera = camera
            if x == 0.0 {
                sideView.frame = CGRect(x: -250.0, y: 0.0, width: 230.0, height: 668.0)
                TapView.frame = CGRect(x: 375.0, y: 0.0, width: 175.0, height: 668.0)
                x = -250.0
                TapView.isUserInteractionEnabled = false
            }
            
        }
        else if indexPath.row == 2
        {
            let actionSheet = UIAlertController(title: "share With", message: "Select Option", preferredStyle: UIAlertControllerStyle.actionSheet)
            var urlString = ""
            let MessengerTypeAction = UIAlertAction(title: "Messenger", style: UIAlertActionStyle.default) { (alertAction) -> Void in
             if self.images != ""
             {
                urlString = "\(self.center),\(self.images),\(self.names)"
                urlString = urlString.replacingOccurrences(of: " ", with: "")
                let url  = NSURL(string: "messenger://send?text=\(String(describing: urlString))")
                if UIApplication.shared.canOpenURL(url! as URL) {
                    UIApplication.shared.open(url! as URL)
                }
                else{
                    print("Messenger is not Installed")
                }
             }
             else{
                print("SignIn First")
                }
            }
            let WhatsAppTypeAction = UIAlertAction(title: "WhatsApp", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                if self.images != ""
             {
                urlString = "com.googleusercontent.apps.1078057947832-787mhfguc4e41irbq4e7959eil56vuk6://article/\(self.center.latitude),\(self.center.longitude),\(self.images),\(self.names)"
                print(urlString)
                urlString = urlString.replacingOccurrences(of: " ", with: "")
                let url  = NSURL(string: "whatsapp://send?text=\(String(describing: urlString))")
                if UIApplication.shared.canOpenURL(url! as URL) {
                    UIApplication.shared.open(url! as URL)
                }
                else{
                    print("WhatsApp is not Installed")
                }
             }
             else{
                 print("SignIn First")
                }
            }
            
            let TwitterTypeAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default) { (alertAction) -> Void in
               if self.images != ""
               {
                urlString = "com.googleusercontent.apps.1078057947832-787mhfguc4e41irbq4e7959eil56vuk6://article/\(self.center),\(self.images),\(self.names)"
                urlString = urlString.replacingOccurrences(of: " ", with: "")
                let url  = NSURL(string: "twitter://send?text=\(String(describing: urlString))")
                if UIApplication.shared.canOpenURL(url! as URL) {
                    UIApplication.shared.open(url! as URL)
                }
                else{
                    print("Twitter is not Installed")
                }
               }
               else{
                print("SignIn First")
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            }
           // let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 32, height: 32))
           // imageView.image = message
         //   actionSheet.view.addSubview(imageView)
            MessengerTypeAction.setValue(UIImage(named: "messenger.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
            WhatsAppTypeAction.setValue(UIImage(named: "whatsapp.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
            TwitterTypeAction.setValue(UIImage(named: "twitter.png")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
            actionSheet.addAction(WhatsAppTypeAction)
            actionSheet.addAction(MessengerTypeAction)
            actionSheet.addAction(TwitterTypeAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true, completion: nil)
            if x == 0.0 {
                sideView.frame = CGRect(x: -250.0, y: 0.0, width: 230.0, height: 668.0)
                TapView.frame = CGRect(x: 375.0, y: 0.0, width: 175.0, height: 668.0)
                x = -250.0
                TapView.isUserInteractionEnabled = false
            }
            
        }
        else if indexPath.row == 3
        {
            let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                self.MappVieww.mapType = GMSMapViewType.normal
            }
            
            let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                self.MappVieww.mapType = GMSMapViewType.terrain
            }
            
            let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                self.MappVieww.mapType = GMSMapViewType.hybrid
            }
            
            
            let SatelliteMapTypeAction = UIAlertAction(title: "Satellite", style: UIAlertActionStyle.default) { (alertAction) -> Void in
                self.MappVieww.mapType = GMSMapViewType.satellite
            }
            
            let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                
            }
            
            actionSheet.addAction(normalMapTypeAction)
            actionSheet.addAction(terrainMapTypeAction)
            actionSheet.addAction(hybridMapTypeAction)
            actionSheet.addAction(SatelliteMapTypeAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true, completion: nil)
            if x == 0.0 {
                sideView.frame = CGRect(x: -250.0, y: 0.0, width: 230.0, height: 668.0)
                TapView.frame = CGRect(x: 375.0, y: 0.0, width: 175.0, height: 668.0)
                x = -250.0
                TapView.isUserInteractionEnabled = false
            }
        }
        else if indexPath.row == 4
        {
           let cell = tableView.cellForRow(at: indexPath)!
            if MappVieww.isTrafficEnabled == false
            {
                cell.backgroundColor = UIColor.blue
                 MappVieww.isTrafficEnabled = true
                
            }
            else{
                 cell.backgroundColor = UIColor.white
                 MappVieww.isTrafficEnabled = false
            }
            if x == 0.0 {
                sideView.frame = CGRect(x: -250.0, y: 0.0, width: 230.0, height: 668.0)
                TapView.frame = CGRect(x: 375.0, y: 0.0, width: 175.0, height: 668.0)
                x = -250.0
                TapView.isUserInteractionEnabled = false
            }
        }
        else if indexPath.row == 5
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PlaneViewController") as! PlaneViewController
            present(vc, animated: true, completion: nil)
        }
        else if indexPath.row == 6
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FavViewController") as! FavViewController
           self.tabBarController?.present(vc, animated: true, completion: nil)
        }
       else if indexPath.row == 7
        {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("SignOut")
                images = ""
                names = ""
                sidetable.reloadData()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideplaces.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 130.0
        }
        else {
            return UITableViewAutomaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = sidetable.dequeueReusableCell(withIdentifier: "sidemenu", for: indexPath) as! SideMenuCell
        if indexPath.row == 0
        {
            //cell.menuName.isHidden = true
            //cell.menuImage.isHidden = true
            if images != ""
            {
                cell.SignIN.isHidden = true
                cell.ProfilePic.isHidden = false
                cell.ProfileName.isHidden = false
                cell.ProfilePic.af_setImage(withURL: imageUrl!)
                cell.ProfileName.text = names
            }
           else
            {
                cell.ProfilePic.isHidden = true
                cell.ProfileName.isHidden = true
                cell.SignIN.isHidden = false
            }
            cell.backImage.image = UIImage.init(named: "photo")
            cell.SignIN.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        }
        else{
        cell.ProfileName.isHidden = true
        cell.ProfilePic.isHidden = true
        cell.backImage.isHidden = true
        cell.SignIN.isHidden = true
        cell.menuName.isHidden = false
        cell.menuImage.isHidden = false
        if images == ""
        {
            cell.menuName.text = sidetemp[indexPath.row]
            cell.menuImage.image = UIImage.init(named: sideimage[indexPath.row])
        }
        else{
        cell.menuName.text = sideplaces[indexPath.row]
        cell.menuImage.image = UIImage.init(named: sideimages[indexPath.row])
        }
        }
        
        return cell
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: [:])
    }
    
      var y = 665.0
    @objc func buttonClicked(sender : UIButton!) {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
         TapView.isUserInteractionEnabled = false
        if y == 665.0 {
             TapView.frame = CGRect(x: 200.0, y: 0.0, width: 175.0, height: 668.0)
             TapView.isUserInteractionEnabled = true
            googleView.frame = CGRect(x: 60.0, y: 320.0, width: 250.0, height: 150.0)
            y = 320.0
        }
        else if (y == 320.0)
        {
            TapView.isUserInteractionEnabled = false
            TapView.frame = CGRect(x: 375.0, y: 0.0, width: 175.0, height: 668.0)
            googleView.frame = CGRect(x: 60.0, y: 665.0, width: 250.0, height: 150.0)
            y = 665.0
        }
        
    }
   
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
        self.MappVieww.delegate = self
        self.MappVieww?.isMyLocationEnabled = true
        
//
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        MappVieww.delegate = self
//      //  locationManager.requestWhenInUseAuthorization()
//        locationManager.requestAlwaysAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startMonitoringSignificantLocationChanges()
//
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
        
        
        
        //  view.addSubview(Mapview)
        
            
            
        
            
        
        
    
        //mapView.isMyLocationEnabled = true
        searchtxt.layer.cornerRadius = 5.0
        searchtxt.layer.masksToBounds = true
        searchtxt.layer.borderColor = UIColor.cyan.cgColor
        searchtxt.layer.borderWidth = 4.0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        locationManager.startUpdatingLocation()
//        if center != nil
//        {
//        let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!,longitude: (locationManager.location?.coordinate.longitude)!, zoom: zoomLevel)
//        mapView = GMSMapView.map(withFrame: MappVieww.bounds, camera: camera)
//        center = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
//        self.MappVieww.addSubview(mapView)
//        }
        
        
        
        if lbl != ""
        {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(lbl,completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error ?? "")
                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                    self.searchtxt.text = placemark.name
                    self.searchbtn.isHidden = true
                    let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 14.0)
                    self.createMarker(titleMarker: placemark.name!, iconMarker: #imageLiteral(resourceName: "user_location"), latitude: coordinates.latitude, longitude: coordinates.longitude)
                    self.MappVieww.camera = camera
                    lbl = ""
                }
            })
        }
        if placename != ""
        {
            
            DispatchQueue.main.async {
                
                
                let lato = "\(self.center.latitude),\(self.center.longitude)"
                
                let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lato)&radius=500&type=\(placename)&key=AIzaSyDzQaMWzObCZO5XB-oDBstNtK5oD2Hsn7c&sensor=true"
                var lat = [JSON]()
                var lng = [JSON]()
                
                
                // lat.forEach({ (ansa) in
                // })
                URLCache.shared.removeAllCachedResponses()
                Alamofire.SessionManager.default
                    .requestWithoutCache(url).responseJSON{ response in
                        
                        print(response.result)
                        
                        let json = JSON(response.result.value!)
                        print(json)
                        let result = json["results"].arrayValue
                        if result.count == 0
                        {
                            let alert = UIAlertController(title: "Alert", message: "No \(placename) near you", preferredStyle: UIAlertControllerStyle.alert)
                            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        let geometry = result.map({$0["geometry"] })
                        let loc = geometry.map({$0["location"]})
                        lat = loc.map({$0["lat"]})
                        lng = loc.map({$0["lng"]})
                        let name = result.map({$0["name"]})
                        // print("lat: \(lat), long:\(lng)")
                        var i = 0
                        while i < lat.count {
                            if i == 6
                            {
                                break
                            }
                            self.createMarker(titleMarker: String(describing: name[i]), iconMarker: UIImage.init(named: placename)!, latitude: lat[i].doubleValue, longitude: lng[i].doubleValue)
                            i = i + 1
                        }
                }
            }
        }
            
            self.MappVieww?.isMyLocationEnabled = true
        
    }
    @IBAction func TapBtn(_ sender: UIButton) {
        if x == 0.0 {
            sideView.frame = CGRect(x: -250.0, y: 0.0, width: 230.0, height: 668.0)
            TapView.frame = CGRect(x: 375.0, y: 0.0, width: 175.0, height: 668.0)
            self.googleView.frame = CGRect(x: 60.0, y: 665.0, width: 250.0, height: 150.0)
            self.y = 665.0
            x = -250.0
            TapView.isUserInteractionEnabled = false
            
        }
        
    }
    
    
    @IBAction func MenuBtn(_ sender: UIButton) {
   
            TapView.isUserInteractionEnabled = true
            
        if (x == -250.0)
        {
        sideView.frame = CGRect(x: 0.0, y: 0.0, width: 230.0, height: 668.0)
         TapView.frame = CGRect(x: 200.0, y: 0.0, width: 175.0, height: 668.0)
            x = 0.0
        }
       
        
    }
    
    
    @IBAction func VoiceBtn(_ sender: UIButton) {
      if lbl == ""
      {
       performSegue(withIdentifier: "voice", sender: self)
      }
     
    }
  
    @IBAction func googleBtn(_ sender: UIButton) {
       
    }
    
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = MappVieww
    }
    /*
     view.addSubview(Mapview)
     view.addSubview(searchtxt)
     view.addSubview(searchbtn)
     view.addSubview(directiontxt)
     view.addSubview(maptype)
     view.addSubview(voiceControl)
     view.addSubview(menucontrol)
     view.addSubview(sideView)
     view.addSubview(TapView)
     view.addSubview(googleView)
     
 */
     var center = CLLocationCoordinate2D()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //  MappVieww.isMyLocationEnabled = true
       let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: zoomLevel)
        self.MappVieww.camera = camera
        center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        //self.MappVieww.addSubview(mapView)
        locationManager.stopUpdatingLocation()
//        Mapview.addSubview(mapView)
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            mapView.animate(to: camera)
//        }
    }
    
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            MappVieww.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item)
    }
   
    
    @IBAction func ForwardBtn(_ sender: UIButton) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .startLocation
        // Change text color
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func MaptypeBtn(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Map Types", message: "Select map type:", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let normalMapTypeAction = UIAlertAction(title: "Normal", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.MappVieww.mapType = GMSMapViewType.normal
        }
        
        let terrainMapTypeAction = UIAlertAction(title: "Terrain", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.MappVieww.mapType = GMSMapViewType.terrain
        }
        
        let hybridMapTypeAction = UIAlertAction(title: "Hybrid", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.MappVieww.mapType = GMSMapViewType.hybrid
        }
        
        
        let SatelliteMapTypeAction = UIAlertAction(title: "Satellite", style: UIAlertActionStyle.default) { (alertAction) -> Void in
            self.MappVieww.mapType = GMSMapViewType.satellite
        }
        
        let cancelAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
            
        }
        
        actionSheet.addAction(normalMapTypeAction)
        actionSheet.addAction(terrainMapTypeAction)
        actionSheet.addAction(hybridMapTypeAction)
        actionSheet.addAction(SatelliteMapTypeAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)

    }
    
    
    @IBAction func DirectionBtn(_ sender: UIButton) {
        
    }
    
    
    @IBAction func SearchLoc(_ sender: UITextField) {
       //  Mapview = placePicker.view
        //Mapview.addSubview(Mapview)
       
        
    }
   
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
        print("No place selected")
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
      
        viewController.dismiss(animated: true, completion: nil)
    print(place.coordinate.latitude,",",place.coordinate.longitude)
        print()
        print("Place name \(place.name)")
        print("Place address \(String(describing: place.formattedAddress))")
        print("Place attributions \(String(describing: place.attributions))")
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        

        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
//        MappVieww.clear()
//        locationManager = CLLocationManager()
//        MappVieww = nil
//        center = CLLocationCoordinate2D()
        
       // mapView.removeFromSuperview()
        
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
        )
        
        // set coordinate to text
        if locationSelected == .startLocation {
            searchtxt.text = place.name
            searchbtn.isHidden = true
            locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: place.name, iconMarker: #imageLiteral(resourceName: "user_location"), latitude: locationStart.coordinate.latitude, longitude: locationStart.coordinate.longitude)
        }
        
        self.MappVieww.camera = camera
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
extension Alamofire.SessionManager{
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)// also you can add URLRequest.CachePolicy here as parameter
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            // TODO: find a better way to handle error
            print(error)
            return request(URLRequest(url: URL(string: "http://google.com/")!))
        }
    }
}
