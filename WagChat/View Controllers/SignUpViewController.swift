//
//  SignUpViewController.swift
//  WagChat
//


import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage



class SignUpViewController: UIViewController {
    
//    @IBOutlet var imageView: UIImageView!
//    @IBOutlet var lable: UILable!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @objc let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        
        //display password btn
        passwordTextField.rightViewMode = .unlessEditing
        
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.btnPasswordVisiblityClicked), for: .touchUpInside)
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    // dispaly password fun
    @IBAction func btnPasswordVisiblityClicked(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if (sender as! UIButton).isSelected {
            self.passwordTextField.isSecureTextEntry = false
            button.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            self.passwordTextField.isSecureTextEntry = true
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    func setUpElements() {
        
        // hide the error
        errorLabel.alpha = 0
        Utilities.styleFilledButton(signUpButton)
    }
    
    // check the fields if everything is correct, if fine, return nil, else return the error msg
    func validateFields() -> String? {
        
        // check that all fields are filled in
        
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanPassword) == false {
            // password isn't secured enough
            return "Please make sure you password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        // validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else {
            
            // create cleaned versions of the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                // check if errors
                if err != nil {
                    // there was an error
                    self.showError("Error creating user")
                }
                else {
                    // user was created good! now store
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(String(((result?.user.uid)!))).setData(["username":username, "uid":result!.user.uid,
                    "photoUrl": "https://icon-library.com/images/corgi-icon/corgi-icon-7.jpg"], merge: true){ (error) in
                        if error != nil {
                            // show error message
                            self.showError("Error saving user data")
                        }
                    }
                    // transition to newUserWelcomeVC
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        // reference to NewUserWelcomeVC
        
        let newUserViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.newUserWelcomeVC) as? NewUserWelcomeViewController

        self.view.window?.rootViewController = newUserViewController
        self.view.window?.makeKeyAndVisible()
    }
}

