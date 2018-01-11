//
//  MenuAPIController.swift
//  
//
//  Created by Admin on 16/12/2017.
//

import UIKit

var placename = ""
class MenuAPIController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var placesTable: UITableView!
    var placenames = ["Restaurant","Hospitals","Pharmacy","Parks","Police Stations","Schools","University","Banks","Bus Station","Gym","Cafe","Airport","Fashion","Beauty Salon","Mosque","Shopping Mall","Store","Cinemas"]
    var images = ["restaurant.png","hospital.png","pharmacy.png","park.png","police.png","school.png","university.png","bank.png","bus_station.png","gym.png","cafe.png","airport.png","fashion.png","beauty_salon.png","mosque.png","shopping_mall.png","store.png","movie_theater.png"]

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placenames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = placesTable.dequeueReusableCell(withIdentifier: "places", for: indexPath) as! PlaceViewCell
        cell.placename.text = placenames[indexPath.row]
        cell.placeimage.image = UIImage.init(named: images[indexPath.row])
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Places"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {placename = "restaurant"}
        else if indexPath.row == 1
        {placename = "hospital"}
        else if indexPath.row == 2
        {placename = "pharmacy"}
        else if indexPath.row == 3
        {placename = "park"}
        else if indexPath.row == 4
        {placename = "police"}
        else if indexPath.row == 5
        {placename = "school"}
        else if indexPath.row == 6
        {placename = "university"}
        else if indexPath.row == 7
        {placename = "bank"}
        else if indexPath.row == 8
        {placename = "bus_station"}
        else if indexPath.row == 9
        {placename = "gym"}
        else if indexPath.row == 10
        {placename = "cafe"}
        else if indexPath.row == 11
        {placename = "airport"}
        else if indexPath.row == 12
        {placename = "fashion"}
        else if indexPath.row == 13
        {placename = "beauty_salon"}
        else if indexPath.row == 14
        {placename = "mosque"}
        else if indexPath.row == 15
        {placename = "shopping_mall"}
        else if indexPath.row == 17
        {placename = "store"}
        else if indexPath.row == 18
        {placename = "movie_theater"}
        performSegue(withIdentifier: "Home", sender: self)
           }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
   /* @IBAction func PlacesBtn(_ sender: UIButton) {
       if sender.tag == 0
       {
            placename = "restaurant"
       }
       else  if sender.tag == 1
       {
        placename = "pharmacy"
       }
       else  if sender.tag == 2
       {
        placename = "hospital"
        }
       else  if sender.tag == 3
       {
        placename = "park"
        }
       else  if sender.tag == 4
       {
        placename = "school"
        }
       else  if sender.tag == 5
       {
        placename = "gym"
        }
       else  if sender.tag == 6
       {
        placename = "university"
        }
       else  if sender.tag == 7
       {
        placename = "bank"
        }
       else  if sender.tag == 8
       {
        placename = "cafe"
       }
       else  if sender.tag == 9
       {
        placename = "library"
       }
       else  if sender.tag == 10
       {
        placename = "airport"
       }
       else  if sender.tag == 11
       {
        placename = "atm"
       }
      performSegue(withIdentifier: "Home", sender: self)
        
    }
 */
}
