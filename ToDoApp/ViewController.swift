//
//  ViewController.swift
//  ToDoApp
//
//  Created by Angadjot singh on 19/11/19.
//  Copyright © 2019 Angadjot singh. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,TableViewNew {
    
    @IBOutlet weak var table: UITableView!
    
    var db:Firestore?
    var arr = ["hello","bye"]
    var signal:Int?
    var arrDict = [[String:Any]]()
    var dict = [String:Any]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       retrieveData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDict.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

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
    
    func onClickCell(index: Int) {
        print("button clicked index is",index)
        self.signal = 1
        dict = arrDict[index]
        print("dictionary is",dict)
        self.performSegue(withIdentifier: "addTask", sender: nil)
    }
    
    func onClickSwitch(index: Int) {
        print("switch clicked",index)
        dict = arrDict[index]
        updateTask(docId: (dict["docId"] as? String)!, index: index)
    }
    
    func updateTask(docId:String,index:Int){
            dict = arrDict[index]
            db = Firestore.firestore()
            let para = ["completed":true]
            db?.collection("users").document(docId).updateData(para){
                err in
                if let err = err {
                    print("Error writing document: \(err.localizedDescription)")
                } else {
                    print("Document successfully written!")
                }
            }

    }
    

    func retrieveData(){
        db = Firestore.firestore()
        let uid = self.defaults.string(forKey: "userUid")

        db?.collection("users").whereField("userUid", isEqualTo: uid!).addSnapshotListener({ (snap, err) in
            self.arrDict.removeAll()
            for i in snap!.documents{
//                print(i.)
                self.arrDict.append(i.data())
            }

                self.table.reloadData()
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
    
    
    
    
//    @IBAction func addTask(_ sender: UIBarButtonItem) {
//        self.signal = 0
//        self.performSegue(withIdentifier: "addTask", sender: nil)
//    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addTask"{
//            let vc = segue.destination as? AddTaskViewController
//
//            if signal == 0{
//              vc?.signal = signal
//            }else if signal == 1{
//              vc?.signal = signal
//              vc?.arrDict = dict
//            }
//
//        }
//    }
    
 
    
//    @IBAction func logout(_ sender: UIBarButtonItem) {
//        do{
//            try Auth.auth().signOut()
//            self.defaults.set("", forKey: "userUid")
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let root = storyBoard.instantiateViewController(withIdentifier: "main")
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = root
//        }catch let err{
//            print("error signing out",err.localizedDescription)
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
    
    
}


