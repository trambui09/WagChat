//
//  ChatsViewController.swift
//  WagChat
//
//  Created by Tram Bui on 1/28/21.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var wagChatButton: UIButton!
    
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
    @IBAction func wagChatButtonTapped(_ sender: Any) {
        let navigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationController) as? UINavigationController
        
        self.view.window?.rootViewController = navigationViewController
        self.view.window?.makeKeyAndVisible()
    }
    
}
