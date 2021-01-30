//
//  ChatViewController.swift
//  WagChat
//
//  Created by Tram Bui on 1/29/21.
//

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
import SDWebImage

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    
    var currentUser: User = Auth.auth().currentUser!
    
    var user2Name: String = "Anonymous"
    var user2UID: String?
    
    // no imgURL yet
    
    private var docReference: DocumentReference?
       
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = user2Name ?? "Chat"

                navigationItem.largeTitleDisplayMode = .never
                maintainPositionOnKeyboardFrameChanged = true
//                messageInputBar.inputTextView.tintColor = .primary
//                messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
                
                messageInputBar.delegate = self
                messagesCollectionView.messagesDataSource = self
                messagesCollectionView.messagesLayoutDelegate = self
                messagesCollectionView.messagesDisplayDelegate = self
                
                loadChat()
                

        // Do any additional setup after loading the view.
    }
    
    
    func createNewChat() {
            let users = [self.currentUser.uid, self.user2UID]
             let data: [String: Any] = [
                 "users":users
             ]
             
             let db = Firestore.firestore().collection("Chats")
             db.addDocument(data: data) { (error) in
                 if let error = error {
                     print("Unable to create chat! \(error)")
                     return
                 } else {
                     self.loadChat()
                 }
             }
        }
    
    func loadChat() {
           
           //Fetch all the chats which has current user in it
           let db = Firestore.firestore().collection("Chats")
                   .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
           
           
           db.getDocuments { (chatQuerySnap, error) in
               
               if let error = error {
                   print("Error: \(error)")
                   return
               } else {
                   
                   //Count the no. of documents returned
                   guard let queryCount = chatQuerySnap?.documents.count else {
                       return
                   }
                   
                   if queryCount == 0 {
                       //If documents count is zero that means there is no chat available and we need to create a new instance
                       self.createNewChat()
                   }
                   else if queryCount >= 1 {
                       //Chat(s) found for currentUser
                       for doc in chatQuerySnap!.documents {
                           
                           let chat = Chat(dictionary: doc.data())
                           //Get the chat which has user2 id
                        if ((chat?.users.contains(self.user2UID!)) != nil) {
                               
                               self.docReference = doc.reference
                               //fetch it's thread collection
                                doc.reference.collection("thread")
                                   .order(by: "created", descending: false)
                                   .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                               if let error = error {
                                   print("Error: \(error)")
                                   return
                               } else {
                                   self.messages.removeAll()
                                       for message in threadQuery!.documents {

                                           let msg = Message(dictionary: message.data())
                                           self.messages.append(msg!)
                                           print("Data: \(msg?.content ?? "No message found")")
                                       }
                                   self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToLastItem(animated: true)
                               }
                               })
                               return
                           } //end of if
                       } //end of for
                       self.createNewChat()
                   } else {
                       print("Let's hope this error never prints!")
                   }
               }
           }
       }
    
    
    private func insertNewMessage(_ message: Message) {
           
           messages.append(message)
           messagesCollectionView.reloadData()
           
           DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(animated: true)
           }
       }
    
    
    private func save(_ message: Message) {
            
            let data: [String: Any] = [
                "content": message.content,
                "created": message.created,
                "id": message.id,
                "senderID": message.senderID,
                "senderName": message.senderName
            ]
            
            docReference?.collection("thread").addDocument(data: data, completion: { (error) in
                
                if let error = error {
                    print("Error Sending message: \(error)")
                    return
                }
                
                self.messagesCollectionView.scrollToLastItem()
                
            })
        }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uid, senderName: currentUser.uid)
                
                      //messages.append(message)
                      insertNewMessage(message)
                      save(message)
        
                      inputBar.inputTextView.text = ""
                      messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
                }
        
    
    func currentSender() -> SenderType {
            
        return Sender(id: currentUser.uid, displayName: currentUser.uid)
            
        }
    
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
           
           return messages[indexPath.section]
           
       }
       
       func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
           
           if messages.count == 0 {
               print("No messages to display")
               return 0
           } else {
               return messages.count
           }
       }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return isFromCurrentSender(message: message) ? .blue: .lightGray
        }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

           let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
           return .bubbleTail(corner, .curved)

       }
    
    // skipped the avatarSize and configure avatar methods
    
}
