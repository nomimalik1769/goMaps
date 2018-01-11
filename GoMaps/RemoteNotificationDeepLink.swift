//
//  RemoteNotificationDeepLink.swift
//  GoMaps
//
//  Created by Admin on 02/01/2018.
//  Copyright © 2018 globiaTechnologies. All rights reserved.
//

import UIKit

let RemoteNotificationDeepLinkAppSectionKey : String = "article"
class RemoteNotificationDeepLink: NSObject {
    var article : String = ""
    
    class func create(userInfo : [NSObject : AnyObject]) -> RemoteNotificationDeepLink?
    {
        let info = userInfo as NSDictionary
        
        let articleID = info.object(forKey: RemoteNotificationDeepLinkAppSectionKey) as! String
        
        var ret : RemoteNotificationDeepLink? = nil
        if !articleID.isEmpty
        {
            ret = RemoteNotificationDeepLinkArticle(articleStr: articleID)
        }
        return ret
    }
    
    private override init()
    {
        self.article = ""
        super.init()
    }
    
    init(articleStr: String)
    {
        self.article = articleStr
        super.init()
    }
    
    final func trigger()
    {
      DispatchQueue.main.async()
        {
            //NSLog("Triggering Deep Link - %@", self)
            self.triggerImp()
                { (passedData) in
                    // do nothing
            }
        }
    }
    
    private func triggerImp(completion: ((AnyObject?)->(Void)))
    {
        
        completion(nil)
    }
}

class RemoteNotificationDeepLinkArticle : RemoteNotificationDeepLink
{
    var articleID : String!
    
    override init(articleStr: String)
    {
        self.articleID = articleStr
        super.init(articleStr:articleStr)
    }
    
    private func triggerImp(completion: @escaping ((AnyObject?)->(Void)))
    {
            triggerImp()
            { (passedData) in
                
               // var vc = UIViewController()
                
                // Handle Deep Link Data to present the Article passed through
                //let path = ""
                if self.articleID == "path"
                {
                }
                let current = NSURL(string: "com.googleusercontent.apps.1078057947832-787mhfguc4e41irbq4e7959eil56vuk6://article")
         //       let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if UIApplication.shared.canOpenURL(current! as URL)
                {
                    UIApplication.shared.open(current! as URL, options: ["":""], completionHandler: nil)
                }
                else {
                UIApplication.shared.open(NSURL(string: "https://itunes.apple.com")! as URL)
                }
                 completion(nil)
        }
    }
}
