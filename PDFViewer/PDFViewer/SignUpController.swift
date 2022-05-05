//
//  SignUpController.swift
//  PDFViewer
//
//  Created by Jonathan Ballona Sanchez on 4/22/22.
//

import UIKit
import Parse

class SignUpController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var signUp: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var welcome: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmationTextField.delegate = self
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor,
        ]
        view.layer.addSublayer(gradientLayer)
        
        view.addSubview(nameTextField)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordConfirmationTextField)
        view.addSubview(signUp)
        view.addSubview(welcome)
        view.addSubview(image)
        
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordConfirmationTextField.resignFirstResponder()
        
        
        return true
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
