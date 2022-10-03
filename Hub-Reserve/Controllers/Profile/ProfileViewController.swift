//
//  ProfileViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 28/09/22.
//

import UIKit

class ProfileViewController: UIViewController {

//    var user = User
    
    
    @IBAction func deleteAccount(_ sender: Any) {
        showAlertDelete()
    }
    
    @IBAction func logOut(_ sender: Any) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showAlertDelete(){
        // Create Alert View
        let alertView = UIAlertController(title: "Advertencia", message: "¿Seguro que desea eliminar la cuenta? La acción no se puede deshacer", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Cancelar", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.changeScreen()}))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func changeScreen(){
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func unwindToProfileTableView(segue: UIStoryboardSegue) {
//        guard segue.identifier == "saveUnwind",
//            let sourceViewController = segue.source as? EditProfileTableViewController,
//              let edit = sourceViewController.user else { return }

//        if let selectedIndexPath = tableView.indexPathForSelectedRow {
//            user[selectedIndexPath.row] = user
//            tableView.reloadRows(at: [selectedIndexPath], with: .none)
//        } else {
//            let newIndexPath = IndexPath(row: user.count, section: 0)
//            user.append(reserva)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
//    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//}
