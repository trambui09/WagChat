//
//  HomeViewController.swift
//  WagChat
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
 
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatsButton: UIButton!
    
    // initiate a variable to store users data
    var userData: [[String: String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
   
        // tableview methods
        tableView.delegate = self
        tableView.dataSource = self
      
        // Do any additional setup after loading the view.
        setUpElements()
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
//                  print("\(document.data()["username"]!) - \(document.data()["topics"]!)")
                    let username = document.data()["username"] as! String
                    let uid = document.data()["uid"] as! String
                    let photoUrl = document.data()["photoUrl"] as! String

                    let user = ["username": username, "uid": uid, "photoUrl": photoUrl]
                    self.userData.append(user)
                    
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // table row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    // table cell
    // opened 1 prototype cell - gave reused identifier PostCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        let user = userData[indexPath.row]
        
        // how to check if username is the current username so we can put a marker
        // to say it's you
        if Auth.auth().currentUser?.uid == user["uid"]  {
            cell?.textLabel?.text = "\(user["username"] ?? "YOU") - YOU"
        } else {
            cell?.textLabel?.text = user["username"]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userData[indexPath.row]
        let profileDetailsViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileDetailsViewController) as? ProfileDetailsViewController
        
        // transfer the user uid data from homeViewController to the profileDetailsViewController
        profileDetailsViewController?.selectedUserUID = user["uid"]!

        // push to the current nav controller
        self.navigationController?.pushViewController(profileDetailsViewController!, animated: true)
        
    }
    
    private func handleMessage() {
        print("Marked as to message")
        // I still think I can put some of the code in method below up here, but I would not have access to the userData[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal,
                                        title: "Message") { [weak self] (action, view, completionHandler) in
                                            self?.handleMessage()
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        
        
        let user = userData[indexPath.row]

        let chatViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.chatViewController) as? ChatViewController

        chatViewController?.user2Name = user["username"]!
        chatViewController?.user2UID = user["uid"]!
        chatViewController?.user2ImgUrl = user["photoUrl"]!
        
        navigationController?.pushViewController(chatViewController!, animated: true)
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    
    // to prevent the delete leading
//    func tableView(_ tableView: UITableView,
//                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
    
    func setUpElements() {
        Utilities.styleFilledButton(logOutButton)
        Utilities.styleFilledButton(chatsButton)
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
                
        // check if user is logged in or not
        // log out via Auth
        if Auth.auth().currentUser?.uid != nil {
            let firebaseAuth = Auth.auth()
            
            do {
              try firebaseAuth.signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
            
            // bring up the welcome screen
//
//            let welcomeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeViewController) as? ViewController
//
//            self.view.window?.rootViewController = welcomeViewController
//            self.view.window?.makeKeyAndVisible()
//
            
            let firstNavigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.firstNavigationController) as? UINavigationController
            
            self.view.window?.rootViewController = firstNavigationViewController
            self.view.window?.makeKeyAndVisible()
            
        }
    }
    // chatsButton is actually profileButton
    @IBAction func chatsButtonTapped(_ sender: Any) {
        let profileViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileViewController) as? ProfileViewController

        navigationController?.pushViewController(profileViewController!, animated: true)
    }
}
