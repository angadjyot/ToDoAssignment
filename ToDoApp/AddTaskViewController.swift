//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Angadjot singh on 20/11/19.
//  Copyright © 2019 Angadjot singh. All rights reserved.
//

import UIKit
import FirebaseFirestore


class AddTaskViewController: UIViewController {


    @IBOutlet weak var toDoName: UITextView!
    @IBOutlet weak var descriptionText: UITextView!

    @IBOutlet weak var addUpdateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    var signal:Int?
    var db:Firestore?
    let defaults = UserDefaults.standard
    var arrDict = [String:Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white

//        print("signal is",signal!)



        toDoName.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        toDoName.layer.borderWidth = 1.0
        toDoName.layer.cornerRadius = 5


        descriptionText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descriptionText.layer.borderWidth = 1.0
        descriptionText.layer.cornerRadius = 5


        self.addUpdateButton.layer.cornerRadius = 10.0
        self.addUpdateButton.layer.masksToBounds = true

        self.deleteButton.layer.cornerRadius = 10.0
        self.deleteButton.layer.masksToBounds = true

        self.cancelButton.layer.cornerRadius = 10.0
        self.cancelButton.layer.masksToBounds = true


        if signal == 0{
            self.addUpdateButton.setTitle("Add", for: .normal)
            self.cancelButton.isHidden = true
            self.cancelButton.isEnabled = false

            self.deleteButton.isHidden = true
            self.deleteButton.isEnabled = false

        }else{
            self.addUpdateButton.setTitle("Update", for: .normal)
            print("arrDict",arrDict)

            self.toDoName.text = arrDict["name"] as? String
            self.descriptionText.text = arrDict["notes"] as? String
        }

    }



    @IBAction func addUpdateAction(_ sender: UIButton) {

        if addUpdateButton.titleLabel?.text == "Add"{
            addData()
        }else if addUpdateButton.titleLabel?.text == "Update"{
            updateData()
        }

    }


    func updateData(){
        db = Firestore.firestore()
        let uid = self.defaults.string(forKey: "userUid")

        let parameters = ["name":toDoName.text!,"notes":descriptionText.text!,"userUid":uid!,"docId":arrDict["docId"]!,"completed":false]

        db?.collection("users").document((arrDict["docId"] as? String)!).updateData(parameters as [String : Any]){
            err in
            if let error = err{
                print(error.localizedDescription)
            }else{
                print("document added successfully")
            }

        }
    }


    func addData(){
        db = Firestore.firestore()
        let uid = self.defaults.string(forKey: "userUid")


        let docId = db?.collection("users").document().documentID

        let parameters = ["name":toDoName.text!,"notes":descriptionText.text!,"userUid":uid!,"docId":docId!,"completed":false] as [String : Any]

        db?.collection("users").document(docId!).setData(parameters as [String : Any]){
            err in
            if let error = err{
                print(error.localizedDescription)
            }else{
                print("document added successfully")
            }

        }
    }



    @IBAction func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }



    @IBAction func deleteAction(_ sender: UIButton) {
        db = Firestore.firestore()
        db?.collection("users").document((arrDict["docId"] as? String)!).delete(){
            err in
            if let error = err{
                print(error.localizedDescription)
            }else{
                print("document deleted successfully")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
