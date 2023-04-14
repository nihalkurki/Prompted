//
//  ViewReponses.swift
//  Promptly
//
//  Created by Nihal Kurki on 3/25/23.
//


import UIKit
import FirebaseFirestore
import Firebase


class ViewRepliesScreen: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    var postId: String? //post id being replied to
//    (postId ?? "nil")


    lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        var dateString: String {
            return dateFormatter.string(from: Date())
        }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PromptlyLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var replies: [Reply] = []
    
//    private let prompt: UILabel = {
//        let label = UILabel()
//        label.text = "REPLY HERE!"
//        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//
//        return label
//    }()
    
    let textField = UITextField()

    let textField2 = UILabel()
    
    override func viewDidLoad() {
        
        // get current user's UID
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            // handle error here
            return
        }
        
        textField2.frame = CGRect(x: 120, y: 80, width: 400, height: 250)
        textField2.text = "abc"
        textField2.font = UIFont.systemFont(ofSize: textField2.font.pointSize + 14)
        textField2.textColor = .black
        view.addSubview(textField2)
        
        if let postId = postId {
            print("Replying to PostID: \(postId)")

            let query = db.collection("Post")
                .whereField("id", isEqualTo: postId)
            
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No matching documents.")
                        return
                    }
                    if documents.count > 0 {
                        // there is at least one matching document, so redirect the user to MyNewViewController
                        
                        for document in querySnapshot!.documents {
                          //print("\(document.documentID) => \(document.data())")
                            let text = document.data()["text"] as? String ?? ""
                            print("Text: \(text)")
                            self.textField2.text = text

                        }
                    }
                }
            }
        }
        
        


        
        super.viewDidLoad()
        
        // Set the background color
        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 254/255, alpha: 1.0)

        //**********
        view.addSubview(imageView)
        //view.addSubview(prompt)
                
        
        
        // Get a reference to the `replies` collection
        let repliesRef = Firestore.firestore().collection("Reply")

        // Query for all replies with the given `post_id`
        let query = repliesRef.whereField("post_id", isEqualTo: postId)

        // Execute the query and get the results
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting replies: \(error.localizedDescription)")
                return
            }
            
            // Create an array to hold the reply data
            //var replies: [Any] = []
            
            // Loop through each document in the result set and add the data to the `replies` array
            for document in querySnapshot!.documents {
                
                
                let data = document.data()
                
                let defaultTimestamp = Timestamp(seconds: 0, nanoseconds: 0)
                
                let id = data["id"] as? String ?? ""
                let text = data["text"] as? String ?? ""
                let likes = data["like_count"] as? Int32 ?? 0
                let timestamp = data["timestamp"] as? Timestamp ?? defaultTimestamp
                let post_id = data["post_id"] as? String ?? ""
                
                let reply = Reply(id: id, text: text, timestamp: timestamp, like_count: likes, post_id: post_id)
                self.replies.append(reply)

            }
            
            // Set the `replies` variable to the array of reply data
            self.replies.sort(by: { $0.timestamp.dateValue() <= $1.timestamp.dateValue() })
            
            // Use the `replies` variable elsewhere in your code
            // ...
        }
        
        
        
        var yOffset: CGFloat = 100
        for reply in replies {
            
            
//            let input = formattedDateString(from: post.timestamp)
//            print(input)
//            let dateFormatter = DateFormatter()
//            //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatter.dateFormat = "MMM d, yyyy"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = reply.timestamp.dateValue()
            let input = dateFormatter.string(from: date)
            
            let dateFormatter2 = DateFormatter()
            
            dateFormatter2.dateFormat = "h:mm a"
            
            let formattedDate = reply.timestamp.dateValue()
            let output = dateFormatter2.string(from: date)
            //print(output)
            
//            dateFormatter.dateFormat = "h:mm a"
//
//            let formattedDate = post.timestamp.dateValue()
//            let output = dateFormatter.string(from: formattedDate)
//            print(output)
            
            let postDate = dateFormatter.date(from: input)
            guard let date = postDate else { continue }


            // Create the white box container
            let whiteBox = UIView(frame: CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 100))
            whiteBox.backgroundColor = .white
            whiteBox.layer.cornerRadius = 10
            whiteBox.layer.shadowColor = UIColor.black.cgColor
            whiteBox.layer.shadowOpacity = 0.1
            whiteBox.layer.shadowOffset = CGSize(width: 0, height: 1)
            whiteBox.layer.shadowRadius = 5

            // Add the profile picture
            let profilePic = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
            profilePic.backgroundColor = .gray
            profilePic.layer.cornerRadius = 40
            profilePic.clipsToBounds = true
            whiteBox.addSubview(profilePic)

            // Add the post text
            let postText = UILabel(frame: CGRect(x: 100, y: 10, width: whiteBox.frame.width - 150, height: 60))
            postText.text = reply.text
            postText.numberOfLines = 0
            postText.font = UIFont.systemFont(ofSize: 18)
            whiteBox.addSubview(postText)
            
            
            
            // Add the user email
            let userEmailLabel = UILabel(frame: CGRect(x: 100, y: 70, width: whiteBox.frame.width - 150, height: 20))
            userEmailLabel.text = Auth.auth().currentUser?.email
            userEmailLabel.font = UIFont.systemFont(ofSize: 14)
            userEmailLabel.textColor = .gray
            whiteBox.addSubview(userEmailLabel)

            // Add the timestamp
