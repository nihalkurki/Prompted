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
        
        ref.getDocuments { snapshot, error in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let defaultTimestamp = Timestamp(seconds: 0, nanoseconds: 0)
                    
                    let id = data["id"] as? String ?? ""
                    let text = data["text"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Timestamp ?? defaultTimestamp
                    
                    let post = Post(id: id, text: text, timestamp: timestamp)
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
        
        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 254/255, alpha: 1.0)
        

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
        
        
        var yOffset: CGFloat = 250

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
//            let input = formattedDateString(from: post.timestamp)
//            let postDate = calendar.date(from: input)
//            guard let date = postDate else { continue }
            
            
            
            
            
//            let input = formattedDateString(from: post.timestamp)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let postDate = dateFormatter.date(from: input)
//            guard let date = postDate else { continue }
//
//            // Only display posts from the current day
//            if !calendar.isDateInToday(date) {
//                continue
//            }
//
//            // Create the white box container
//            let whiteBox = UIView(frame: CGRect(x: 20, y: yOffset, width: view.frame.width - 40, height: 100))
//            whiteBox.backgroundColor = .white
//            whiteBox.layer.cornerRadius = 10
//            whiteBox.layer.shadowColor = UIColor.black.cgColor
//            whiteBox.layer.shadowOpacity = 0.1
//            whiteBox.layer.shadowOffset = CGSize(width: 0, height: 1)
//            whiteBox.layer.shadowRadius = 5
//            view.addSubview(whiteBox)
//
//            // Add the profile picture
//            let profilePic = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
//            profilePic.backgroundColor = .gray
//            profilePic.layer.cornerRadius = 40
//            profilePic.clipsToBounds = true
//            whiteBox.addSubview(profilePic)
//
//            // Add the post text
//            let postText = UILabel(frame: CGRect(x: 100, y: 10, width: whiteBox.frame.width - 150, height: 60))
//            postText.text = post.text
//            postText.numberOfLines = 0
//            postText.font = UIFont.systemFont(ofSize: 18)
//            whiteBox.addSubview(postText)
//
//            // Add the timestamp
//            dateFormatter.dateFormat = "h:mm a"
//            let timestampLabel = UILabel(frame: CGRect(x: 100, y: 70, width: whiteBox.frame.width - 150, height: 20))
//            timestampLabel.text = dateFormatter.string(from: date)
//            timestampLabel.font = UIFont.systemFont(ofSize: 14)
//            timestampLabel.textColor = .gray
//            whiteBox.addSubview(timestampLabel)
//
//            // Add the like button
//            let likeButton = UIButton(frame: CGRect(x: whiteBox.frame.width - 50, y: 30, width: 30, height: 30))
//            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//            likeButton.tintColor = .gray
//            whiteBox.addSubview(likeButton)
//
//            yOffset += 120
//
            
            
            

            
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

            yOffset += 120
            

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








class MyViewController: UIViewController {
    
    let dataManager = DataManager()
    var posts: [Post] {
        return dataManager.posts
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 254/255, alpha: 1.0)
        
        
        
        // Add white boxes for each post
        var yPosition = CGFloat(50)
        
        let whiteBox = UIView(frame: CGRect(x: 20, y: yPosition, width: view.frame.width - 40, height: 120))
        whiteBox.backgroundColor = .blue
        whiteBox.layer.cornerRadius = 10
        view.addSubview(whiteBox)
        
        for post in posts {
            let whiteBox = UIView(frame: CGRect(x: 20, y: yPosition, width: view.frame.width - 40, height: 120))
            whiteBox.backgroundColor = .blue
            whiteBox.layer.cornerRadius = 10
            view.addSubview(whiteBox)
            
            // Add profile picture to the left of the text
//            let profilePicture = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
//            profilePicture.image = UIImage(named: "profile_picture")
//            profilePicture.contentMode = .scaleAspectFill
//            profilePicture.layer.cornerRadius = profilePicture.frame.width/2
//            profilePicture.clipsToBounds = true
//            whiteBox.addSubview(profilePicture)
            
            // Add text label with post text
            let postText = UILabel(frame: CGRect(x: 70, y: 10, width: whiteBox.frame.width - 140, height: 60))
            postText.text = post.text
            postText.numberOfLines = 0
            postText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            whiteBox.addSubview(postText)
            
            // Add like button to the right of the text
//            let likeButton = UIButton(type: .system)
//            likeButton.frame = CGRect(x: whiteBox.frame.width - 60, y: 70, width: 50, height: 30)
//            likeButton.setTitle("Like", for: .normal)
//            likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
//            whiteBox.addSubview(likeButton)
            
            // Add timestamp label under the text
//            let timestampLabel = UILabel(frame: CGRect(x: 70, y: 80, width: whiteBox.frame.width - 140, height: 20))
//            let formatter = DateFormatter()
//            formatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
//            timestampLabel.text = formatter.string(from: post.timestamp.dateValue())
//            timestampLabel.textColor = .gray
//            timestampLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//            whiteBox.addSubview(timestampLabel)
            
            yPosition += 140
        }
    }
    
//    @objc func likeButtonTapped(_ sender: UIButton) {
//        // Handle like button tap event
//    }
    
}






