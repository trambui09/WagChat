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
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
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
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true

        // Do any additional setup after loading the view.
        setUpElements()
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        
        imageView.addGestureRecognizer(gesture)
    }
    
    // will be called when user tap on head
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
       // print("Change pic called")
        
    }
       
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/3
        imageView.frame = CGRect(x: (view.width-size)/2,
                                 y: 70,
                                 width: size,
                                 height: size)
        
        imageView.layer.cornerRadius = imageView.width/2
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

// get the result of user selecting a photo from the camera
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   // action sheet(take photo or choose photo)
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentCamera()
                                                
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                
                                                self?.presentPhotoPicker()
                                                
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
   // when user take a photo/select
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            print(info)
            guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                   return
               }
        
        self.imageView.image = selectedImage
    }
   
    // when user cancel taking picture/photo selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
    }
}
