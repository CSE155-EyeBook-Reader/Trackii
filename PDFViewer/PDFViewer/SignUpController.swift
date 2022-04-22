//
//  SignUpController.swift
//  PDFViewer
//
//  Created by Jonathan Ballona Sanchez on 4/22/22.
//

import UIKit
import Parse

class SignUpController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func onSignUp(_ sender: Any) {
        if passwordTextField.text == passwordConfirmationTextField.text {
            let user = PFUser()
            user["name"] = nameTextField.text
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            
            
            user.signUpInBackground { (success, error) in
                if success {
                    self.performSegue(withIdentifier: "signUpSegue", sender: nil)
                } else {
                    print("Error: \(error?.localizedDescription)")
                }
                
            }
        }else{
            print("Error: passwords not match")
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
