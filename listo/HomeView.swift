//
//  HomeView.swift
//  listo
//
//  Created by Charles on 9/9/17.
//  Copyright © 2017 Charles. All rights reserved.
//
import Foundation
import UIKit
import FirebaseAuth

var groupArray = [String]()
class HomeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func join(_ sender: Any) {
        let alert = UIAlertController(title: "Join a group", message: "Enter the name", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Group"
        }
        
        
        
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { [weak alert] (_) in
            if alert?.textFields![0].text != "" {
                groupArray.append((alert?.textFields?[0].text)!)
                let groupDefault = UserDefaults.standard
                groupDefault.set(groupArray, forKey: "groupArr")
                self.TableView.reloadData()
            }
            else{
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func signout(_ sender: Any) {
        do{
            try FIRAuth.auth()?.signOut()
            usernameText = nil
            passwordText = nil
            groupArray.removeAll()
            let saveDefault = UserDefaults.standard
            
            saveDefault.set(usernameText, forKey: "user")
            saveDefault.set(passwordText, forKey: "pass")
            saveDefault.set(groupArray, forKey: "groupArr")
            
            self.performSegue(withIdentifier: "SignOut", sender: nil)
        }
        catch{
            notification(title: "Error", message: "Unable to sign out, please try again")
        }

    }
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var signoutlet: UIBarButtonItem!
    @IBOutlet weak var plusoutlet: UIBarButtonItem!
    @IBOutlet weak var titlOut: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        let groupDefault = UserDefaults.standard
        if groupDefault.array(forKey: "groupArr") as? [String] != nil{
            groupArray = groupDefault.array(forKey: "groupArr") as! [String]
        }
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 48/255, green: 150/255, blue: 1, alpha: 3)
        signoutlet.tintColor = .white
        plusoutlet.tintColor = .white
        navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home")
        let name = cell?.viewWithTag(1) as! UILabel
        name.text = groupArray[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            groupArray.remove(at: indexPath.row)
            let groupDefault = UserDefaults.standard
            groupDefault.set(groupArray, forKey: "groupArr")
            TableView.reloadData()
        }
    }
    
    func notification(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        TableView.cellForRow(at: indexPath)?.isHighlighted = false
       
        group = groupArray[indexPath.row]
        self.performSegue(withIdentifier: "list", sender: nil)
    }
    

}
