//
//  ForgotPassViewController.swift
//  WagChat
//
//  Created by Ada on 2/8/21.
//

import UIKit
import Firebase

class ForgotPassViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func forgotPassButton_Tapped(_ sender: UIButton) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error == nil {
                print("Sent...!")
            } else {
                print("FAILD - \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
}
