//
//  RegisterViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 18/09/22.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var mySwitch: UISwitch!
    
    @IBAction func register(_ sender: Any) {
        if mySwitch.isOn {
            showAlertRegister()
        } else {
            showAlertSwitch()
        }
    }
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    @IBAction func switchDidChange(_ sender: UISwitch) {
//        if mySwitch.isOn {
//            func registerBtn(_ sender: UIButton) {
//                showAlertRegister()
//            }
//        } else {
//            showAlertSwitch()
//        }
//    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
