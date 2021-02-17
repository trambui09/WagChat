# WagChat
  WagChat is a mobile app that connects dog owners based on what is most important to them to talk and turns their daily walk into something fun and beneficial for them and their pet. 

## Problem Statement and App Solution

  Since the Covid-19 pandemic started, animal shelters have seen an increase in pet adoptions compared to the year prior. Shelter Animals Count organization has been keeping track of shelter and adoption numbers. They have found that across the 500 rescue organizations tracked in the US, there has been 26,000 more pet adoptions in 2020 compared to 2019, which accounts for a 15% increase in adoptions. The upward trend in pet adoptions, particularly dog adoptions coupled with a few other things like people staying home more and socially distancing to prevent the spread of COVID is where our app, Wagchat can come into play. We realize that the pandemic has upended a lot of normal activities. It has been almost a year since we’ve gone into lockdown in the US. People are more prone to feeling isolated and lonely because they are staying home more and doing social distancing. The goal of WagChat is to connect dog owners with each other so they can schedule a time to walk their dogs together. We hope that with WagChat, people can take their dog walking routines and add a safe and social side to connect with their communities and improve their physical and mental health. 

## Walkthrough


[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/YoERXZpv0EA/0.jpg)](https://www.youtube.com/watch?v=YoERXZpv0EA)


## Requirements/Installation 

- [iOS 14.3+](https://support.apple.com/en-us/HT211808)
- [Xcode 12.3+](https://developer.apple.com/support/xcode/)
- [Pod](https://cocoapods.org/)

- download [Xcode](https://developer.apple.com/support/xcode/)
- Fork and clone this repo 
- Open terminal and navigate to project folder 
- Install the project's dependencies by running `pod install` on your terminal
- Open `ios-app-particle-setup.xcworkspace` and run the project on selected device or simulator

## Technologies/Dependencies 

- [Swift](https://developer.apple.com/swift/)
- [Xcode](https://developer.apple.com/support/xcode/)
- [Firestore](https://firebase.google.com/docs/firestore)
- [GoogleSignIn](https://cocoapods.org/pods/GoogleSignIn)
- [MessageKit](https://messagekit.github.io/)
- [SDWebImage](https://cocoapods.org/pods/SDWebImage)

## Database Structure and Considerations

  Google Firestore was used for WagChat’s database. Firestore, a non-relational database, was chosen for its flexibility and user friendly experience. For WagChat, there are two major collections to keep track of the data. The “Users” collection contains documents linked to an authenticated user and keeps track of the user's profile information (location, photoUrl, dogInfo, username, and their about section). 
One of WagChat’s core functionalities is to be able to have a private conversation with another user on the app. To store the chat messages amongst users, there were a few considerations in how to structure the database. Initially, we thought of having a nested chat collection in each user document that would keep track of the people the user was conversing with. However, with this structure, we had to consider the implications of each chat message being duplicated for the users involved. The sender and the receiving users would both have the same data saved nested in their user document. To avoid this duplication of chat messages, we decided to create a separate “Chats” collection. In it,, there would be an auto-generated ID for the documents with a users field containing an array of users in the conversation. Within the document, there is another “thread” collection nested. The nested thread collection contains the specifics of one message. The created timestamp, the senderID, senderUsername, content, and threadID. Upon rendering the threads between two specific users, we sort the threads by the created timestamp to display the chats chronologically. Below is a visual representation of how our database is structured in Cloud Firestore. 

![Screen Shot 2021-02-11 at 2 40 19 PM](https://user-images.githubusercontent.com/62119967/107975134-412d1200-6f7d-11eb-940d-e822b2a2eb91.png)
![Screen Shot 2021-02-11 at 2 45 21 PM](https://user-images.githubusercontent.com/62119967/107975138-412d1200-6f7d-11eb-830f-fcee7aa63b65.png)

## Contributors
- [Tram Bui](https://github.com/trambui09?tab=repositories)
- [Mona Rahmanimehr](https://github.com/monarahmani)
