//
//  User.swift
//  Movie
//
//  Created by Sanjeet on 21/04/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import UIKit

class User: NSObject {

    class var current: User {
        struct Singleton {
            static let instance = User()
        }
        return Singleton.instance
    }
    
    private struct SerializationKeys {
        static let fullname = "Fullname"
        static let phone = "Phone"
        static let school = "School"
        static let country = "Country"
        static let name = "name"
    }
    
    var fullname: String?
    var phone: String?
    var school: String?
    var country: String?
    var name: String?
    
    func setValue(_ data:[String:Any]) {
        fullname = data[SerializationKeys.fullname] as? String
        phone = data[SerializationKeys.phone] as? String
        school = data[SerializationKeys.school] as? String
        country = data[SerializationKeys.country] as? String
        name = data[SerializationKeys.name] as? String
    }
    
    func save() {
        var data = [String:AnyObject]()
        data[SerializationKeys.fullname] = self.fullname == nil ? "" as AnyObject : self.fullname! as AnyObject
        data[SerializationKeys.phone] = self.phone  == nil ? "" as AnyObject : self.phone! as AnyObject
        data[SerializationKeys.school] = self.school == nil ? "" as AnyObject : self.school! as AnyObject
        data[SerializationKeys.country] = self.country == nil ? "" as AnyObject : self.country! as AnyObject
        data[SerializationKeys.name] = self.name == nil ? "" as AnyObject : self.name! as AnyObject
        UserDefaults.standard.set(data, forKey: "userDefaultUserData")
    }
}
