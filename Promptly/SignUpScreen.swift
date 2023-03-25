//
//  SignUpScreen.swift
//  Promptly
//
//  Created by Nihal Kurki on 3/22/23.
//
import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        textField.textContentType = .init(rawValue: "")
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(with: "Error", message: "Please enter an email address")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(with: "Error", message: "Please enter a password")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(with: "Error", message: error.localizedDescription)
                return
            }
            
            // User created successfully, do something here
            
            
            //self.performSegue(withIdentifier: "SignUpSuccessSegue", sender: self)
            // Present a different screen
//            let signUpScreen = UIViewController()
//            signUpScreen.view.backgroundColor = .white
//            present(signUpScreen, animated: true, completion: nil)
            
            
//            self.emailTextField.isHidden = true
//            self.passwordTextField.isHidden = true
//            self.signUpButton.isHidden = true
            
            let redVC = RedViewController()
            redVC.modalPresentationStyle = .fullScreen
            self.present(redVC, animated: true, completion: nil)
            //self.navigationController?.pushViewController(redVC, animated: true)
            
//            let redVC = UIViewController()
//            redVC.view.backgroundColor = UIColor.red
//            // push the new view controller onto the navigation stack
//            DispatchQueue.main.async {
//                self.navigationController?.pushViewController(redVC, animated: true)
//            }
            
            //self.dismiss(animated: true, completion: nil)
            
            print("User signed up successfully")
                        
            // Perform segue to the SignUpSuccessViewController
//            self.performSegue(withIdentifier: "SignUpSuccessSegue", sender: nil)
            
//            let redVC = RedViewController()
//            self.pushViewController(redVC, animated: true)
        }
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}


