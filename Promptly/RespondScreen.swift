//
//  RespondScreen.swift
//  Promptly
//
//  Created by Nihal Kurki on 3/25/23.
//

import UIKit
import FirebaseFirestore
import Firebase

class RedViewController: UIViewController, UITextFieldDelegate {
    let db = Firestore.firestore()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PromptlyLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let prompt: UILabel = {
        let label = UILabel()
        label.text = "Who would win in a fight between a Silverback gorilla and a Grizzly bear?"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping

        return label
    }()
    
    let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color
        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 254/255, alpha: 1.0)

        //**********
        view.addSubview(imageView)
        view.addSubview(prompt)
                
        // Set up text field
        textField.frame = CGRect(x: 50, y:420, width: 300, height: 150)
        textField.placeholder = "What's your response?"
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

            prompt.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -50),
            prompt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            prompt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            prompt.heightAnchor.constraint(equalToConstant: 250),
            
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
        post.setTitle("Post", for: .normal)
        post.setTitleColor(.white, for: .normal)
        post.backgroundColor = .black
        post.center = CGPoint(x: view.center.x, y: view.center.y + 230)
        post.layer.cornerRadius = 5
        post.layer.borderWidth = 1
        post.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        view.addSubview(post)
        
        // Add a button to the view
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.center = CGPoint(x: view.center.x, y: view.center.y + 300)
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
        
        db.collection("Post").addDocument(data: [
                "text": userResponse,
                "timestamp": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with ID: NO ID recorded")
                }
            }
        
        let viewScreen = ViewResponsesScreen()
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
