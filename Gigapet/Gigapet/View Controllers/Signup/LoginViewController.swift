//
//  LoginViewController.swift
//  Gigapet
//
//  Created by Alex on 5/20/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
//import SwiftyJWT

class LoginViewController: UIViewController {
    
    // MARK: - Constants
    
    let nc = NetworkController()
    
    // MARK: - Outlets
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    private let baseURL = URL(string: "https://giga-back-end.herokuapp.com/api")!
    // MARK: - Actions
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        // Validate required fields are not empty
        let userName = usernameTextField.text
        let userPassword = passwordTextField.text
        
        if (usernameTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! {
            // Display Alert message and return
            return
        }
        let url = baseURL.appendingPathComponent("users/login")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let postString = ["name": userName!, "password": userPassword!] as [String: String]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    if parseJSON["errorMessageKey"] != nil {
                        return
                    }
                    
                    // Now we can access value of First Name by its key
                    let accessToken = parseJSON["token"] as? String
                    let userId = parseJSON["id"] as? Int64
                    print("Access token: \(String(describing: accessToken!))")
                    
                    let saveAccesssToken: Bool = KeychainWrapper.standard.set(accessToken!, forKey: "accessToken")
                    let saveUserId: Bool = KeychainWrapper.standard.set(String(describing:userId!), forKey: "userId")
                    
                    print("The access token save result: \(saveAccesssToken)")
                    print("The userId save result \(saveUserId)")
                    
                    if (accessToken?.isEmpty)! {
                        // Display an Alert dialog with a friendly error message
                        print("no issued token")
                        return
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "Login Segue", sender: self)
                    }
                }
            } catch {
                
                print("\(error)")
                return
                
            }
            
            
            
        }
        task.resume()
        
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Login Segue" {
            guard let destinationVC = segue.destination as? MainPageViewController else { return }
        }
    }
    
    // MARK: - Functions
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                // Code in this block will trigger when OK button tapped.
                print("Ok button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
  
    
    
}



