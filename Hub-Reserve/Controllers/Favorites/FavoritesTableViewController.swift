//
//  FavoritesViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 01/10/22.
//

import UIKit

fileprivate var aView : UIView?

class FavoritesTableViewController: UITableViewController {

    //    var reservations = Reservation.reservationList()
        var favorites = Favorites()
        var cellLabel = ""
        var cellID = 0
    
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
        guard let token = defaults.string(forKey: "jwt") else {
            return
        }
        
        print("TOKEN")
        print(token)
        showSpinner()
        Task{
            do{
                let favoritos = try await WebService().getFavorites(token: token)
                
                updateUI(with: favoritos)
                removeSpinner()
            }catch{
                removeSpinner()
                displayError(NetworkError.noData, title: "No se pudo acceder a las reservas")
            }
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func updateUI(with favoritos: Favorites){
        DispatchQueue.main.async {
            
            self.favorites = favoritos
            self.tableView.reloadData()
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
            tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedReservation = favorites.remove(at: fromIndexPath.row)
        favorites.insert(movedReservation, at: to.row)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavTableViewCell

        // Configure the cell...
        let index = indexPath.row
        let resource = favorites[index]
        cell.update(r: resource)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//                let defaults = UserDefaults.standard
//                guard let token = defaults.string(forKey: "jwt") else {
//                    return
//                }
            
            if editingStyle == .delete {
                let alertView = UIAlertController(title: "Advertencia", message: "¿Seguro que desea eliminar este recurso de favoritos?", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title:"Cancelar", style: .cancel, handler: nil))
                alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {_ in
                    // Delete the row from the data source
                    Task{
                        do{
                            print("INDEX PATH")
                            print(indexPath.row)
                            
                            if (indexPath.row == 0){
                                let idFav = self.favorites[0].id
                                print("ID RESERVA")
                                print(idFav)
                                try await WebService().deleteFavorites(id: idFav)
                            }
                            else {
                                let idFav = self.favorites[indexPath.row - 1].id
                                print("ID RESERVA")
                                print(idFav)
                                try await WebService().deleteFavorites(id: idFav)
                            }
                            // self.updateUI()
                        }catch{
                            self.displayError(NetworkError.noData, title: "No se puede eliminar")
                        }
                    }
                    if (indexPath.row == 0){
                        self.favorites.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    else{
                        self.favorites.remove(at: indexPath.row - 1)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }))
                self.present(alertView, animated: true, completion: nil)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        


    }
