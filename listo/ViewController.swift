//
//  ViewController.swift
//  listo
//
//  Created by Charles on 9/3/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


struct item {
    var name : String
    var quantity : Int
    var ischecked : Bool
    var bywhom : String
}

var group : String!

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var emojis = ["Apple": "🍏", "Pear": "🍐", "Orange": "🍊", "Lemon": "🍋", "Banana": "🍌", "Watermelon": "🍉", "Grapes": "🍇", "Strawberries": "🍓", "Cherry": "🍒", "Pineapple": "🍍", "Kiwi": "🥝", "Avocado": "🥑", "Tomato": "🍅", "Cucumber": "🥒", "carrot": "🥕", "corn": "🌽", "potato": "🥔", "nuts": "🥜", "peanuts": "🥜", "Croissant": "🥐", "bread": "🍞", "baguette": "🥖", "cheese": "🧀", "eggs": "🥚", "bacon": "🥓", "pancakes": "🥞", "shrimps": "🍤", "chicken": "🍗", "pizza": "🍕", "hotdogs": "🌭", "burgers": "🍔", "fries": "🍟", "tacos": "🌮", "burrito": "🌯", "salad": "🥗", "pasta": "🍝", "soup": "🍜", "sushi": "🍣", "rice": "🍚", "ice cream": "🍦", "cake": "🍰", "candy": "🍬", "lolipop": "🍭", "chocolate": "🍫", "popcorn": "🍿", "donuts": "🍩", "cookies": "🍪", "milk": "🥛", "coffee": "☕️", "tea": "🍵", "beer": "🍺", "wine": "🍷", "champagne": "🍾", "coconut": "🍈"  ]
    
    @IBOutlet weak var plusoutlet1: UIBarButtonItem!
    @IBAction func addproduct(_ sender: Any) {
        let alert = UIAlertController(title: "Add an item", message: "Please enter the following:", preferredStyle: .alert)
        var item = ""
        var quantity = Int()
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter an item"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter a quantity (default 1)"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { [weak alert] (_) in
            if alert?.textFields![0].text != nil && alert?.textFields![1].text != nil{
                if Int((alert?.textFields?[1].text)!) == nil{
                    item = (alert?.textFields![0].text)!
                    quantity = 1
                    if group != nil{
                        self.post(food: item, quantity: quantity)
                    }
                }
                else{
                    item = (alert?.textFields![0].text)!
                    quantity = Int((alert?.textFields![1].text)!)!
                    if group != nil{
                        self.post(food: item, quantity: quantity)
                    }

                }}
            
            else{
            }
        }))
       
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    var list = [item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleList.title = group
        TblView.delegate = self
        TblView.dataSource = self
        if group != nil{
            getdata()
        }
        plusoutlet1.tintColor = .white
        navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    @IBOutlet weak var titleList: UINavigationItem!
    override func viewDidAppear(_ animated: Bool) {
        titleList.title = group
        
    }
   
    
    
    @IBOutlet weak var TblView: UITableView!
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
       
        let product = cell?.viewWithTag(1) as! UILabel
        let quantity = cell?.viewWithTag(2) as! UILabel
        let who = cell?.viewWithTag(5) as! UILabel
       
        var productW = list[indexPath.row].name.capitalized
        
        for word in emojis{
            if list[indexPath.row].name.lowercased() == word.key.lowercased(){
                productW = word.value
                productW += " "
                productW += list[indexPath.row].name.capitalized
            }
        }
        product.text = "\(productW)"

        quantity.text = "quantity: \(Int(list[indexPath.row].quantity))"
        
        if list[indexPath.row].ischecked == true{
            cell?.backgroundColor = .yellow
            who.text = list[indexPath.row].bywhom
            who.isHidden = false
        }
        else{
            cell?.backgroundColor = .white
            who.isHidden = true
        }
        
        
        return cell!
        
        
        
    }
    
    func post(food: String, quantity: Int){
        //let post : [String: AnyObject] = ["item" : food as AnyObject, "quantity": quantity as AnyObject]
        var postN = [String]()
        var postQ = [Int]()
        var postI = [Bool]()
        var postB = [String]()
        if list.count >= 1{
            for index in 0...list.count - 1{
                postN.append(list[index].name)
                postQ.append(list[index].quantity)
                postI.append(list[index].ischecked)
                postB.append(list[index].bywhom)
            }
        }
        postN.append(food)
        postQ.append(quantity)
        postI.append(false)
        postB.append("")
        
        let databaseref = FIRDatabase.database().reference()
        let databaserefQ = FIRDatabase.database().reference()
        let databaserefI = FIRDatabase.database().reference()
        let databaserefB = FIRDatabase.database().reference()


        databaseref.child("list").child("\(group!)").child("items").setValue(postN)
        databaserefQ.child("list").child("\(group!)").child("quantity").setValue(postQ)
        databaserefI.child("list").child("\(group!)").child("ischecked").setValue(postI)
        databaserefB.child("list").child("\(group!)").child("bywhom").setValue(postB)


        
    }
    func post(){
        //let post : [String: AnyObject] = ["item" : food as AnyObject, "quantity": quantity as AnyObject]
        var postN = [String]()
        var postQ = [Int]()
        var postI = [Bool]()
        var postB = [String]()
        if list.count >= 1{
            for index in 0...list.count - 1{
                postN.append(list[index].name)
                postQ.append(list[index].quantity)
                postI.append(list[index].ischecked)
                postB.append(list[index].bywhom)
            }
        }
       
        let databaseref = FIRDatabase.database().reference()
        let databaserefQ = FIRDatabase.database().reference()
        let databaserefI = FIRDatabase.database().reference()
        let databaserefB = FIRDatabase.database().reference()

        
        databaseref.child("list").child("\(group!)").child("items").setValue(postN)
        databaserefQ.child("list").child("\(group!)").child("quantity").setValue(postQ)
        databaserefI.child("list").child("\(group!)").child("ischecked").setValue(postI)
        databaserefB.child("list").child("\(group!)").child("bywhom").setValue(postB)

        
    }
    func postBy(){
        //let post : [String: AnyObject] = ["item" : food as AnyObject, "quantity": quantity as AnyObject]
        var postN = [String]()
        var postQ = [Int]()
        var postI = [Bool]()
        var postB = [String]()
        if list.count >= 1{
            for index in 0...list.count - 1{
                postN.append(list[index].name)
                postQ.append(list[index].quantity)
                postI.append(list[index].ischecked)
                postB.append(list[index].bywhom)
            }
        }
        
        let databaseref = FIRDatabase.database().reference()
        let databaserefQ = FIRDatabase.database().reference()
        let databaserefI = FIRDatabase.database().reference()
        let databaserefB = FIRDatabase.database().reference()
        
        
        databaseref.child("list").child("\(group!)").child("items").setValue(postN)
        databaserefQ.child("list").child("\(group!)").child("quantity").setValue(postQ)
        databaserefI.child("list").child("\(group!)").child("ischecked").setValue(postI)
        databaserefB.child("list").child("\(group!)").child("bywhom").setValue(postB)
        
        
    }


    
    func getdata(){

        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("list/\(group!)").queryOrderedByKey().observe(.value, with: {
            (snapchot) in
            var newItemsN: [String] = []
            var newItemsQ: [Int] = []
            var newItemsI: [Bool] = []
            var newItemsB: [String] = []

            if snapchot.exists(){
                let posts = snapchot.value as! [String: AnyObject]?
           
                if let Actual : [String: NSArray] = posts as? [String : NSArray] {
                    if Actual["items"]?.count == Actual["quantity"]?.count && Actual["quantity"]?.count == Actual["ischecked"]?.count && Actual["bywhom"]?.count == Actual["ischecked"]?.count{
                        for word in Actual["items"]!{
                            newItemsN.append(word as! String)
                        }
                        for nb in Actual["quantity"]!{
                            newItemsQ.append(nb as! Int)
                        }
                        for boolean in Actual["ischecked"]!{
                            newItemsI.append(boolean as! Bool)
                        }
                        for word in Actual["bywhom"]!{
                            newItemsB.append(word as! String)
                        }

                        self.list.removeAll()
                        for index in 0...newItemsQ.count - 1{
                            self.list.append(item(name: newItemsN[index], quantity: newItemsQ[index], ischecked: newItemsI[index], bywhom: newItemsB[index]))
                        }

                    }
                }
            
            
                
                self.TblView.reloadData()
            }
            
        })

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { action, index in
            self.list.remove(at: editActionsForRowAt.row)
            self.post()
            
            self.TblView.reloadData()
        }
        delete.backgroundColor = .red
        
        var Do = UITableViewRowAction()

        if list[editActionsForRowAt.row].ischecked == true{
            Do = UITableViewRowAction(style: .default, title: "mark as \n\"to buy\"", handler: {
                action, index in
                
                self.list[editActionsForRowAt.row].ischecked = false
                self.post()
                
            })

        }
        else{
            Do = UITableViewRowAction(style: .default, title: "mark as \nbought", handler: {
                action, index in
                
                self.list[editActionsForRowAt.row].ischecked = true
                var token = usernameText.components(separatedBy: "@")
                self.list[editActionsForRowAt.row].bywhom = token[0]
                self.post()
                
            })

        }
        Do.backgroundColor = UIColor(colorLiteralRed: 68/255, green: 155/255, blue: 1, alpha: 1)
        return [delete, Do]
    }
    
    func notification(title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

