//
//  ProfileViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 28/09/22.
//

import UIKit

fileprivate var aView : UIView?

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBAction func deleteAccount(_ sender: Any) {
        showAlertDelete()
    }
    
    @IBAction func logOut(_ sender: Any) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        guard let username = defaults.string(forKey: "username") else {
            return
        }
        guard let lastname = defaults.string(forKey: "lastname") else {
            return
        }
        
        userName.text = "\(username) \(lastname)"
    }
    
    func updateUI(with usuario: User){
        DispatchQueue.main.async {
            self.userName.text = usuario.name
        }
    }
    
    func showAlertDelete(){
        let alertView = UIAlertController(title: "Advertencia", message: "¿Seguro que desea eliminar la cuenta? La acción no se puede deshacer", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Cancelar", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.confirmDelete()}))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func confirmDelete(){
        let alertView = UIAlertController(title: "Eliminar Cuenta", message: "Para continuar, ingrese su correo electrónico", preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title:"Cancelar", style: .cancel, handler: nil))
        
        alertView.addTextField { field in
            field.placeholder = "Correo"
            field.returnKeyType = .done
            field.keyboardType = .emailAddress
        }
        
        alertView.addAction(UIAlertAction(title: "Eliminar", style: .default, handler: { _ in
            guard let fields = alertView.textFields, fields.count == 1 else {
                return
            }
            let emailField = fields[0]
            guard let email = emailField.text, !email.isEmpty else {
                print("Invalid entry")
                self.showAlertIncorrectEmail()
                return
            }
            
            let defaults = UserDefaults.standard
            guard let token = defaults.string(forKey: "jwt") else {
                print("WRONG TOKEN")
                return
            }
            print("TOKEN")
            print(token)
            
            guard let userEmail = defaults.string(forKey: "mail") else {
                print("WRONG MAIL")
                return
            }
            print("MAIL")
            print(userEmail)
            
            guard let userId = defaults.string(forKey: "userId") else {
                print("WRONG ID")
                return
            }
            print("ID")
            print(userId)
            
            //Falta corroborar que la BD y el input coincidan
            //If error - self.showAlertIncorrectEmail()
            
            if (email != userEmail){
                self.showAlertIncorrectEmail()
                return
            }
            
            self.showSpinner()
            Task{
                do{
                    try await WebService().deleteUser(token: token)
                    self.removeSpinner()
                    self.showDeletionCompleted()
                } catch {
                    self.removeSpinner()
                    self.displayError(NetworkError.noData, title: "Error: no se pudo eliminar la cuenta")
                }
            }
        }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showDeletionCompleted(){
        let alertView = UIAlertController(title: "Cuenta eliminada", message: "Su cuenta ha sido eliminada satisfactoriamente", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.changeScreen()}))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showAlertIncorrectEmail(){
        let alertView = UIAlertController(title: "Hubo un error", message: "Su correo electrónico no fue introducido correctamente", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Ok", style: .cancel, handler: nil))
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
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
