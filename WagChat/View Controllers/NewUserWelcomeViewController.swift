//
//  NewUserWelcomeViewController.swift
//  WagChat
//

import UIKit

class NewUserWelcomeViewController: UIViewController {
    
    @IBOutlet weak var continueToProfileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

    }
    
    func setUpElements() {
        Utilities.styleFilledButton(continueToProfileButton)
    }
    
    @IBAction func continueToProfileButtonTapped(_ sender: Any) {
        transitionToProfileVC()
    }
    
    func transitionToProfileVC() {
        let profileViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileViewController) as? ProfileViewController

        self.view.window?.rootViewController = profileViewController
        self.view.window?.makeKeyAndVisible()
    }
}
