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
        
        
        var yOffset: CGFloat = 200

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

        for post in posts {
            
            
            let input = formattedDateString(from: post.timestamp)
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.dateFormat = "MMM d, yyyy"
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
            view.addSubview(whiteBox)

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

            // Add the timestamp
            let timestampLabel = UILabel(frame: CGRect(x: 100, y: 70, width: whiteBox.frame.width - 150, height: 20))
            timestampLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
            timestampLabel.font = UIFont.systemFont(ofSize: 14)
            timestampLabel.textColor = .gray
            whiteBox.addSubview(timestampLabel)

            // Add the like button
            let likeButton = UIButton(frame: CGRect(x: whiteBox.frame.width - 50, y: 30, width: 30, height: 30))
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .gray
            whiteBox.addSubview(likeButton)
            
            // Add the like count label
            let likeCountLabel = UILabel(frame: CGRect(x: whiteBox.frame.width - 39, y: 60, width: 40, height: 20))
            likeCountLabel.text = "\(post.like_count)"
            likeCountLabel.font = UIFont.systemFont(ofSize: 14)
            likeCountLabel.textColor = .gray
            whiteBox.addSubview(likeCountLabel)
            
            
            
            // Add target action to the like button
            likeButton.addTarget(self, action: #selector(likeButtonTapped(sender:)), for: .touchUpInside)

            
            
            

            yOffset += 120
            

        }
    }
    
    @objc func likeButtonTapped(sender: UIButton) {
        // Increase like count and update label
        print("is button working")

        if let index = posts.firstIndex(where: { String($0.id) == String(sender.tag) }) {
            
            print("is first if working")
            posts[index].like_count += 1
            if let likeCountLabel = sender.superview?.subviews.compactMap({ $0 as? UILabel }).first {
                
                print("is second if working")
                likeCountLabel.text = "\(posts[index].like_count)"
            }
            
            // Fill up heart icon red
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