class MyPostViewController: UIViewController {

//    // Array of posts
//    var posts = [
//        Post(id: "1", text: "First post", timestamp: Timestamp(year: 2023, month: 4, day: 3, hour: 10, minute: 30, second: 0)),
//        Post(id: "2", text: "Second post", timestamp: Timestamp(year: 2023, month: 4, day: 2, hour: 14, minute: 45, second: 0)),
//        Post(id: "3", text: "Third post", timestamp: Timestamp(year: 2023, month: 4, day: 3, hour: 16, minute: 0, second: 0)),
//        Post(id: "4", text: "Fourth post", timestamp: Timestamp(year: 2023, month: 4, day: 1, hour: 9, minute: 15, second: 0))
//    ]

    var dataManager = DataManager()
    var posts: [Post] {
        return dataManager.posts
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 254/255, alpha: 1)
        
        for post in posts {
            let containerView = UIView()
            containerView.backgroundColor = .white
            containerView.layer.cornerRadius = 10
            containerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(containerView)
            
            let profileImageView = UIImageView(image: UIImage(named: "profile"))
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(profileImageView)
            
            let textLabel = UILabel()
            textLabel.text = post.text
            textLabel.font = UIFont.systemFont(ofSize: 18)
            textLabel.numberOfLines = 0
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(textLabel)
            
            let timestampLabel = UILabel()
            timestampLabel.text = formatDate(post.timestamp)
            timestampLabel.font = UIFont.systemFont(ofSize: 14)
            timestampLabel.textColor = .gray
            timestampLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(timestampLabel)
            
            let likeButton = UIButton(type: .system)
            likeButton.setTitle("Like", for: .normal)
            likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            likeButton.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(likeButton)
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                profileImageView.widthAnchor.constraint(equalToConstant: 50),
                profileImageView.heightAnchor.constraint(equalToConstant: 50),
                
                textLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
                textLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
                textLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -10),
                
                timestampLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 10),
                timestampLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
                
                likeButton.topAnchor.constraint(equalTo: textLabel.topAnchor),
                likeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                
                containerView.bottomAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 10)
            ])
        }
    }
    
    
    
    
    
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//         //Set background color of view
//        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 254/255, alpha: 1.0)
//
////        view.backgroundColor = UIColor.green
//
//        // Get current date
//        let currentDate = Date()
//
//        // Filter posts to only include those from the current day
////        let currentDayPosts = posts.filter { post in
////            isPostFromCurrentDay(post.timestamp, currentDate: currentDate)
////        }
//
//        // Create a stack view to hold the white boxes for each post
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 16
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
//
//        // Add constraints for stack view
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 160),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -160),
//            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160)
//        ])
//
//        // Loop through current day posts and add a white box for each one
//        for post in posts {
//            // Create the white box view
//            let whiteBox = UIView()
//            whiteBox.backgroundColor = .white
//            whiteBox.layer.cornerRadius = 8
//            whiteBox.layer.shadowColor = UIColor.black.cgColor
//            whiteBox.layer.shadowOffset = CGSize(width: 0, height: 1)
//            whiteBox.layer.shadowOpacity = 0.1
//            whiteBox.layer.shadowRadius = 2
//            whiteBox.translatesAutoresizingMaskIntoConstraints = false
//            stackView.addArrangedSubview(whiteBox)
//
//            // Add constraints for white box view
//            NSLayoutConstraint.activate([
//                whiteBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
//            ])
//
//            // Create profile picture view
//            let profilePicture = UIImageView()
//            profilePicture.image = UIImage(named: "PromptlyLogo") // Replace with actual image
//            profilePicture.contentMode = .scaleAspectFit
//            profilePicture.layer.cornerRadius = 20
//            profilePicture.layer.masksToBounds = true
//            profilePicture.translatesAutoresizingMaskIntoConstraints = false
//            whiteBox.addSubview(profilePicture)
//
//            // Add constraints for profile picture view
//            NSLayoutConstraint.activate([
//                profilePicture.topAnchor.constraint(equalTo: whiteBox.topAnchor, constant: 8),
//                profilePicture.leadingAnchor.constraint(equalTo: whiteBox.leadingAnchor, constant: 8),
//                profilePicture.widthAnchor.constraint(equalToConstant: 40),
//                profilePicture.heightAnchor.constraint(equalToConstant: 40),
//            ])
//
//            // Create text label for post text
//            let postTextLabel = UILabel()
//            postTextLabel.text = post.text
//            postTextLabel.numberOfLines = 0
//            postTextLabel.translatesAutoresizingMaskIntoConstraints = false
//            whiteBox.addSubview(postTextLabel)
//
//            // Add constraints for post text label
//            NSLayoutConstraint.activate([
//                postTextLabel.topAnchor.constraint(equalTo: whiteBox.topAnchor, constant: 8),
//                postTextLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 8),
//                postTextLabel.trailingAnchor.constraint(equalTo: whiteBox.trailingAnchor, constant: -48),
//            ])
//
//            // Create timestamp label
//            let timestampLabel = UILabel()
//            timestampLabel.text = formatDate(post.timestamp)
//            timestampLabel.textColor = .gray
//            timestampLabel.font = UIFont.systemFont(ofSize: 12)
//            timestampLabel.translatesAutoresizingMaskIntoConstraints = false
//            whiteBox.addSubview(timestampLabel)
//
//            // Add constraints for timestamp label
//            NSLayoutConstraint.activate([
//                timestampLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 8),
//                timestampLabel.leadingAnchor.constraint(equalTo: postTextLabel.leadingAnchor),
//                timestampLabel.trailingAnchor.constraint(equalTo: postTextLabel.trailingAnchor),
//                timestampLabel.bottomAnchor.constraint(equalTo: whiteBox.bottomAnchor, constant: -8),
//            ])
//
//            // Create like button
//            let likeButton = UIButton()
//            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//            likeButton.tintColor = .gray
//            likeButton.translatesAutoresizingMaskIntoConstraints = false
//            whiteBox.addSubview(likeButton)
//
//            // Add constraints for like button
//            NSLayoutConstraint.activate([
//                likeButton.topAnchor.constraint(equalTo: whiteBox.topAnchor, constant: 8),
//                likeButton.trailingAnchor.constraint(equalTo: whiteBox.trailingAnchor, constant: -8),
//                likeButton.widthAnchor.constraint(equalToConstant: 24),
//                likeButton.heightAnchor.constraint(equalToConstant: 24),
//            ])
//        }
//    }
    
    // Function to check if a post is from the current day
//    func isPostFromCurrentDay(_ postTimestamp: Timestamp, currentDate: Date) -> Bool {
//        let calendar = Calendar.current
//        let postDate = calendar.date(from: postTimestamp)
//        let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
//        let postComponents = calendar.dateComponents([.year, .month, .day], from: postDate ?? Date())
//        return currentComponents == postComponents
//    }
    
//    // Function to check if a post is from the current day
//    func isPostFromCurrentDay(_ postTimestamp: Timestamp, currentDate: Date) -> Bool {
//        let calendar = Calendar.current
//        let postDate = Date(timeIntervalSince1970: TimeInterval(postTimestamp.seconds))
//        let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
//        let postComponents = calendar.dateComponents([.year, .month, .day], from: postDate)
//        return currentComponents == postComponents
//    }
    
//    // Function to format a timestamp as a string
//    func formatDate(_ timestamp: Timestamp) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm a"
//        let date = Calendar.current.date(from: timestamp) ?? Date()
//        return dateFormatter.string(from: date)
//    }
    
    // Function to format a timestamp as a string
    func formatDate(_ timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        return dateFormatter.string(from: date)
    }
}






