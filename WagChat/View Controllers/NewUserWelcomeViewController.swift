//
//  NewUserWelcomeViewController.swift
//  WagChat
//

import UIKit

class NewUserWelcomeViewController: UIViewController {
    @IBOutlet var continueToProfileButton: UIView!
    
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
    
    @IBAction func continueToProfileButtonTapped(_ sender: Any) {
        
        transitionToProfileVC()
    }
    func transitionToProfileVC() {
        let profileViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileViewController) as? ProfileViewController

        self.view.window?.rootViewController = profileViewController
        self.view.window?.makeKeyAndVisible()
    }

}
