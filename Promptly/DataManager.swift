//
//  DataManager.swift
//  Promptly
//
//  Created by Nihal Kurki on 3/31/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import UIKit
import CommonCrypto
import Combine


class ReplyButton: UIButton {
    var pId: String?
}

class DataManager: ObservableObject {
    @Published var posts: [Post] = []
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts(){
        posts.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Post")
        
        ref.addSnapshotListener { snapshot, error in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            
            self.posts.removeAll()
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let defaultTimestamp = Timestamp(seconds: 0, nanoseconds: 0)
                    
                    let id = data["id"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let likes = data["like_count"] as? Int32 ?? 0
                    let timestamp = data["timestamp"] as? Timestamp ?? defaultTimestamp
                    let like_id = data["like_id"] as? Int ?? 0
                    
                    let post = Post(id: id, text: text, timestamp: timestamp, like_count: likes, like_id: like_id)
                    self.posts.append(post)
                }
                
                self.posts.sort(by: { $0.timestamp.dateValue() <= $1.timestamp.dateValue() })

            }
        }
    }
}






class MyNewViewController: UIViewController {
    
    lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    
    var dateString: String {
        return dateFormatter.string(from: Date())
    }
    
    let db = Firestore.firestore()


    private var dataManager = DataManager()
    private var posts: [Post] = []
    private let calendar = Calendar.current

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 235/255, green: 220/255, blue: 255/255, alpha: 1.0)
        

        // Subscribe to changes in the posts array
        dataManager.$posts
            .sink { [weak self] newPosts in
                self?.posts = newPosts
                self?.updateUI()
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()

    private func updateUI() {
        // Remove any existing subviews
        view.subviews.forEach { $0.removeFromSuperview() }
        
        
        var yOffset: CGFloat = 10

        // Add the logo image
        let logoImageView = UIImageView(image: UIImage(named: "PromptlyLogo2"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 150)
        view.addSubview(logoImageView)
        
        

        // Add the "Today's Prompt" label
        let todayPromptLabel = UILabel(frame: CGRect(x: 20, y: 120, width: view.frame.width - 40, height: 120))
        todayPromptLabel.text = "What is a boring fact about you?"
        todayPromptLabel.font = UIFont.boldSystemFont(ofSize: 20)
        todayPromptLabel.textColor = UIColor(red: 110/255, green: 40/255, blue: 184/255, alpha: 1.0)
        //        todayPromptLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        todayPromptLabel.textAlignment = .center
        todayPromptLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        view.addSubview(todayPromptLabel)
        
        let promptQuery = db.collection("Prompt").whereField("day", isEqualTo: dateString)

        promptQuery.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let text = document.data()["text"] as? String ?? ""
                    print("Prompt: \(text)")
                    DispatchQueue.main.async {
                        todayPromptLabel.text = text
                    }
                }
            }
        }
        

        //var yOffset: CGFloat = 250
        
//        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - 200))
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 240, width: view.frame.width, height: view.frame.height))
        scrollView.backgroundColor = UIColor(red: 235/255, green: 220/255, blue: 255/255, alpha: 1.0)
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        var likeCount: Int = 0

        for post in posts {
            
            
//            let input = formattedDateString(from: post.timestamp)
//            print(input)
//            let dateFormatter = DateFormatter()
//            //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatter.dateFormat = "MMM d, yyyy"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let date = post.timestamp.dateValue()
            let input = dateFormatter.string(from: date)
            
            let dateFormatter2 = DateFormatter()
            
            dateFormatter2.dateFormat = "h:mm a"
            
            let formattedDate = post.timestamp.dateValue()
            let output = dateFormatter2.string(from: date)
            //print(output)
            
//            dateFormatter.dateFormat = "h:mm a"
//
//            let formattedDate = post.timestamp.dateValue()
//            let output = dateFormatter.string(from: formattedDate)
//            print(output)
            
            let postDate = dateFormatter.date(from: input)
            guard let date = postDate else { continue }


            // Only display posts from the current day
            if !calendar.isDateInToday(date) {
                continue
            }

            // Create the white box container
            let whiteBox = UIView(frame: CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 100))
            whiteBox.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
            whiteBox.layer.cornerRadius = 10
            whiteBox.layer.shadowColor = UIColor.black.cgColor
            whiteBox.layer.shadowOpacity = 0.1
            whiteBox.layer.shadowOffset = CGSize(width: 0, height: 1)
            whiteBox.layer.shadowRadius = 5
            scrollView.addSubview(whiteBox)

            // Add the profile picture
            let profilePic = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
            profilePic.image = UIImage(named: "ProfilePic")
            profilePic.backgroundColor = .white
            profilePic.layer.cornerRadius = 40
            profilePic.clipsToBounds = true
            whiteBox.addSubview(profilePic)

            // Add the post text
            let postText = UILabel(frame: CGRect(x: 100, y: 10, width: whiteBox.frame.width - 180, height: 60))
            postText.text = post.text
            postText.numberOfLines = 0
            postText.font = UIFont.systemFont(ofSize: 18)
            postText.textColor = .black
            whiteBox.addSubview(postText)
            
            
            
            // Add the user email
            let userEmailLabel = UILabel(frame: CGRect(x: 100, y: 70, width: whiteBox.frame.width - 150, height: 20))
            userEmailLabel.text = Auth.auth().currentUser?.email
            userEmailLabel.font = UIFont.systemFont(ofSize: 14)
            userEmailLabel.textColor = .gray
            whiteBox.addSubview(userEmailLabel)

            // Add the timestamp
