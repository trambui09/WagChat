//
//  LogInViewController.swift
//  WagChat
//
//
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    // add logo to login view
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "pngkey.com-butt-png-2117336")
//        imageView.contentMode = .scaleToFill
//        return imageView
//    }()

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @objc let button = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        
        passwordTextField.rightViewMode = .unlessEditing
        
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -24, bottom: 5, right: 15)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(15), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.btnPasswordVisiblityClicked), for: .touchUpInside)
        passwordTextField.rightView = button
        passwordTextField.rightViewMode = .always
        
        // Do any additional setup after loading the view.
        // add subViews
        //        view.addSubview(imageView)
        
        setUpElements()
    }
    
    // dispaly password fun
    @IBAction func btnPasswordVisiblityClicked(_ sender: Any) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if (sender as! UIButton).isSelected {
            self.passwordTextField.isSecureTextEntry = false
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            self.passwordTextField.isSecureTextEntry = true
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
   
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        let size = view.width/4
//        imageView.frame = CGRect(x: (view.width-size)/2,
//                                 y: 90,
//                                 width: 80,
//                                 height: 80)
//    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        
//        Utilities.styleTextField(emailTextField)
//        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    
    func validateFields() -> String? {
        
        // check that all fields are filled in
        
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        return nil
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // validate text fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }
        else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                    let navigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationController) as? UINavigationController
                    
                    self.view.window?.rootViewController = navigationViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    // forgot password
    @IBAction func forgotPassButton_Tapped(_ sender: Any) {
        
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
            forgotPasswordAlert.addTextField { (textField) in
                textField.placeholder = "Enter email address"
        }
        
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
                let resetEmail = forgotPasswordAlert.textFields?.first?.text
            
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                    if error != nil{
                        let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    }else {
                        let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                })
            }))
        //   PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
        
    }
}
