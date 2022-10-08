//
//  ProfileViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 28/09/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBAction func deleteAccount(_ sender: Any) {
        /*
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            return
        }
        print("TOKEN")
        print(token)
        
        Task{
            do{
                try await WebService().deleteUser(token: token)
                showDeletionCompleted()
                
            } catch {
                displayError(NetworkError.noData, title: "Error: no se pudo eliminar la cuenta")
            }
        }
         */
        //Tenemos que mandar el token a las funciones?
        showAlertDelete()
    }
    
    @IBAction func logOut(_ sender: Any) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlertDelete(){
        let alertView = UIAlertController(title: "Advertencia", message: "¿Seguro que desea eliminar la cuenta? La acción no se puede deshacer", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Cancelar", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.confirmDelete()}))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func confirmDelete(){
        let alertView = UIAlertController(title: "Eliminar Cuenta", message: "Para continuar, ingrese su correo electrónico", preferredStyle: .alert)
        
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
                return
            }
            print("\n\nEMAIL")
            print(email)
            
            //Falta corroborar que la BD y el input coincidan
            self.showDeletionCompleted()
        }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showDeletionCompleted(){
        let alertView = UIAlertController(title: "Cuenta eliminada", message: "Su cuenta ha sido eliminada satisfactoriamente", preferredStyle: .alert)
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
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