//class MyPostViewController: UIViewController {
//
//    //let posts: [Post] // assume this is set elsewhere
//    var dataManager = DataManager()
//    var posts: [Post] {
//        return dataManager.posts
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // set background color of view controller
//        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 254/255, alpha: 1)
//
//        // loop over posts and create a label for each post
//        let currentDate = Date() // get the current date and time
//        var y: CGFloat = 50 // y-coordinate of the first post label
//        for post in posts {
//            // check if post is from current day
//            if isPostFromCurrentDay(post.timestamp, currentDate: currentDate) {
//                // create white box view for post label
//                let postView = UIView(frame: CGRect(x: 20, y: y, width: view.bounds.width - 40, height: 100))
//                postView.backgroundColor = .white
//                postView.layer.cornerRadius = 10
//
//                // create label for post text
//                let textLabel = UILabel(frame: CGRect(x: 10, y: 10, width: postView.bounds.width - 80, height: 80))
//                textLabel.text = post.text
//                textLabel.numberOfLines = 0
//                textLabel.font = UIFont.systemFont(ofSize: 16)
//                postView.addSubview(textLabel)
//
//                // create button for like
//                let likeButton = UIButton(frame: CGRect(x: postView.bounds.width - 60, y: 10, width: 50, height: 30))
//                likeButton.setTitle("Like", for: .normal)
//                likeButton.setTitleColor(.blue, for: .normal)
//                likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
//                postView.addSubview(likeButton)
//
//                // create label for timestamp
//                let timestampLabel = UILabel(frame: CGRect(x: 10, y: textLabel.frame.maxY + 5, width: postView.bounds.width - 20, height: 20))
//                timestampLabel.text = formatTimestamp(post.timestamp)
//                timestampLabel.font = UIFont.systemFont(ofSize: 12)
//                timestampLabel.textColor = .gray
//                postView.addSubview(timestampLabel)
//
//                // add post view to view controller's view
//                view.addSubview(postView)
//
//                // increment y-coordinate for next post label
//                y += postView.bounds.height + 20
//            }
//        }
//    }
//
//    // check if a given timestamp is from the current day
//    func isPostFromCurrentDay(_ timestamp: Timestamp, currentDate: Date) -> Bool {
//        let calendar = Calendar.current
//        let postDate = calendar.date(from: timestamp)
//        return calendar.isDate(postDate ?? Date(), inSameDayAs: currentDate)
//    }
//
//    // format a timestamp as a string
//    func formatTimestamp(_ timestamp: Timestamp) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .none
//        formatter.timeStyle = .short
//        return formatter.string(from: timestamp)
//    }
//
//    // handle like button tap
//    @objc func likeButtonTapped(_ sender: UIButton) {
//        print("Like button tapped for post with text: \(sender.superview?.subviews.first(where: { $0 is UILabel })?.asInstanceOf[UILabel]?.text ?? "")")
//    }
//
//}






class PostListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataManager = DataManager()
    var posts: [Post] {
        return dataManager.posts
    }

    let tableView = UITableView()

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 254/255, alpha: 1.0)
        //view.backgroundColor = UIColor.green


        // Add the table view to the view controller's view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)


        NSLayoutConstraint.activate([
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: view.bounds.height/2),
        ])

//        NSLayoutConstraint.activate([
//            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//        ])

        // Set the table view's delegate and data source
        tableView.delegate = self
        tableView.dataSource = self

        // Register the table view cell class
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Subscribe to changes in the DataManager's posts variable
        dataManager.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = formatTimestamp(post.timestamp)

        cell.detailTextLabel?.textColor = .gray // optional: set the timestamp color
        cell.imageView?.image = UIImage(systemName: "plus") // optional: add a clock icon next to the timestamp
//        cell.accessoryType = .disclosureIndicator // optional: add a disclosure indicator to the cell
        cell.selectionStyle = .none

        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        //cell.textLabel?.lineBreakMode = .byWordWrapping
        //cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.sizeToFit()
        cell.detailTextLabel?.sizeToFit()

        let textHeight = cell.textLabel?.frame.height ?? 0
        let detailTextHeight = cell.detailTextLabel?.frame.height ?? 0
        let contentHeight = textHeight + detailTextHeight + 20 // add some padding

        cell.contentView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle row selection if necessary
    }

    // MARK: - Private methods

    private func formatTimestamp(_ timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: timestamp.dateValue())
    }
}
