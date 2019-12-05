//
//  LoginViewController.swift
//  ToDoApp
//
//  Created by Angadjot singh on 24/11/19.
//  Copyright © 2019 Angadjot singh. All rights reserved.
//// name - Angadjot singh
//Author's name - Angadjot singh
// app name - The ToDo App
//  Student ID - 301060981
// file description  - File for authenticating the users through phone number

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

//    initializing the variables

    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var otp: UITextField!
    @IBOutlet weak var loginOtpButton: UIButton!
    
    var veriId = ""
    let defaults = UserDefaults.standard
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.otp.isHidden = true
        activityIndicator()
    }
    
//    authenticating through phone number
    @IBAction func loginAction(_ sender: UIButton) {
        
        if loginOtpButton.titleLabel?.text == "Login"{
            self.indicator.startAnimating()
            let phoneno = "+1"+phoneNo.text!
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneno, uiDelegate: nil) { (verificationId, err) in
                
                if let err = err{
                    print("error is",err.localizedDescription)
                    self.indicator.stopAnimating()
                }else{
                    print("verificationId",verificationId!)
                    self.otp.isHidden = false
                    self.veriId = verificationId!
                    self.loginOtpButton.setTitle("Otp", for: .normal)
                    self.indicator.stopAnimating()
                }
            }
        }else if loginOtpButton.titleLabel?.text == "Otp"{
            signInWithOtp(verificationId: veriId, verificationCode: self.otp.text!)
        }
    }
    
    
 //    sign function for user
    func signInWithOtp(verificationId:String,verificationCode:String){
        self.indicator.startAnimating()
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error{
                print("error is",error.localizedDescription)
                self.indicator.stopAnimating()
            }else{
                print("user signedIn successfully")
//                print("uid is",authResult?.user.uid)
                self.indicator.stopAnimating()
                self.defaults.set(authResult?.user.uid, forKey: "userUid")
                
                self.performSegue(withIdentifier: "todoList", sender: nil)
            }
        }
    }
    
    @objc func activityIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
        indicator.style = .gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
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
