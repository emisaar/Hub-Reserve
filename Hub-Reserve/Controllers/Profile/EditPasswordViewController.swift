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
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func screenTap(_ sender: UITapGestureRecognizer) {
        passwordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        newPasswordConfirmTextField.resignFirstResponder()
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        print("update password")
        let defaults = UserDefaults.standard
        guard let userEmail = defaults.string(forKey: "mail") else {
            print("WRONG MAIL")
            return
        }
        Task{
            do{
                let response = try await WebService().changePassword(email: userEmail, password: passwordTextField.text!)
                if response{
                    showAlertChangePasswordDone()
                }
                else{
                    
                }
                print("Correcto")
            } catch{
                displayError(NetworkError.noData, title: "Error: no se pudo actualizar la contraseña")
            }
        }
    }
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
  
    
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
    
    func showAlertErrorChangePwd(){
        // Create Alert View
        let alertView = UIAlertController(title: "Hubo un error", message: "La contraseña actual no es la correcta.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.changeScreen()}))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func changeScreen(){
        let nextScreen = storyboard! .instantiateViewController(withIdentifier: "main") as! UITabBarController
        nextScreen.modalPresentationStyle = .fullScreen
        self.present(nextScreen, animated: true, completion: nil)
    }
}
