//
//  BaseClass.swift
//  Movie
//
//  Created by Sanjeet on 21/04/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
class BaseClass: NSObject {
    public class var sharedInstance: BaseClass {
        struct Singleton {
            static let instance = BaseClass()
        }
        return Singleton.instance
    }
}

extension UIViewController {
    
    func ShowAlertMessage( _ title:String, _ message:String){
        
       let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
