//
//  FavViewController.swift
//  GoMaps
//
//  Created by Admin on 15/12/2017.
//  Copyright © 2017 globiaTechnologies. All rights reserved.
//

import UIKit
import CoreData

var orig = ""
var dest = ""
@available(iOS 10.0, *)
class FavViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var startname = [String]()
    var desname = [String]()
    var startloc = [String]()
    var endloc = [String]()
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var favView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return startname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favView.dequeueReusableCell(withIdentifier: "fav", for: indexPath) as! FavViewCell
        cell.starting.text = startname[indexPath.row]
        cell.ending.text = desname[indexPath.row]
        cell.startlat.text = startloc[indexPath.row]
        cell.endlat.text = endloc[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favourite Places"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dest = endloc[indexPath.row]
        orig = startloc[indexPath.row]
        performSegue(withIdentifier: "favop", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context.fetch(request)
           
            if result.count > 0
            {
               for res in result as! [NSManagedObject]
               {
                if let sname = res.value(forKeyPath: "sname") as? String
                  {
                  
                   let ename = res.value(forKeyPath: "ename") as? String
                   let scord = res.value(forKeyPath: "scord") as? String
                   let ecord = res.value(forKeyPath: "ecord") as? String
                    startname.append(sname)
                    desname.append(ename!)
                    startloc.append(scord!)
                    endloc.append(ecord!)
                    print("Starting Location: \(sname), Ending Location: \(String(describing: ename))")
                    print("Starting Location: \(String(describing: scord)), Ending Location: \(String(describing: ecord))")
                 }
               }
            }
        }
        catch{
            print("Access Denied")
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        performSegue(withIdentifier: "home", sender: self)
    }
   
    @IBAction func forBtn(_ sender: Any) {
        performSegue(withIdentifier: "favop", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

