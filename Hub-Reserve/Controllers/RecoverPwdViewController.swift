//
//  RecoverPwdViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 18/09/22.
//

import UIKit

class RecoverPwdViewController: UIViewController {

    @IBAction func sendMail(_ sender: Any) {
        showAlertMailValidation()
    }
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showAlertMailValidation(){
        // Create Alert View
        let alertView = UIAlertController(title: "Constraseña actualizada", message: "Su contraseña ha sido actualizada correctamente.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.changeScreen()}))
        self.present(alertView, animated: true, completion: nil)
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
