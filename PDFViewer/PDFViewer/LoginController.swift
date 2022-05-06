//
//  LoginController.swift
//  PDFViewer
//
//  Created by Jonathan Ballona Sanchez on 4/22/22.
//

import UIKit
import Parse

class LoginController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    @IBOutlet weak var quote: UILabel!
    
    @IBOutlet weak var newAccount: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemTeal.cgColor,
        ]
        view.layer.addSublayer(gradientLayer)
        
        //usernameTextField.tintColor = UIColor.systemBrown
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signIn)
        view.addSubview(signUp)
        view.addSubview(bannerImage)
        view.addSubview(userIcon)
        view.addSubview(passwordIcon)
        view.addSubview(quote)
        view.addSubview(newAccount)

        // Do any additional setup after loading the view.
    }
    //reference 8
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        
        PFUser.logInWithUsername(inBackground: username, password: password) {
            (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }

    //view.addSubview(onSignIn(_ sender: Any))
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
