//
//  ProfileDetailsViewController.swift
//  WagChat
//
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ProfileDetailsViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dogLabel: UILabel!
    
    @IBOutlet weak var aboutLabel: UILabel!
    
    @IBOutlet weak var messageButton: UIButton!
    
    var selectedUserUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selected User Profile"

        // Do any additional setup after loading the view.
        populateProfileDetails()
    }
    
    func populateProfileDetails() {
        
//        usernameLabel.text = "Tram is great"
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(selectedUserUID!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                // need a check if the fields are nil or not
                if document.data()?["dogInfo"] != nil && document.data()?["location"] != nil && document.data()?["about"] != nil &&  document.data()?["username"] != nil {
                    self.usernameLabel.text = document.data()?["username"]! as? String
                    self.locationLabel.text = "Location: \(document.data()?["location"]! as? String ?? "No Location")"
                    self.dogLabel.text = "Dog Information: \(document.data()?["dogInfo"]! as? String ?? "No Dog Information")"
                    self.aboutLabel.text = "About: \(document.data()?["about"]! as? String ?? "No About Section")"
                }

            } else {
                print("Document does not exist")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func messageButtonTapped(_ sender: Any) {
        print("message selected user")
    }
    
}
