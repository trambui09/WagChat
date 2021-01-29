//
//  ChatsViewController.swift
//  WagChat
//
//  Created by Tram Bui on 1/28/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase



class ChatsViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
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
    
    func addToFirestore() {
        let user = Auth.auth().currentUser
        let uid1 = "waKpCLtdQHV7uIB80TuzJv1eZ2L2"
        
        let uid2 = user!.uid
        
        var chatId:String?
        chatId = nil
        if (uid1 < uid2) {
            chatId = uid1 + uid2
        }
        else {
            chatId = uid2 + uid1
        }
        
        let db = Firestore.firestore()
       
        db.collection("chats").document(chatId!).setData([
            "senderId": user!.uid,
            "receiverId": uid1,
            "messageBody": "what's up",
            "timestamp": Timestamp(date: Date())
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        addToFirestore()
    }
    
    
    

}
