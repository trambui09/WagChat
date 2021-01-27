//
//  HomeViewController.swift
//  WagChat
//
//  Created by Tram Bui on 1/26/21.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logOutTapped(_ sender: Any) {
        print("Logging out")
        
        let firebaseAuth = Auth.auth()
        
      do {
        try firebaseAuth.signOut()
      } catch let signOutError as NSError {
        print ("Error signing out: %@", signOutError)
      }
        
    }
}
