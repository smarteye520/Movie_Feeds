//
//  SignUpController.swift
//  Movie
//
//  Created by Jin on 4/18/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import ProgressHUD

class SignUpController: UIViewController {
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    var parameter = [String:AnyObject]()
    
    override func viewDidLoad() {
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func didTapCloseButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        let strFirstName = nameTextField.text?.TrimString()
        let strEmail = emailTextField.text?.TrimString()
        let strPassword = passwordTextField.text?.TrimString()
        let strConfirmPassword = repeatPasswordTextField.text?.TrimString()
        
        if strFirstName == "" {
            self.ShowAlertMessage("Error!", "Please enter your name.")
        }else if strEmail == "" {
            self.ShowAlertMessage("Error!", "Please enter your email address.")
        }else if strEmail?.isValidEmail() == false {
            self.ShowAlertMessage("Error!", "Please enter your valid email address.")
        }else if strPassword == "" {
            self.ShowAlertMessage("Error!", "Plese enter your password.")
        }else if strConfirmPassword == "" {
            self.ShowAlertMessage("Error!", "Plese enter your repeat password.")
        }else if strPassword != strConfirmPassword {
            self.ShowAlertMessage("Error!", "Your password doesn't match.")
        }else{
            parameter["name"] = strFirstName as AnyObject
            parameter["email"] = strEmail as AnyObject
            parameter["password"] = strPassword as AnyObject
            self.performSegue(withIdentifier: "registration", sender: self)
            
        }
        /*guard     let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text else {
                return
        }
        
        
        // firebase sign up
        
        if password == repeatPassword {
            
            Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
                guard error == nil else {
                    self.removeHUD()
                    return
                }
                self.saveUserCredentials(username: email, password: password)
                self.updateUserName(name: name)
                
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["name" : name, "email" : email, "uid" : authData!.user.uid]) {(error) in
                    
                    if error != nil {
                        print("erro: \(String(describing: error?.localizedDescription))")
                    } else {
                        print("complete")
                        
                    }
                }
                
                self.displayHUD()
                
            }
            
        } else {
            ProgressHUD.showError("Unable to process your request, please try again")
        }*/
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registration"{
            let viewcontroller = segue.destination as! RegistrationController
            viewcontroller.Parameter = self.parameter
        }
    }
    
    
    func saveUserCredentials(username: String, password: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(username, forKey: Constants.kUserName)
        userDefaults.synchronize()
        // save password into keychain
        let passwordItem = KeychainPasswordItem(service: KeychainConfig.serviceName, account: username, accessGroup: KeychainConfig.accessGroup)
        do {
            try passwordItem.savePassword(password)
        }
        catch let err {
            self.removeHUD()
            fatalError("Error updating keychain: \(err.localizedDescription)")
        }
    }
    
    func updateUserName(name: String) {
        if let user = Auth.auth().currentUser {
            let changeReq = user.createProfileChangeRequest()
            changeReq.displayName = name
            changeReq.commitChanges { (error) in
                self.removeHUD()
                // self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "registration", sender: self)
                
            }
        }
    }
    
    func displayHUD() {
        SHUD.show(self.view, style: SHUDStyle.light, alignment: SHUDAlignment.horizontal, type: SHUDType.loading, text: "Signing up. Please wait...", nil)
    }
    
    func removeHUD() {
        SHUD.hide()
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
