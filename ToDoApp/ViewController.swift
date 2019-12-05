//
//  ViewController.swift
//  ToDoApp
//
//  Created by Angadjot singh on 19/11/19.
//  Copyright © 2019 Angadjot singh. All rights reserved.
//
// name - Angadjot singh
//Author's name - Angadjot singh
// app name - The ToDo App
//  Student ID - 301060981
// file description  - File for displaying the todo list with edit button and switch to update the status



import UIKit
import FirebaseFirestore
import Firebase

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,TableViewNew {
    
    @IBOutlet weak var table: UITableView!
    
    
//    initializing the variables
    var db:Firestore?
    var arr = ["hello","bye"]
    var signal:Int?
    var arrDict = [[String:Any]]()
    var dict = [String:Any]()
    
    let defaults = UserDefaults.standard
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       retrieveData()
    }
    
//    table view methods
    
//     function for number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDict.count
    }

//     function for height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
//function for setting the data into the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell")! as? TableViewCell)!

        var index = arrDict[indexPath.row]

        cell.toDoLabel.text = index["name"] as? String
        cell.descriptionLabel.text = index["notes"] as? String
        let completed = index["completed"] as? Bool

        if completed == true  {
            cell.switchLabel.isOn = true
            cell.switchLabel.isEnabled = false
            cell.editButtonLabel.isEnabled = false

        }else if completed == false {
            cell.switchLabel.isOn = false
            cell.switchLabel.isEnabled = true
            cell.editButtonLabel.isEnabled = true
        }

        cell.cellDelegate = self
        cell.index = indexPath
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.signal = 1
//        dict = arrDict[indexPath.row]
//        self.performSegue(withIdentifier: "addTask", sender: nil)
    }
    
    
//    function for onclick edit button
    func onClickCell(index: Int) {
        print("button clicked index is",index)
        self.signal = 1
        dict = arrDict[index]
        print("dictionary is",dict)
        self.performSegue(withIdentifier: "addTask", sender: nil)
    }
    
//    function for onclick switch
    func onClickSwitch(index: Int) {
        print("switch clicked",index)
        dict = arrDict[index]
        updateTask(docId: (dict["docId"] as? String)!, index: index)
    }
    
    
//  function for update task
    func updateTask(docId:String,index:Int){
            self.indicator.startAnimating()
            dict = arrDict[index]
            db = Firestore.firestore()
            let para = ["completed":true]
            db?.collection("users").document(docId).updateData(para){
                err in
                if let err = err {
                    print("Error writing document: \(err.localizedDescription)")
                } else {
                    print("Document successfully written!")
                    self.indicator.stopAnimating()
                    let alert = UIAlertController(title: "Message", message: "Status successfully updated", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    })
                    alert.addAction(okay)
                    self.present(alert, animated: true, completion: nil)
                }
            }

    
        
        
    }
//  function for activity indicator
    @objc func activityIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
        indicator.style = .gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
//  function for retrieving data
    func retrieveData(){
        db = Firestore.firestore()
        let uid = self.defaults.string(forKey: "userUid")

        db?.collection("users").whereField("userUid", isEqualTo: uid!).addSnapshotListener({ (snap, err) in
            
            if snap?.documents.count == 0{
                let alert = UIAlertController(title: "Message", message: "No tasks Available", preferredStyle: .alert)
                let okay = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                })
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.arrDict.removeAll()
                for i in snap!.documents{
                    //                print(i.)
                    self.arrDict.append(i.data())
                }
                
                self.table.reloadData()
            }
        })

    }
    
    
//    func setdata(){
//        print("function is working")
//        db = Firestore.firestore()
//        let para = ["name":"angadjot"]
//        print("function chal reha")
//        let x = db?.collection("namesss").document("first")
//
//        x?.setData(para){
//            err in
//            if let err = err {
//                print("Error writing document: \(err.localizedDescription)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
//
//    }
    
    
    
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        self.signal = 0
        self.performSegue(withIdentifier: "addTask", sender: nil)
    }
    
    
//   function for sending data to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTask"{
            let vc = segue.destination as? AddTaskViewController

            if signal == 0{
              vc?.signal = signal
            }else if signal == 1{
              vc?.signal = signal
              vc?.arrDict = dict
            }

        }
    }
    
 
//   function for logout
    @IBAction func logout(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            self.defaults.set("", forKey: "userUid")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let root = storyBoard.instantiateViewController(withIdentifier: "main")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = root
        }catch let err{
            print("error signing out",err.localizedDescription)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}


