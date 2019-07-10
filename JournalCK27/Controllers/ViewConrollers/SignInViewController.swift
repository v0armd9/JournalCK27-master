//
//  SignInViewController.swift
//  JournalCK27
//
//  Created by Darin Marcus Armstrong on 7/10/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserController.shared.fetchUser { (success) in
            if success {
                self.presentJournalView()
            }
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
        let email = emailTextField.text, !email.isEmpty
            else {return}
        UserController.shared.createUserWith(username: username, email: email) { (user) in
            if user != nil {
                self.presentJournalView()
            }
        }
    }
    
    func presentJournalView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let entriesViewController = storyboard.instantiateViewController(withIdentifier: "EntryNavigationVC")
            self.present(entriesViewController, animated: true)
        }
    }
}
