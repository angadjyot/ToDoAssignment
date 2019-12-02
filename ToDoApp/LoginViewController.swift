//
//  LoginViewController.swift
//  ToDoApp
//
//  Created by Angadjot singh on 24/11/19.
//  Copyright © 2019 Angadjot singh. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var otp: UITextField!
    @IBOutlet weak var loginOtpButton: UIButton!
    
    var veriId = ""
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.otp.isHidden = true
    }
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        if loginOtpButton.titleLabel?.text == "Login"{
            let phoneno = "+1"+phoneNo.text!
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneno, uiDelegate: nil) { (verificationId, err) in
                
                if let err = err{
                    print("error is",err.localizedDescription)
                }else{
                    print("verificationId",verificationId!)
                    self.otp.isHidden = false
                    self.veriId = verificationId!
                    self.loginOtpButton.setTitle("Otp", for: .normal)
                }
            }
        }else if loginOtpButton.titleLabel?.text == "Otp"{
            signInWithOtp(verificationId: veriId, verificationCode: self.otp.text!)
        }
    }
    
    func signInWithOtp(verificationId:String,verificationCode:String){
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error{
                print("error is",error.localizedDescription)
            }else{
                print("user signedIn successfully")
//                print("uid is",authResult?.user.uid)
                self.defaults.set(authResult?.user.uid, forKey: "userUid")
                self.performSegue(withIdentifier: "todoList", sender: nil)
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
