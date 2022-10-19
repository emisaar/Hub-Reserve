//
//  RecoverPwdViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 18/09/22.
//

import UIKit

fileprivate var aView : UIView?

class RecoverPwdViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func sendMail(_ sender: Any) -> Void{
        let email = emailTextField.text!
        if !isValidEmail(email: email){
            showBadEmail()
            return
        }
        showSpinner()
        Task{
            do{
                try await WebService().RecoveryPWD(email: email)
                removeSpinner()
                showAlertMailValidation()
            }catch{
                removeSpinner()
                displayError(NetworkError.noData, title: "Error: No se pudo enviar el correo")
            }
        }
    }
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showBadEmail(){
        let alertView = UIAlertController(title: "Error", message: "Favor de verificar el correo", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Reintentar", style: .cancel))
        self.present(alertView, animated: true, completion: nil)
    }
    
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
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showAlertMailValidation(){
        // Create Alert View
        let alertView = UIAlertController(title: "Aviso", message: "Hemos enviado un correo electrónico para restablecer su contraseña.", preferredStyle: .alert)
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
