//
//  LogInViewController.swift
//  Roll Thru
//
//  Created by Max Tanous on 9/6/18.
//  Copyright © 2018 Max Tanous. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func attemptLogIn(_ sender: UIButton) {
        
        let parameters =
            ["email": emailField.text!,
            "password": passwordField.text!]
        
        Alamofire.request("http://localhost:3000/user/login.JSON", method: .post, parameters: parameters).responseJSON
            { (responseData) -> Void in
                let apiResponse = JSON(responseData.result.value!)
                if apiResponse["status"].int != 200{
                    self.errorLabel.text = apiResponse["message"].string
                    self.errorLabel.textColor = UIColor.red
                }
                else {
                    let authToken = apiResponse["auth_token"].string
                    self.saveUserLoggedInFlag()
                    self.saveApiToken(token: authToken!)
                    self.performSegue(withIdentifier: "logInSuccessful", sender: nil)
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
