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
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    // refrence to storage..
    private let storage = Storage.storage().reference()
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    // add profile image
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    @IBOutlet weak var wagChatButton: UIButton!
    
    @IBOutlet weak var dogInfo: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var about: UITextField!
    
    @IBOutlet weak var updateProfileButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var successLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        view.addSubview(imageView)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        setUpElements()
        populateTextFields()
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        
        imageView.addGestureRecognizer(gesture)
        
        // check if there is a value set for the key(user defaults) if yes, download the img
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
              let url = URL(string: urlString) else {
                return
        }
        // download data from the url
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // convert the url to imag
            // make sure UI updated as soon as we get the respond
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        })
    
        task.resume()
        
        // Do any additional setup after loading the view.
        
        
    }
    
    // will be called when user tap on head
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
       // print("Change pic called")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/3
        imageView.frame = CGRect(x: (view.width-size)/1,
                                 y: 70,
                                 width: 100,
                                 height: 100)
        
        imageView.layer.cornerRadius = imageView.width/2
    }
    

    // populate text fields from firebase
    
    func populateTextFields() {
//        dogInfo.text = "pug"
        
        let currentUserUID = (Auth.auth().currentUser?.uid)!
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(currentUserUID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                // need a check if the fields are nil or not
                if document.data()?["dogInfo"] != nil && document.data()?["location"] != nil && document.data()?["about"] != nil  {
                    self.dogInfo.text = document.data()?["dogInfo"]! as? String
                    self.location.text = document.data()?["location"]! as? String
                    self.about.text = document.data()?["about"]! as? String
                }
               
            } else {
                print("Document does not exist")
            }
        }
        // get the current user UID
        // get the fields saved in DB, load the data
        // set it to the fields.text
    
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        successLabel.alpha = 0
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
    
    func showSuccess(_ message:String) {
        successLabel.text = message
        successLabel.alpha = 1
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
            showSuccess("Profile Edited!")
            
            // go back to navigation View controller
            
            let navigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationController) as? UINavigationController
            
            self.view.window?.rootViewController = navigationViewController
            self.view.window?.makeKeyAndVisible()
    }
    }
    
}


