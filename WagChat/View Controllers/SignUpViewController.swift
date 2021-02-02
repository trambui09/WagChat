//
//  SignUpViewController.swift
//  WagChat
//


import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class SignUpViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    // add profile image
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pngkey.com-butt-png-2117336")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    @IBOutlet weak var usernameTextField: UITextField!
    
//    @IBOutlet weak var locationTextField: UITextField!
//
//    @IBOutlet weak var dogInfoTextField: UITextField!
//
//    @IBOutlet weak var topicsTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        
        view.addSubview(imageView)

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/3
        imageView.frame = CGRect(x: (view.width-size)/2,
                                 y: 70,
                                 width: size,
                                 height: size)
    }
    
    func setUpElements() {
        
        // hide the error
        errorLabel.alpha = 0
        
        Utilities.styleTextField(usernameTextField)
//        Utilities.styleTextField(locationTextField)
//        Utilities.styleTextField(dogInfoTextField)
//        Utilities.styleTextField(topicsTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
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
        // validate the feilds
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else {
            
            // create cleaned versions of the data
            
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let location = locationTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let dogInfo = dogInfoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//            let topics = topicsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
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
                    
                    db.collection("users").addDocument(data: ["username":username, "uid":result!.user.uid, "photoUrl": "https://icon-library.com/images/corgi-icon/corgi-icon-7.jpg"]) { (error) in
                        if error != nil {
                            // show error message
                            self.showError("Error saving user data")
                        }
                    }
                    // transition to the home screen
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
        
        // reference to HomeVC
        let navigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationController) as? UINavigationController
        
        self.view.window?.rootViewController = navigationViewController
        self.view.window?.makeKeyAndVisible()
    }
}
