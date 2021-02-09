//
//  ProfileDetailsViewController.swift
//  WagChat


import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import SDWebImage


class ProfileDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
//    @IBOutlet weak var dogLabel: UILabel!
    
    @IBOutlet weak var aboutLabel: UILabel!
    
    @IBOutlet weak var messageButton: UIButton!
    
    var selectedUserUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selected User Profile"

        setUpElements()
        populateProfileDetails()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(messageButton)
    }
    
    func populateProfileDetails() {
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(selectedUserUID!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {

                // need a check if the fields are nil or not
                if document.data()?["dogInfo"] != nil && document.data()?["location"] != nil && document.data()?["about"] != nil && document.data()?["username"] != nil  && document.data()?["photoUrl"] != nil {
                    self.usernameLabel.text = "\(document.data()?["username"]! as? String ?? "No username"), \(document.data()?["dogInfo"]! as? String ?? "No dog info")"
                    self.locationLabel.text = document.data()?["location"]! as? String
//                    self.dogLabel.text = "Dog Information: \(document.data()?["dogInfo"]! as? String ?? "No Dog Information")"
                    self.aboutLabel.text = document.data()?["about"]! as? String
//                    self.aboutLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//                    self.aboutLabel.alpha = 1

                    
                    self.userProfileImage.sd_setImage(with: URL(string: (document.data()?["photoUrl"])! as! String), placeholderImage: UIImage(named: "https://icon-library.com/images/corgi-icon/corgi-icon-7.jpg"))
//                    self.userProfileImage.image = document.data()?["photoUrl"]! as? UIImage
                }

            } else {
                print("Document does not exist")
            }
        }
    }

    @IBAction func messageButtonTapped(_ sender: Any) {
        print("message selected user")
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(selectedUserUID!)
        
        let chatViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.chatViewController) as? ChatViewController

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                // need a check if the fields are nil or not
                if document.data()?["uid"] != nil && document.data()?["photoUrl"] != nil &&  document.data()?["username"] != nil {
           
                    chatViewController?.user2Name = document.data()?["username"]! as? String
                    chatViewController?.user2UID = self.selectedUserUID!
                    chatViewController?.user2ImgUrl = document.data()?["photoUrl"]! as? String
            
                    self.navigationController?.pushViewController(chatViewController!, animated: true)
                   
                  }
            } else {
                print("Document does not exist")
            }
        }
        
        
        let doc = db.collection("users").document(Auth.auth().currentUser!.uid)

        doc.getDocument { (document, error) in
            if let document = document, document.exists {

                // need a check if the fields are nil or not
   
                chatViewController?.currentUserImgUrl = document.data()?["photoUrl"] as? String
                

            } else {
                print("Document does not exist")
            }
        }
    }
}
