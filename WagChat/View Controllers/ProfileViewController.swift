//
//  ChatsViewController.swift
//  WagChat
//
//  Created by Tram Bui on 1/28/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ProfileViewController: UIViewController {
    @IBOutlet weak var wagChatButton: UIButton!
    
    @IBOutlet weak var dogInfo: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var about: UITextField!
    
    @IBOutlet weak var updateProfileButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleFilledButton(updateProfileButton)
        
    }
    
    func validateFields() -> String? {
        
        // check that all fields are filled in
        
        if dogInfo.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || location.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || about.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func wagChatButtonTapped(_ sender: Any) {
        let navigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationController) as? UINavigationController
        
        self.view.window?.rootViewController = navigationViewController
        self.view.window?.makeKeyAndVisible()
    }
    @IBAction func updateProfileButtonTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else {
            // unless you specify that the data should be merged into the existing document
            // document will be overwritten
            // db.collection("cities").document("BJ").setData([ "capital": true ], merge: true)
            let dogInformation = dogInfo.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let locationCity = location.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let aboutSection = about.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let db = Firestore.firestore()
            db.collection("users").document(String((Auth.auth().currentUser?.uid)!)).setData([
                            "location" : locationCity,
                            "dogInfo" : dogInformation,
                            "about" : aboutSection
                        ], merge: true) { (error) in
                            if error != nil {
                                // show error message
                                print("Error saving user data")
                            }
                        }

                        
        
    }
    }
    
}
