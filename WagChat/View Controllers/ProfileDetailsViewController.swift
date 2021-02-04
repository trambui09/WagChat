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
        setUpElements()
        populateProfileDetails()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(messageButton)
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
        
        

//        chatViewController?.user2Name = user["username"]!
//        chatViewController?.user2UID = user["uid"]!
//        chatViewController?.user2ImgUrl = user["photoUrl"]!
//
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(selectedUserUID!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                
                print("is it getting to here?")
                
                let chatViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.chatViewController) as? ChatViewController
                // need a check if the fields are nil or not
                if document.data()?["uid"] != nil && document.data()?["photoUrl"] != nil &&  document.data()?["username"] != nil {
                    
                    print("what about here?")
                    chatViewController?.user2Name = document.data()?["username"]! as? String
                    chatViewController?.user2UID = self.selectedUserUID!
                    chatViewController?.user2ImgUrl = document.data()?["photoUrl"]! as? String
                    

//                    let thirdNavigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.thirdNavigationViewController) as? UINavigationController
////
//                    thirdNavigationViewController?.pushViewController(chatViewController!, animated: true)
                    
                    self.view.window?.rootViewController = chatViewController
                    self.view.window?.makeKeyAndVisible()
                   
                }

            } else {
                print("Document does not exist")
            }
//        self.view.window?.rootViewController = chatViewController
//        self.view.window?.makeKeyAndVisible()
//
//        let chatViewController = ChatViewController()
            
           
        }
        
    }
    
}
