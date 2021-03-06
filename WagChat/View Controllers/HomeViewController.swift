//
//  HomeViewController.swift
//  WagChat
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import SDWebImage


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
 
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatsButton: UIButton!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    // initiate a variable to store users data
    var userData: [[String: String]] = []
    var filteredUserData: [[String: String]]!

    override func viewDidLoad() {
        super.viewDidLoad()
   
        // tableview methods
        tableView.delegate = self
        tableView.dataSource = self
        // search bar
        searchBar.delegate = self
        filteredUserData = userData
        
      
        // Do any additional setup after loading the view.
        setUpElements()
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                  print("\(document.data()["username"]!) - \(document.data()["topics"]!)")
                    let username = document.data()["username"] as! String
                    let uid = document.data()["uid"] as! String
                    let photoUrl = document.data()["photoUrl"] as! String

                    let user = ["username": username, "uid": uid, "photoUrl": photoUrl]
                    self.userData.append(user)
                    self.filteredUserData = self.userData
                    
                }
                DispatchQueue.main.async  {
                    self.tableView.reloadData()
                    let indexPath = IndexPath.init(row: 0, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    // table row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredUserData.count
    }
    // table cell
    // opened 1 prototype cell - gave reused identifier PostCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
//        let user = userData[indexPath.row]
        let user = filteredUserData[indexPath.row]
        tableView.reloadRows(at: [indexPath], with: .none)
        
        // display YOU marker to identify current user
        if Auth.auth().currentUser?.uid == user["uid"]  {
            cell?.textLabel?.text = "\(user["username"] ?? "YOU") - YOU"
        } else {
            cell?.textLabel?.text = user["username"]
        }
        
       
        let size = view.width/3
        cell?.imageView?.frame = CGRect(x: (view.width-size)/3, y: 140, width: 30, height: 20)
        // attach a circle avatar image next to the username
        cell?.imageView?.layer.cornerRadius = cell?.imageView?.frame.size.width ?? 60 / 2;
        cell?.imageView?.clipsToBounds = true;
   

        cell?.imageView?.sd_setImage(with: URL(string: (user["photoUrl"])! ), placeholderImage: UIImage(named:"https://icon-library.com/images/corgi-icon/corgi-icon-7.jpg"))

       
        return cell!
    }
    // increasing the height on the cell in UITableview
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60 //or whatever you need
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = userData[indexPath.row]
        let user = filteredUserData[indexPath.row]
        let profileDetailsViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileDetailsViewController) as? ProfileDetailsViewController
        
        // transfer the user uid data from homeViewController to the profileDetailsViewController
        profileDetailsViewController?.selectedUserUID = user["uid"]!

        // push to the current nav controller
        self.navigationController?.pushViewController(profileDetailsViewController!, animated: true)
        
    }
    
    // unhighlight/deselect cell upon returning to VC
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
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
        
        let chatViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.chatViewController) as? ChatViewController
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                chatViewController?.currentUserImgUrl = document.data()?["photoUrl"] as? String
            } else {
                print("Document does not exist")
            }
        }
        
//        let user = userData[indexPath.row]
        let user = filteredUserData[indexPath.row]


        chatViewController?.user2Name = user["username"]!
        chatViewController?.user2UID = user["uid"]!
        chatViewController?.user2ImgUrl = user["photoUrl"]!
        
        navigationController?.pushViewController(chatViewController!, animated: true)
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // code to run when the searchbar changes
        filteredUserData = []
        
        if searchText == "" {
            filteredUserData = userData
        } else {
            for user in userData {
                if user["username"]!.lowercased().contains(searchText.lowercased()) {
                    filteredUserData.append(user)
                }
            }
        }
        // reloading the tableview and get the images to appear
        self.tableView.reloadData()
    }
    
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
