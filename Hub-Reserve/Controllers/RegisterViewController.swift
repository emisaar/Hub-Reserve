//
//  RegisterViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 18/09/22.
//

import UIKit

fileprivate var aView : UIView?

class RegisterViewController: UIViewController {

    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField1: UITextField!
    @IBOutlet weak var passwordTextField2: UITextField!
    
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
    
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
    
    
    @IBAction func screenTap(_ sender: Any) {
        nameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField1.resignFirstResponder()
        passwordTextField2.resignFirstResponder()
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
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPwd(password: String) -> Bool {
        let pwdRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
        let pwdPred = NSPredicate(format:"SELF MATCHES %@", pwdRegEx)
        return pwdPred.evaluate(with: password)
    }
    
    func isValidName(name: String) -> Bool {
        //ASCII values: 0(48) - 9(57)
        for n in name{
            let ascii = n.asciiValue
            if ascii ?? 0 >= 48, ascii ?? 0 <= 57{
                return false
            }
        }
        return true
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
        if !isValidPwd(password: password1){
            showAlertInsecurePassword()
            return false
        }
        if !isValidEmail(email: email){
            showAlertEmail()
            return false
        }
        if !isValidName(name: name){
            showAlertName()
            return false
        }
        if !isValidName(name: lastname){
            showAlertName()
            return false
        }
        return true
    }
    
    func doRegister(completion: @escaping () -> Void){
        showSpinner()
        let organization = getOrganization(email: emailTextField.text ?? "")
        WebService().registerUser(name: nameTextField.text ?? "", lastname: lastNameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField1.text ?? "", organization: organization) { result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                    print("LOGIN SUCCESSFUL")
                    self.removeSpinner()
                    self.showAlertRegister()
                    completion()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.removeSpinner()
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
    
    func showAlertName(){
        // Create Alert View
        let alertView = UIAlertController(title: "Atención", message: "Verifique su nombre", preferredStyle: .alert)
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