//            let timestampLabel = UILabel(frame: CGRect(x: 240, y: 70, width: whiteBox.frame.width - 10, height: 20))
            let timestampLabel = UILabel(frame: CGRect(x: whiteBox.frame.width - 70, y: 8, width: whiteBox.frame.width - 10, height: 20))
            timestampLabel.text = output
            timestampLabel.font = UIFont.systemFont(ofSize: 14)
            timestampLabel.textColor = .gray
            whiteBox.addSubview(timestampLabel)
            
            
            
            // Add the like button
            let likeButton = UIButton(frame: CGRect(x: whiteBox.frame.width - 70, y: 30, width: 30, height: 30))
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .gray
            likeButton.tag = likeCount
            whiteBox.addSubview(likeButton)
            
            print(post.id)
            print(likeButton.tag)

            // Add the like count label
            let likeCountLabel = UILabel(frame: CGRect(x: whiteBox.frame.width - 40, y: 30, width: 40, height: 30))
            likeCountLabel.text = "\(post.like_count)"
            likeCountLabel.font = UIFont.systemFont(ofSize: 14)
            likeCountLabel.textColor = .gray
            likeCountLabel.tag = likeCount + 1000
            whiteBox.addSubview(likeCountLabel)
            
            if (likeButton.tag == likeCountLabel.tag) {
                print("equality")
                print(likeCountLabel.tag)
            }
            
            //let replyButton = UIButton(type: .system, frame: CGRect(x: whiteBox.frame.width - 60, y: 5, width: 30, height: 30))
            let replyButton = ReplyButton(type: .system)
            replyButton.pId = post.id
            replyButton.frame = CGRect(x: whiteBox.frame.width - 80, y: 65, width: 70, height: 30)
            //replyButton.setImage(UIImage(systemName: "heart"), for: .normal)
            replyButton.setTitle("Reply!", for: .normal)
            replyButton.tintColor = .gray
            whiteBox.addSubview(replyButton)
                        
                        
            
            likeCount += 1
            
            
            
            
            
            // Add target action to the like button
//            likeButton.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)
            likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
            
            replyButton.addTarget(self, action: #selector(replyButtonTapped), for: .touchUpInside)



            yOffset += 120
            

        }
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: yOffset + 200)

    }
    
    
    
    
    
 //UI with date
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        if var index = posts.lastIndex(where: { $0.like_id == sender.tag }) {

            var post = posts[index]

            if sender.tintColor == .gray { // If heart is not filled, increase like count
                post.like_count += 1
                sender.tintColor = .red
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else { // If heart is filled, decrease like count
                post.like_count -= 1
                sender.tintColor = .gray
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let today = dateFormatter.string(from: Date())

            // Retrieve the post documents with matching created today from Firestore
            let postQuery = Firestore.firestore().collection("Post").whereField(FieldPath(["id"]), isGreaterThan: "\(today)-0000")
                            .whereField(FieldPath(["id"]), isLessThan: "\(today)-9999")
            postQuery.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error retrieving post documents with created today: \(error.localizedDescription)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No post documents found with created today")
                        return
                    }

                    for document in documents {
                        if document.documentID == post.id {
                            // Update the Firestore document with the updated like count for the post
                            document.reference.updateData(["like_count": post.like_count]) { error in
                                if let error = error {
                                    print("Error updating like count for post with document ID \(post.id): \(error.localizedDescription)")
                                } else {
                                    print("Successfully updated like count for post with document ID \(post.id) to \(post.like_count)")
                                }
                            }

                            break // exit the loop if the correct document is found and updated
                        }
                    }
                }
            }

            //posts[3 - index - 1] = post // Assign the modified copy back to the posts array
            posts[index] = post

            if let likeCountLabel = sender.superview?.viewWithTag(post.like_id + 1000) as? UILabel {
                likeCountLabel.text = "\(post.like_count)"
            }
        }
    }



    @objc func replyButtonTapped(_ sender: ReplyButton){
        let viewScreen = ViewRepliesScreen()
        viewScreen.postId = sender.pId
        viewScreen.modalPresentationStyle = .fullScreen
        viewScreen.modalTransitionStyle = .crossDissolve
        self.present(viewScreen, animated: true, completion: nil)
    }
    
    
    
    func formattedDateString(from timestamp: Timestamp) -> String {
        let postDate = timestamp.dateValue()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: postDate)
        let date = calendar.date(from: dateComponents) ?? postDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
}
