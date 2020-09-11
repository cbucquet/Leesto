//
//  ViewLogin.swift
//  listo
//
//  Created by Charles on 9/3/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

var usernameText : String!
var passwordText : String!


class ViewLogin: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(colorLiteralRed: 48/255, green: 150/255, blue: 1, alpha: 3)
        loginbtn.backgroundColor = UIColor(colorLiteralRed: 0.4, green: 0.8, blue: 0.8, alpha: 1)
        loginbtn.setTitleColor(UIColor.white, for: .normal)
        sigupbtn.layer.cornerRadius = 5.0
        sigupbtn.clipsToBounds = true
        sigupbtn.layer.borderWidth = 1.0

        
        sigupbtn.setTitleColor(UIColor.white, for: .normal)
        sigupbtn.layer.borderWidth = 1.0
        sigupbtn.layer.borderColor = UIColor.white.cgColor
        sigupbtn.layer.cornerRadius = 5.0
        sigupbtn.clipsToBounds = true
        
        
        let saveDefaults = UserDefaults.standard
        usernameText = saveDefaults.value(forKey: "user") as? String
        passwordText = saveDefaults.value(forKey: "pass") as? String
        if usernameText != nil && passwordText != nil{
            login(username: usernameText, password: passwordText)
        }
        
    }
    
    @IBOutlet weak var loginbtn: UIButton!
    @IBOutlet weak var sigupbtn: UIButton!
    
    @IBAction func SignUp(_ sender: Any) {
        if username.text != nil && password.text != nil{
            FIRAuth.auth()?.createUser(withEmail: username.text!, password: password.text!, completion: { (user, error) in
                if user != nil{
                    //notification ACCOUNT CREATED
                    self.notification(title: "Account created", message: "Account created with the email address \(self.username.text!)")
                }
                else{
                    if let myError = error?.localizedDescription{
                        //notification ERROR
                        self.notification(title: "Error", message: "\(myError)")

                    }
                    else{
                        //notification
                        self.notification(title: "Error", message: "An error has occured, please try again")

                    }
                }
            })
        }
        else{
            //notification
            self.notification(title: "Error", message: "Please enter a valid username and password")
            
        }

    }
    
    
    @IBAction func Login(_ sender: Any) {
        if username.text != nil && password.text != nil{
            login(username: username.text!, password: password.text!)
        }
        else{
            self.notification(title: "Error", message: "Please enter a valid username and password")
        }
    }
    func login(username: String, password: String){
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user, error) in
            if user != nil{
                let saveDefault = UserDefaults.standard
                saveDefault.set(username, forKey: "user")
                saveDefault.set(password, forKey: "pass")
                usernameText = username
                passwordText = password
                self.performSegue(withIdentifier: "go", sender: nil)
            }
            else{
                if let myError = error?.localizedDescription{
                    //notification ERROR
                    self.notification(title: "Error", message: "\(myError)")
                }
                else{
                    //notification
                    self.notification(title: "Error", message: "An error has occured, please try again")
                }
            }
        })
      
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func notification(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
        self.view.endEditing(true)
    }
    
}
