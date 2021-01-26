//
//  SignUpViewController.swift
//  WagChat
//
//  Created by Tram Bui on 1/26/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var dogInfoTextField: UITextField!
    
    @IBOutlet weak var topicsTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        // hide the error
        errorLabel.alpha = 0
        
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(locationTextField)
        Utilities.styleTextField(dogInfoTextField)
        Utilities.styleTextField(topicsTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(signUpButton)
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // check the fields if everything is correct, if fine, return nil, else return the error msg
    func validateFields() -> String? {
        
        // check that all fields are filled in
        
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || dogInfoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || topicsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        // check is password is secure
        
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanPassword) == false {
            // password isn't secured enough
            return "Please make sure you password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        // validate the feilds
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else {
            
            // create cleaned versions of the data
            
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let location = locationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let dogInfo = dogInfoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let topics = topicsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // check if errors
                if err != nil {
                    // there was an error
                    self.showError("Error creating user")
                }
                else {
                    // user was created good! now store
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["username":username, "location":location, "dogInfo":dogInfo, "topics":topics, "uid":result!.user.uid]) { (error) in
                        if error != nil {
                            // show error message
                            self.showError("Error saving user data")
                        }
                    }
                    
                    self.transitionToHome()
                    
                }
            }
        }
        // create the user
        
        // transition to the home screen
        
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        // reference to HomeVC
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    
}
