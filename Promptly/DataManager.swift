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

import Combine


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
                    
                    let post = Post(id: id, text: text, timestamp: timestamp, like_count: likes)
                    self.posts.append(post)
                }
                
                self.posts.sort(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })

            }
        }
    }
}






class MyNewViewController: UIViewController {

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
        let logoImageView = UIImageView(image: UIImage(named: "PromptlyLogo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 50)
        view.addSubview(logoImageView)

        // Add the "Today's Prompt" label
        let todayPromptLabel = UILabel(frame: CGRect(x: 20, y: 120, width: view.frame.width - 40, height: 40))
        todayPromptLabel.text = "Today's Prompt"
        todayPromptLabel.font = UIFont.boldSystemFont(ofSize: 22)
        todayPromptLabel.textAlignment = .center
        view.addSubview(todayPromptLabel)
        

        //var yOffset: CGFloat = 250
        
//        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - 200))
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 180, width: view.frame.width, height: view.frame.height))
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
            print(output)
            
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
            whiteBox.backgroundColor = .white
            whiteBox.layer.cornerRadius = 10
            whiteBox.layer.shadowColor = UIColor.black.cgColor
            whiteBox.layer.shadowOpacity = 0.1
            whiteBox.layer.shadowOffset = CGSize(width: 0, height: 1)
            whiteBox.layer.shadowRadius = 5
            scrollView.addSubview(whiteBox)

            // Add the profile picture
            let profilePic = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
            profilePic.backgroundColor = .gray
            profilePic.layer.cornerRadius = 40
            profilePic.clipsToBounds = true
            whiteBox.addSubview(profilePic)

            // Add the post text
            let postText = UILabel(frame: CGRect(x: 100, y: 10, width: whiteBox.frame.width - 150, height: 60))
            postText.text = post.text
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

            // Add the like button
            let likeButton = UIButton(frame: CGRect(x: whiteBox.frame.width - 70, y: 30, width: 30, height: 30))
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .gray
            likeButton.tag = post.id.hashValue
            //likeButton.tag = post.test
            whiteBox.addSubview(likeButton)
            
            
            
            // Add the like count label
            let likeCountLabel = UILabel(frame: CGRect(x: whiteBox.frame.width - 40, y: 30, width: 40, height: 30))
            likeCountLabel.text = "\(post.like_count)"
            likeCountLabel.font = UIFont.systemFont(ofSize: 14)
            likeCountLabel.textColor = .gray
            likeCountLabel.tag = post.id.hashValue
            whiteBox.addSubview(likeCountLabel)
            
            likeCount += 1
            
            
            
            // Add target action to the like button
//            likeButton.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)
            likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)



            yOffset += 120
            

        }
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: yOffset + 200)

    }
    
//    @objc func likeButtonTapped(sender: UIButton) {
//        // Increase like count and update label
//        print("is button working")
//
//        if let index = posts.firstIndex(where: { String($0.id.hashValue) == String(sender.tag) }) {
//
//            print("is first if working")
//            posts[index].like_count += 1
//            if let likeCountLabel = sender.superview?.subviews.compactMap({ $0 as? UILabel }).first {
//
//                print("is second if working")
//                likeCountLabel.text = "\(posts[index].like_count)"
//            }
//
//            // Fill up heart icon red
//            sender.tintColor = .red
//            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
//    }
    
//    @objc func likeButtonTapped(sender: UIButton) {
//        // Increase like count and update label
//        print("is button working")
//
//        if let index = posts.firstIndex(where: { String($0.id.hashValue) == String(sender.tag) }) {
//            print("is first if working")
//            posts[index].like_count += 1
//            if let likeCountLabel = sender.superview?.subviews.compactMap({ $0 as? UILabel }).first {
//                print("is second if working")
//                likeCountLabel.text = "\(posts[index].like_count)"
//            }
//
//            // Fill up heart icon red
//            sender.tintColor = .red
//            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//        }
//    }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        if let index = posts.firstIndex(where: { $0.id.hashValue == sender.tag }) {
            // Increase like count for the post
            posts[index].like_count += 1
            print(posts[index].like_count)
            
            // Find the corresponding like count label
//            if let likeCountLabel = sender.superview?.subviews.first(where: { $0.tag == sender.tag }) as? UILabel {
//                // Update the like count label text
//                likeCountLabel.text = "\(posts[index].like_count)"
//            }
            
            if let likeCountLabel = sender.superview?.viewWithTag(1) as? UILabel {
                likeCountLabel.text = "\(posts[index].like_count)"
            }
            
            // Update the like button appearance
            sender.tintColor = .red
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
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
