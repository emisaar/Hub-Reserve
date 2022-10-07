//
//  RegisterViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 18/09/22.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField1: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    
    @IBAction func register(_ sender: Any) {
        doRegister {
            if self.mySwitch.isOn {
                self.showAlertRegister()
            } else {
                self.showAlertSwitch()
            }
        }
    }
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getOrganization(email: String) -> String{
        var email = email
        var organization = ""
        
        var flag = false
        
        for e in email{
            if e == "@"{
                flag = true
            }
            else if flag{
                organization += String(e)
            }
        }
        return organization
    }
    
    func doRegister(completion: @escaping () -> Void){
        let organization = getOrganization(email: emailTextField.text ?? "")
        WebService().registerUser(name: nameTextField.text ?? "", lastname: lastNameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField1.text ?? "", organization: organization) { result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    print("LOGIN SUCCESSFUL")
                    completion()
                }
                
                //Pasa automaticamente a este caso, hay que debuggear
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showBadRegister()
                    completion()
                    print(error)
                }
            }
        }
    }
    
    func showBadRegister(){
        let alertView = UIAlertController(title: "Error", message: "Hubo un problema en su registro", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Reintentar", style: .cancel))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showAlertRegister(){
        // Create Alert View
        let alertView = UIAlertController(title: "Aviso", message: "Hemos enviado un mensaje al correo electrónico proporcionado. Seguir los pasos para activar la cuenta", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.changeScreen()}))
        self.present(alertView, animated: false, completion: nil)
    }
    
    func showAlertSwitch(){
        // Create Alert View
        let alertView = UIAlertController(title: "Atención", message: "Para continuar, debe aceptar los Términos de Servicio y Políticas de Seguridad", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: nil))
        self.present(alertView, animated: false, completion: nil)
    }
    
    func changeScreen(){
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
