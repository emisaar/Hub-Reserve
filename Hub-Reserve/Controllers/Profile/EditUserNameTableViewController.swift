//
//  EditUserNameTableViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 12/10/22.
//

import UIKit

class EditUserNameTableViewController: UITableViewController {

    @IBOutlet weak var update: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {

        let name = nameTextField.text ?? ""
        let lastname = lastnameTextField.text ?? ""

        update.isEnabled = !name.isEmpty && !lastname.isEmpty
    }
    
    @IBAction func updateName(_ sender: Any) {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            print("WRONG TOKEN")
            return
        }
        guard let userId = defaults.string(forKey: "userId") else {
            print("WRONG ID")
            return
        }
        
        Task{
            do{
                try await WebService().changeUserName(name: nameTextField.text!, lastname: lastnameTextField.text!)
                Task{
                    do{
                        let usuario = try await WebService().getUser(token: token, id: userId)
                                            
                    } catch {
                            displayError(NetworkError.noData, title: "Error al cargar nombre de usuario")
                    }
                showAlertChangeNameDone()
                }
            } catch{
                print("error")
            }
        }
        
    }
    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func showAlertChangeNameDone(){
            // Create Alert View
            let alertView = UIAlertController(title: "Datos Actualizados", message: "Sus datos han sido actualizados correctamente.", preferredStyle: .alert)
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
    
    func showError(){
        let alertView = UIAlertController(title: "Error", message: "No se pudieron actualizar sus datos", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Ok", style: .cancel))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func changeScreen(){
        let nextScreen = storyboard! .instantiateViewController(withIdentifier: "main") as! UITabBarController
        nextScreen.modalPresentationStyle = .fullScreen
        self.present(nextScreen, animated: true, completion: nil)
    }
}
