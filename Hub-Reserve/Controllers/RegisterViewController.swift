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
    
    @IBAction func register(_ sender: Any) -> Void{
        if !checkInputRegister(name: nameTextField.text ?? "", lastname: lastNameTextField.text ?? "", email: emailTextField.text ?? "", password1: passwordTextField1.text ?? "", password2: passwordTextField2.text ?? "", switchOn: mySwitch){
            return
        }
        doRegister {
        }
    }
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    
    @IBAction func ToS(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://market.tec.mx/terminos-y-condiciones")! as URL, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getOrganization(email: String) -> String{
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
    
    func checkPassword(password: String) -> Bool {
        //ASCII values: a(97) - z(122)
        //ASCII values: A(65) - Z(90)
        //ASCII values: 0(48) - 9(57)
        
        var flagCapLetter = false
        var flagLowLetter = false
        var flagNum = false
        var flagSymbol = false
        
        if password.count < 8{
            return false
        }
        for p in password{
            let ascii = p.asciiValue
            if ascii ?? 0 >= 65, ascii ?? 0 <= 90{
                flagCapLetter = true
            }
            else if ascii ?? 0 >= 48, ascii ?? 0 <= 57{
                flagNum = true
            }
            else if ascii ?? 0 >= 97, ascii ?? 0 <= 122{
                flagLowLetter = true
            }
            else{
                flagSymbol = true
            }
        }
        if flagNum, flagSymbol, flagLowLetter, flagCapLetter{
            return true
        }
        return false
    }
     
    
    
    func checkInputRegister(name: String, lastname: String, email: String, password1: String, password2: String, switchOn: UISwitch) -> Bool{
        if name.isEmpty || lastname.isEmpty || email.isEmpty || password1.isEmpty || password2.isEmpty{
            showAlertEmptyTextFields()
            return false
        }
        if password1 != password2{
            showAlertWrongPasswords()
            return false
        }
        if !switchOn.isOn{
            showAlertSwitch()
            return false
        }
        var flag = false
        for e in email{
            if e == "@"{
                flag = true
                break
            }
        }
        if !flag{
            showAlertEmail()
            return false
        }
        if !checkPassword(password: password1){
            showAlertInsecurePassword()
            return false
        }
        return true
    }
    
    func doRegister(completion: @escaping () -> Void){
        let organization = getOrganization(email: emailTextField.text ?? "")
        WebService().registerUser(name: nameTextField.text ?? "", lastname: lastNameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField1.text ?? "", organization: organization) { result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    print("LOGIN SUCCESSFUL")
                    self.showAlertRegister()
                    completion()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showBadRegister()
                    print("ERROR")
                    print(error)
                    completion()
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
    
    func showAlertEmptyTextFields(){
        // Create Alert View
        let alertView = UIAlertController(title: "Atención", message: "Hay campos vacíos, favor de llenarlos", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: nil))
        self.present(alertView, animated: false, completion: nil)
    }
    
    func showAlertWrongPasswords(){
        // Create Alert View
        let alertView = UIAlertController(title: "Atención", message: "La verificación de la contraseña es incorrecta", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: nil))
        self.present(alertView, animated: false, completion: nil)
    }
    
    func showAlertEmail(){
        // Create Alert View
        let alertView = UIAlertController(title: "Atención", message: "Favor de verificar su correo electrónico", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: nil))
        self.present(alertView, animated: false, completion: nil)
    }
    
    func showAlertInsecurePassword(){
        // Create Alert View
        let alertView = UIAlertController(title: "Atención", message: "Su contraseña es insegura.\nSe recomienda: \nUsar al menos 1 letra mayúscula\nUsar al menos 1 número \nUsar al menos 1 símbolo\nContraseña con longitud mínimo de 8 caracteres", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: nil))
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