//            let timestampLabel = UILabel(frame: CGRect(x: 240, y: 70, width: whiteBox.frame.width - 10, height: 20))
            let timestampLabel = UILabel(frame: CGRect(x: whiteBox.frame.width - 70, y: 70, width: whiteBox.frame.width - 10, height: 20))
            timestampLabel.text = output
            timestampLabel.font = UIFont.systemFont(ofSize: 14)
            timestampLabel.textColor = .gray
            whiteBox.addSubview(timestampLabel)
            
            
        

            yOffset += 120
            

        }
        
        
        
        
        
        
        
        
        
        // Set up text field
        textField.frame = CGRect(x: 50, y:520, width: 300, height: 100)
        textField.placeholder = "What's your reply?"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.textAlignment = .left
        view.addSubview(textField)
        
        

        
        
        // Add constraints to the button
        NSLayoutConstraint.activate([
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -310),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

//            prompt.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -50),
//            prompt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
//            prompt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
//            prompt.heightAnchor.constraint(equalToConstant: 250),
            
            textField.topAnchor.constraint(equalTo: view.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        //**********
        

        
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
//        if let email = FirebaseAuth.Auth.auth().currentUser?.email {
//            label.text = "Welcome " + email
//        } else {
//            // Handle the case where currentUser is nil or email is nil
//            label.text = "Welcome"
//        }
//        //label.text = "Welcome" + FirebaseAuth.Auth.auth().currentUser?.email
//        label.textAlignment = .center
//        label.center = view.center
//        view.addSubview(label)
        
        
        // Add a button to the view
        let post = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        post.setTitle("Reply", for: .normal)
        post.setTitleColor(.white, for: .normal)
        post.backgroundColor = .black
        post.center = CGPoint(x: view.center.x, y: view.center.y + 280)
        post.layer.cornerRadius = 5
        post.layer.borderWidth = 1
        post.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        view.addSubview(post)
        
        // Add a button to the view
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.center = CGPoint(x: view.center.x, y: view.center.y + 350)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        view.addSubview(button)

    
    }
    
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func postButtonTapped() {
        
        //CURRENTLY DOES NOT HANDLE EMPTY RESPONSE
        guard let userResponse = textField.text else {
            print("No user response found.")
            return
        }
        
        if userResponse.isEmpty {
            print("No user response found.")
            return
        }
        
        
//        db.collection("Post").addDocument(data: [
//                "text": userResponse,
//                "timestamp": FieldValue.serverTimestamp(),
//                "like_count": 1,
//                "id": uid
//            ]) { error in
//                if let error = error {
//                    print("Error adding document: \(error)")
//                } else {
//                    print("Document added with ID: NO ID recorded")
//                }
//            }
        
        if let uid = Auth.auth().currentUser?.uid {
            let now = Date()
            let timestamp = Timestamp(date: now)
            
            db.collection("Reply").addDocument(data: [
                "text": userResponse,
                "timestamp": timestamp,
                "like_count": 1,
                "id": uid + dateString,
                "post_id": postId
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with ID: NO ID recorded")
                }
            }
        } else {
            print("Error: User is not logged in")
        }
        
        let viewScreen = MyNewViewController()
        viewScreen.modalPresentationStyle = .fullScreen
        viewScreen.modalTransitionStyle = .crossDissolve
        self.present(viewScreen, animated: true, completion: nil)
    }
    
    // UITextViewDelegate method to adjust text view height
    func textFieldDidChange(_ textField: UITextView) {
        let size = CGSize(width: textField.bounds.width, height: .infinity)
        let estimatedSize = textField.sizeThatFits(size)
        textField.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
}

