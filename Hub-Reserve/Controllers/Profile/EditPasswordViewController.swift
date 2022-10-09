//
//  EditPasswordViewController.swift
//  Hub-Reserve
//
//  Created by Alfonso Pineda on 09/10/22.
//

import UIKit

class EditPasswordViewController: UIViewController {

    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet var tapScreen: UITapGestureRecognizer!
    @IBOutlet weak var newPasswordConfirmTextField: UITextField!
    
    var password = ""
    var newPassword = ""
    var newPasswordConfirm = ""
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.text = password
        newPasswordTextField.text = newPassword
        newPasswordConfirmTextField.text = newPasswordConfirm

        updateSaveButtonState()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func screenTap(_ sender: UITapGestureRecognizer) {
        passwordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        newPasswordConfirmTextField.resignFirstResponder()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
  
    
    func updateSaveButtonState() {

        let password = passwordTextField.text ?? ""
        let newPassword = newPasswordTextField.text ?? ""
        let newPasswordConfirm = newPasswordConfirmTextField.text ?? ""

        update.isEnabled = !password.isEmpty && !newPassword.isEmpty && !newPasswordConfirm.isEmpty
    }

    func showAlertChangePasswordDone(){
        // Create Alert View
        let alertView = UIAlertController(title: "Contraseña Actualizada", message: "Su contraseña ha sido actualizada correctamente.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.changeScreen()}))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func changeScreen(){
        let nextScreen = storyboard! .instantiateViewController(withIdentifier: "main") as! UITabBarController
        nextScreen.modalPresentationStyle = .fullScreen
        self.present(nextScreen, animated: true, completion: nil)
    }
}
