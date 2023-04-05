
import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PersonTalking")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.5
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Full Name"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
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
    
    private let password2TextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Re-Enter Password"
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
        button.backgroundColor = UIColor(red: 110/255, green: 40/255, blue: 184/255, alpha: 1.0)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 235/255, green: 220/255, blue: 255/255, alpha: 1.0)
        
        // Add subviews
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(password2TextField)
        view.addSubview(signUpButton)
        view.addSubview(backgroundImage)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            password2TextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            password2TextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            password2TextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            password2TextField.heightAnchor.constraint(equalToConstant: 40),
            
            signUpButton.topAnchor.constraint(equalTo: password2TextField.bottomAnchor, constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            
            backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 275),
            backgroundImage.widthAnchor.constraint(equalToConstant: 300),
            backgroundImage.heightAnchor.constraint(equalToConstant: 300)
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
            redVC.modalTransitionStyle = .crossDissolve
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


