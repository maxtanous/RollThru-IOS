//
//  SignUpViewController.swift
//  Roll Thru
//
//  Created by Max Tanous on 9/6/18.
//  Copyright © 2018 Max Tanous. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
   
    
    @IBAction func attemptRegister(_ sender: UIButton) {
        
        let parameters = [ "user": [
            "email": emailField.text!,
            "password": passwordField.text!,
            "passwordConfirmation": passwordConfirmField.text!
        ]]
        if(passwordField.text! != passwordConfirmField.text!){
            self.errorLabel.text = "Passwords must match"
            self.errorLabel.textColor = UIColor.red
            return
        }
        
        Alamofire.request("http://localhost:3000/user/register.JSON", method: .post, parameters: parameters).responseJSON
            { (responseData) -> Void in
            let apiResponse = JSON(responseData.result.value!)
                if apiResponse["status"].int != 200 {
                    print(apiResponse)
                    self.errorLabel.text = apiResponse["errors"].string
                    self.errorLabel.textColor = UIColor.red
            }
                if apiResponse["status"].int == 200{
                    
                    self.errorLabel.text = "Sign up Successful!"
                    self.errorLabel.textColor = UIColor.green
                    let authToken = apiResponse["auth_token"].string
                    self.saveUserLoggedInFlag()
                    self.saveApiToken(token: authToken!)
                    self.performSegue(withIdentifier: "registerSuccess", sender: nil)
                }
            
        }
    }
    
    func saveUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = UserDefaults.standard
        defaults.set("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
    }
    
    func saveApiToken(token:String) {
        let key = token
        let tag = "RollThru-token".data(using: .utf8)!
        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: tag,
                                       kSecValueRef as String: key]
        let status = SecItemAdd(addquery as CFDictionary, nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
