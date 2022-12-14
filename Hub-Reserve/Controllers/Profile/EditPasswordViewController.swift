//
//  EditPasswordViewController.swift
//  Hub-Reserve
//
//  Created by Alfonso Pineda on 09/10/22.
//

//Creo que se puede borrar este archivo

import UIKit

fileprivate var aView : UIView?

class EditPasswordViewController: UIViewController {

    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet var tapScreen: UITapGestureRecognizer!
    @IBOutlet weak var newPasswordConfirmTextField: UITextField!
    
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
        
        if newPasswordTextField.text != newPasswordConfirmTextField.text {
            showIncorrectNewPassword()
        }
        
        if !checkPassword(password: newPasswordTextField.text ?? ""){
            showAlertInsecurePassword()
        }
        
        showSpinner()
        Task{
            do{
                let response = try await WebService().boolCheckPassword(email: userEmail, password: passwordTextField.text!)
                if response{
                    Task{
                        do{
                            let response2 = try await WebService().changePassword(email: userEmail, password: newPasswordTextField.text!)
                            if response2{
                                removeSpinner()
                                showAlertChangePasswordDone()
                            }
                            else{
                                removeSpinner()
                                showAlertError()
                            }
                        } catch{
                            removeSpinner()
                            displayError(NetworkError.noData, title: "Error: no se pudo actualizar la contrase??a")
                        }
                    }
                }
                else{
                    removeSpinner()
                    showAlertErrorChangePwd()
                }
                print("Correcto")
            } catch{
                removeSpinner()
                displayError(NetworkError.noData, title: "Error: no se pudo actualizar la contrase??a")
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
    

    func showAlertChangePasswordDone(){
        // Create Alert View
        let alertView = UIAlertController(title: "Contrase??a Actualizada", message: "Su contrase??a ha sido actualizada correctamente.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.changeScreen()}))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showAlertErrorChangePwd(){
        // Create Alert View
        let alertView = UIAlertController(title: "Hubo un error", message: "La contrase??a actual no es la correcta.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showAlertError(){
        // Create Alert View
        let alertView = UIAlertController(title: "Hubo un error", message: "La contrase??a no se pudo actualizar.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showIncorrectNewPassword(){
        // Create Alert View
        let alertView = UIAlertController(title: "Hubo un error", message: "La nueva contrase??a no coincide con la verifiacic??n.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showAlertInsecurePassword(){
        // Create Alert View
        let alertView = UIAlertController(title: "Atenci??n", message: "Su nueva contrase??a es insegura.\nSe recomienda: \nUsar al menos 1 letra may??scula\nUsar al menos 1 n??mero \nUsar al menos 1 s??mbolo\nContrase??a con longitud m??nimo de 8 caracteres", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: nil))
        self.present(alertView, animated: false, completion: nil)
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
