//
//  ViewReponses.swift
//  Promptly
//
//  Created by Nihal Kurki on 3/25/23.
//

import UIKit
import Firebase

class ViewResponsesScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color to red
        view.backgroundColor = .green
        
//
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
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
    
    }
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
