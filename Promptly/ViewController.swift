

import UIKit
import FirebaseAuth
import SwiftUI

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PromptedHome")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "People")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 1
        return imageView
    }()
    
    private let prompt: UILabel = {
        let label = UILabel()
        label.text = "Today's Prompt!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 110/255, green: 40/255, blue: 184/255, alpha: 1.0)
        label.font = UIFont(name: "Helvetica Bold", size: 24)
        return label
    }()
    
    private let prompt2: UILabel = {
        let label2 = UILabel()
        label2.text = "What is a boring fact about you?"
        label2.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label2.font = UIFont(name: "Helvetica", size: 18)
        label2.textAlignment = .center
        label2.textColor = UIColor(red: 110/255, green: 40/255, blue: 184/255, alpha: 1.0)
        label2.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        label2.translatesAutoresizingMaskIntoConstraints = false
        return label2
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
        view.backgroundColor = UIColor(red: 235/255, green: 220/255, blue: 255/255, alpha: 1.0)
        
        
        // Create a button
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = UIColor(red: 110/255, green: 40/255, blue: 184/255, alpha: 1.0)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.clipsToBounds = true
//        signUpButton.titleLabel?.font = UIFont.init(name: "Damascus", size: 18)
        signUpButton.layer.cornerRadius = 5
        view.addSubview(signUpButton)
        
        let respondButton = UIButton()
        respondButton.setTitle("Respond", for: .normal)
        respondButton.setTitleColor(.white, for: .normal)
        respondButton.backgroundColor = UIColor(red: 110/255, green: 40/255, blue: 184/255, alpha: 1.0)
        respondButton.translatesAutoresizingMaskIntoConstraints = false
        respondButton.clipsToBounds = true
        respondButton.layer.cornerRadius = 5
        view.addSubview(respondButton)
        
        respondButton.isHidden = true
        
        let signOutButton = UIButton()
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.backgroundColor = UIColor(red: 120/255, green: 67/255, blue: 230/255, alpha: 1.0)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.clipsToBounds = true
        view.addSubview(signOutButton)
        
        signOutButton.isHidden = true
        
        //view.addSubview(backgroundImage2)
        view.addSubview(imageView)
        view.addSubview(backgroundImage)
        view.addSubview(prompt)
        view.addSubview(prompt2)
                
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
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 275),
            backgroundImage.widthAnchor.constraint(equalToConstant: 300),
            backgroundImage.heightAnchor.constraint(equalToConstant: 300),

            prompt.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            prompt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            prompt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            prompt.heightAnchor.constraint(equalToConstant: 30),
            
            prompt2.topAnchor.constraint(equalTo: prompt.bottomAnchor, constant: 20),
            prompt2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            prompt2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            prompt2.heightAnchor.constraint(equalToConstant: 30)
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



