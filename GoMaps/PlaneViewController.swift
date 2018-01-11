//
//  PlaneViewController.swift
//  GoMaps
//
//  Created by Admin on 26/12/2017.
//  Copyright © 2017 globiaTechnologies. All rights reserved.
//

import UIKit

class PlaneViewController: UIViewController {
    
    @IBOutlet weak var distancetxt: UILabel!
    @IBOutlet weak var timetxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        distancetxt.text = distance + " km/h"
        if distance != ""
        {
            var time = Double(distance)!
            time = time/813.0
            timetxt.text = String(format: "%.1f", time) + " hrs"
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "No Route Selected for Flight", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {UIAlertAction in
                 self.performSegue(withIdentifier: "back", sender: self)
            })
            alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
           
        }
        
    }

    @IBAction func BackBtn(_ sender: UIButton) {
        if distance == ""
        {
        performSegue(withIdentifier: "back1", sender: self)
        }
        else
        {
        performSegue(withIdentifier: "back", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
