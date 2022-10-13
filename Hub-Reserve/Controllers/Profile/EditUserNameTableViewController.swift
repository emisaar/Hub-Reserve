//
//  EditProfileViewController.swift
//  Hub-Reserve
//
//  Created by Alfonso Pineda on 09/10/22.
//

import UIKit

class EditUserNameTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var saveUserName: UIButton!
    
    var name = ""
    
    @IBAction func textFieldDoneEditing(sender:UITextField) {
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateSaveButtonState()
        
        if saveUserName.isEnabled {
            print("Pressed")
            
            Task{
                do{
                    try await WebService().changeUserName(name: nameTextField.text!, lastname: lastNameTextField.text!)
                    showAlertChangeNameDone()
                } catch{
                    print("error")
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func screenTap(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    

    func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        saveUserName.isEnabled = !name.isEmpty && !lastName.isEmpty
    }

    func showAlertChangeNameDone(){
        // Create Alert View
        let alertView = UIAlertController(title: "Contraseña Actualizada", message: "Su contraseña ha sido actualizada correctamente.", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.changeScreen()}))
        self.present(alertView, animated: true, completion: nil)
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
