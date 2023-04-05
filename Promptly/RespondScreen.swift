//
//  RespondScreen.swift
//  Promptly
//
//  Created by Nihal Kurki on 3/25/23.
//

import UIKit
import Firebase

class RedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to red
        view.backgroundColor = .red
        
       
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        if let email = FirebaseAuth.Auth.auth().currentUser?.email {
            label.text = "Welcome " + email
        } else {
            // Handle the case where currentUser is nil or email is nil
            label.text = "Welcome"
        }
        //label.text = "Welcome" + FirebaseAuth.Auth.auth().currentUser?.email
        label.textAlignment = .center
        label.center = view.center
        view.addSubview(label)
        
        // Add a label to the view
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
//        label.text = "This is the red screen"
//        label.textAlignment = .center
//        label.center = view.center
//        view.addSubview(label)
        
        // Add a button to the view
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.center = CGPoint(x: view.center.x, y: view.center.y + 100)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        
        // Add a button to the view
        let post = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        post.setTitle("Post", for: .normal)
        post.setTitleColor(.white, for: .normal)
        post.backgroundColor = .black
        post.center = CGPoint(x: view.center.x, y: view.center.y + 200)
        post.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        view.addSubview(post)
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func postButtonTapped() {
//        let viewScreen = ViewResponsesScreen()
//        viewScreen.modalPresentationStyle = .fullScreen
//        viewScreen.modalTransitionStyle = .crossDissolve
//        self.present(viewScreen, animated: true, completion: nil)
        
//        let viewScreen = PostListViewController()
//        viewScreen.modalPresentationStyle = .fullScreen
//        viewScreen.modalTransitionStyle = .crossDissolve
//        self.present(viewScreen, animated: true, completion: nil)
        
        let viewScreen = MyNewViewController()
        viewScreen.modalPresentationStyle = .fullScreen
        viewScreen.modalTransitionStyle = .crossDissolve
        self.present(viewScreen, animated: true, completion: nil)

    }
}
