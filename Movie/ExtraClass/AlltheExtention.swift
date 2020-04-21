//
//  String+Validation.swift
//  Movie
//
//  Created by Sanjeet on 21/04/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    public func TrimString() -> String {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    
    
    public func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from!), length: utf16.distance(from: from!, to: to!))
    }
    
    public func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: self.TrimString())
        
        return result
    }
    public func phoneNumberValidation(phoneNumber:String) -> Bool {
        let charcterSet = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return phoneNumber == filtered
    }
    
    public func isValidPhone(phone: String) -> Bool {
        
        let PHONE_REGEX = "^09[0-9'@s]{9,9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        return result
        
    }
    
    public func isPasswordSame(password:String,confirmPassword:String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
    
    public func isPwdLenth(password:String,confirmPassword:String) -> Bool {
        if password.count <= 7 && confirmPassword.count <= 7{
            return true
        }else{
            return false
        }
    }
    
    public func checkValide(text:String,validation:String) -> Bool {
        let charcterSet = NSCharacterSet(charactersIn: validation).inverted
        let inputString = text.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return text == filtered
    }
    
    public func isValidAmount(phoneNumber:String) -> Bool {
        let charcterSet = NSCharacterSet(charactersIn: "0123456789.").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return phoneNumber == filtered
    }
    
    public func isValidPhoneWithPlus(phoneNumber:String) -> Bool {
        let charcterSet = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return phoneNumber == filtered
    }
    
    public func isValidPhoneWithOutPlus(phoneNumber: String) -> Bool {
        let charcterSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return phoneNumber == filtered
    }
    
    public func allowedAlpaNumeric(phoneNumber: String) -> Bool {
        let charcterSet = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return phoneNumber == filtered
    }
    
    public func emailAllowedCharacter(phoneNumber: String) -> Bool {
        let charcterSet = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&'*+-/=?^_`{|}~.@").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return phoneNumber == filtered
    }
    
    public func allowedAlpa(phoneNumber: String) -> Bool {
        let charcterSet = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return phoneNumber == filtered
    }
    
    public func isValidUrl() -> Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
}

extension Date {
    
    static func daysBetweenDates(start: Date,endDate: Date) -> Int{
        let calendar: Calendar = Calendar.current
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: endDate)
        return calendar.dateComponents([.day], from: date1, to: date2).day!
    }
    
    func generateDatesArrayBetweenTwoDates(startDate: Date , endDate:Date) ->[Date]{
        var datesArray: [Date] =  [Date]()
        var startDate = startDate
        let calendar = Calendar.current
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        while startDate <= endDate {
            datesArray.append(startDate)
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
            
        }
        return datesArray
    }
}





extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}



extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}



