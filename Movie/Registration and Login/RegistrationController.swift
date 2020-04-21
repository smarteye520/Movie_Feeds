//
//  RegistrationController.swift
//  Movie
//
//  Created by Jin on 4/19/20.
//  Copyright © 2020 xcode365. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import ProgressHUD
import FirebaseDatabase
import FirebaseStorage
import AVFoundation
import SVProgressHUD
class RegistrationController: UIViewController {
    
    let useruid = Auth.auth().currentUser?.uid
    
    var imagePicker:UIImagePickerController!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    var Parameter = [String:AnyObject]()
    let ref = Database.database().reference()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTap)
        
        
        self.nameTextField.autocorrectionType = .no
        self.phoneTextField.autocorrectionType = .no
        self.countryTextField.autocorrectionType = .no
        self.schoolTextField.autocorrectionType = .no
        self.nameTextField.delegate = self
        self.phoneTextField.delegate  = self
        self.countryTextField.delegate = self
        self.schoolTextField.delegate = self
        
        /*imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
       
        profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        profileImage.clipsToBounds = true
    }
    
    @IBAction func doneButtonPress(_ sender: Any) {
        
       let strFullname = nameTextField.text?.TrimString()
        let strPhone = phoneTextField.text?.TrimString()
        let strSchool = schoolTextField.text?.TrimString()
        let strCountry = countryTextField.text?.TrimString()
        
        if strFullname == "" {
            self.ShowAlertMessage("Error!", "Please enter your name.")
        }else if strPhone == "" {
            self.ShowAlertMessage("Error!", "Please enter your phone number")
        }else if strSchool == "" {
            self.ShowAlertMessage("Error!", "Plese enter your school name.")
        }else if strCountry == "" {
            self.ShowAlertMessage("Error!", "Plese enter your country name.")
        }else{
           
            let email = Parameter["email"] as? String
            let password = Parameter["password"] as? String
            let name = Parameter["name"] as? String
            Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
                if let error = error {
                    print("Signup error: \(error.localizedDescription)")
                    return
                }
                let imageName = UUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
                guard let uid = result?.user.uid else { return }
                
                if let uploadData = self.profileImage.image!.jpegData(compressionQuality: 0.1) {
                    storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        storageRef.downloadURL(completion: { (url, error) in
                            if let error = error {
                                print(error)
                                return
                            }
                            guard let photoUrl = url else { return }
                            let values = ["Fullname": strFullname, "Phone": strPhone, "School": strSchool,"Country":strCountry,"name":name,"email":email, "imageUrl": photoUrl.absoluteString]                            
                            
                            let ref = Database.database().reference()
                            let usersReference = ref.child("users").child(uid)
                            usersReference.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: {
                                (err, ref) in
                               
                                if err != nil {
                                    print(err!)
                                    return
                                }else{
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let Home = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabBarViewController
                                    let navigation = UINavigationController.init(rootViewController: Home)
                                    UIApplication.shared.windows.first?.rootViewController = navigation
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                }
                            })
                        })
                    })
                }
            }
        }
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        /*self.present(imagePicker, animated: true, completion: nil)*/
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.isEditing = false
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .overFullScreen
        let actionSheet =  UIAlertController(title:nil, message:nil, preferredStyle: UIAlertController.Style.actionSheet)
        let libButton = UIAlertAction(title: "Photo Libray", style: UIAlertAction.Style.default){ (libSelected) in
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        actionSheet.addAction(libButton)
        let cameraButton = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (camSelected) in
            
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                    imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    self.present(imagePicker, animated: true, completion: nil)
                } else {
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                        DispatchQueue.main.async {
                            if granted {
                                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                                self.present(imagePicker, animated: true, completion: nil)
                            } else {
                                self.ShowAlertMessage("Error!", "Please allow camera from setting of your app.")
                            }
                        }
                    })
                }
            }
            else{
                actionSheet.dismiss(animated: false, completion: nil)
                let alert = UIAlertController(title: "Error!", message: "Camera not available", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                    alert.dismiss(animated: true, completion: nil)
                }))
            }
        }
        actionSheet.addAction(cameraButton)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (cancelSelected) in }
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion:nil)
    }
    
    /*@objc func handleSelectProfileImageView() {
        
        let pickerController =  UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }*/
    
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.profileImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension RegistrationController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


