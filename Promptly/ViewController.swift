//
//  ViewController.swift
//  Promptly
//
//  Created by Nihal Kurki on 3/22/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PromptlyLogo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let prompt: UILabel = {
        let label = UILabel()
        label.text = "Prompted!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let SignUpButton: UIButton = {
        let SignUpButton = UIButton()
        SignUpButton.backgroundColor = .systemGreen
        SignUpButton.setTitleColor(.white, for: .normal)
        SignUpButton.setTitle("Sign Up", for: .normal)
        return SignUpButton
    }()
    
    private let RespondButton: UIButton = {
        let RespondButton = UIButton()
        RespondButton.backgroundColor = .systemGreen
        RespondButton.setTitleColor(.white, for: .normal)
        RespondButton.setTitle("Respond", for: .normal)
        return RespondButton
    }()
    
    private let LogOutButton: UIButton = {
        let LogOutButton = UIButton()
        LogOutButton.backgroundColor = .systemGreen
        LogOutButton.setTitleColor(.white, for: .normal)
        LogOutButton.setTitle("Log Out", for: .normal)
        return LogOutButton
    }()

    override func viewDidLoad() {
        //super.viewDidLoad()
        //view.backgroundColor = .systemRed
        // Do any additional setup after loading the view.
        
        
        if (FirebaseAuth.Auth.auth().currentUser != nil) {
            showLoginScreen()
        }
        
        
        
        
        super.viewDidLoad()
        view.addSubview(SignUpButton)
        view.addSubview(RespondButton)
        view.addSubview(LogOutButton)
        
        // Set background color
        view.backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 254/255, alpha: 1.0)
         
        // Create a button
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .blue
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
        
        let respondButton = UIButton()
        respondButton.setTitle("Respond", for: .normal)
        respondButton.setTitleColor(.white, for: .normal)
        respondButton.backgroundColor = .blue
        respondButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(respondButton)
        
        respondButton.isHidden = true
        
        let signOutButton = UIButton()
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.backgroundColor = .blue
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signOutButton)
        
        signOutButton.isHidden = false
        
        view.addSubview(imageView)
        view.addSubview(prompt)
                
        // Add constraints to the button
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 150),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            respondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            respondButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            respondButton.widthAnchor.constraint(equalToConstant: 150),
            respondButton.heightAnchor.constraint(equalToConstant: 50),
            
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 160),
            signOutButton.widthAnchor.constraint(equalToConstant: 150),
            signOutButton.heightAnchor.constraint(equalToConstant: 50),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            prompt.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            prompt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            prompt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            prompt.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Add an action to the button
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            respondButton.isHidden = false
            signUpButton.isHidden = true
        }
        
        respondButton.addTarget(self, action: #selector(respondButtonTapped), for: .touchUpInside)
        
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        
        
        
    }
    
    @objc func signUpButtonTapped() {
        // Present a different screen
        let SignUpScreen = SignUpViewController()
        SignUpScreen.modalPresentationStyle = .fullScreen
        //SignUpScreen.view.backgroundColor = .white
        present(SignUpScreen, animated: true, completion: nil)
    }
    
    @objc func showLoginScreen() {
        let redVC = RedViewController()
        redVC.modalPresentationStyle = .fullScreen
        self.present(redVC, animated: true, completion: nil)
    }
    
    
    @objc func respondButtonTapped() {
        // Present a different screen
        let Respond = UIViewController()
        Respond.view.backgroundColor = .orange
        Respond.modalPresentationStyle = .fullScreen
        present(Respond, animated: true, completion: nil)
    }
    
    @objc func signOutButtonTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
        }
        catch {
            print("An Error While Signing Out Occured")
        }
        
    }
    


}

