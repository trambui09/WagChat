//
//  ViewController.swift
//  WagChat

//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, GIDSignInDelegate  {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements();
        viewWillDisappear(false)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    // hide navigation item bar from VC
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    // Hide the Navigation Bar
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    // Show the Navigation Bar
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledLogin(loginButton)
        Utilities.styleFilledButtonCornerRadius(googleSignInButton)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    //Sign in functionality will be handled here
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let auth = user.authentication else { return }
        
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (res, error) in
        if let error = error {
        print(error.localizedDescription)
        } else {
        print("Login Successful.")
        //This is where you should add the functionality of successful login
        //i.e. dismissing this view or push the home view controller etc
            
            
            // if they are in the system, go to homepage
            // if not, lead them to the profile view controller
            let newUser = res?.additionalUserInfo?.isNewUser
            
            if (newUser!) {
                let db = Firestore.firestore()
                            db.collection("users").document(String((res?.user.uid)!)).setData([
                                "uid" : String((res?.user.uid)!),
                                "username" : (res?.user.displayName)!,
                                "photoUrl": "https://icon-library.com/images/corgi-icon/corgi-icon-7.jpg"
                            ], merge: true) { (error) in
                                if error != nil {
                                    // show error message
                                    print("Error saving user data")
                                }
                            }
                
                let newUserViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.newUserWelcomeVC) as? NewUserWelcomeViewController

                self.view.window?.rootViewController = newUserViewController
                self.view.window?.makeKeyAndVisible()
                
                
                } else {
                    // login
                    let navigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationController) as? UINavigationController
                    
                    self.view.window?.rootViewController = navigationViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    
    @IBAction func googleSignInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
}

