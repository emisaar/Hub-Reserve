//
//  RoomsTableViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 22/09/22.
//

import UIKit

fileprivate var aView : UIView?

class HardwaresTableViewController: UITableViewController {
    /*
     Resource type id : int
     
     var rooms =
     */
    //var rooms = Room.roomList()
    let defaults = UserDefaults.standard
//    var roomsControlador = WebService().resources(jwt: "ERGERGJANEFW")
//    { result in
//        switch result{
//        case .success(let resourceName):
//           print(resourceName)
//        case .failure(let error):
//            print(error)
//        }
//    }
    
    var recursos = Resources()
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
                let recursos = try await WebService().getResources(token: token)
                
                var hardware = [Resource]()
                
                for r in recursos {
                    if r.category == "Hardware" {
                        hardware.append(r)
                    }
                }
                
                updateUI(with: hardware)
                removeSpinner()
            }catch{
                removeSpinner()
                displayError(NetworkError.noData, title: "No se pudo acceder a las reservas")
            }
        }
    }
    
    func updateUI(with recursos: Resources){
        DispatchQueue.main.async {
            
            self.recursos = recursos
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
    // MARK: - Table view data source

    /*PASO 0 crear método unwindToEmojiTableView para cerrar la vista de la tabla estática
     Luego de la definición se deben crear los segues de tipo unwind, es decir, segues hacia el proxy EXIT*/
    
    /* UNCOMMENT FOR EDITABLE TABLES
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? EditReservationsTableViewController,
              let reserva = sourceViewController.reserva else { return }

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            reservations[selectedIndexPath.row] = reserva
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: reservations.count, section: 0)
            reservations.append(reserva)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    /*
     leer esta nota
     With prepare(for:sender:), UIKit creates the view controller and passes the instance to the starting point view controller’s prepare(for:sender:) for configuration. With an IBSegueAction, you create the view controller fully configured and pass it to UIKit for display
     */
    
    // CONNECT DIRECTLY, DO NOT COPY IT
    @IBSegueAction func editReserva(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> EditReservationsTableViewController? {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            // Editing Emoji
            let reservaToEdit = reservations[indexPath.row]
            return EditReservationsTableViewController(coder: coder, r: reservaToEdit)
        } else {
            // Adding Emoji
            return EditReservationsTableViewController(coder: coder, r: nil)
        }
    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
            tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedReservation = reservations.remove(at: fromIndexPath.row)
        reservations.insert(movedReservation, at: to.row)
    }
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return rooms.count
        return recursos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HardwareTableViewCell

        // Configure the cell...
        let index = indexPath.row
        //let resource = rooms[index]
        let resource = recursos[index]
        cell.update(r: resource)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //cellLabel = rooms[indexPath.row].name
        cellLabel = recursos[indexPath.row].name
        cellID = recursos[indexPath.row].id

//        performSegue(withIdentifier: "Reservar", sender: nil)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "Reservar") as? ReserveViewController
        vc?.resourceText = cellLabel
        vc?.idResourceText = cellID
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    
    /* UNCOMMENT FOR EDITABLE TABLES
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertView = UIAlertController(title: "Advertencia", message: "¿Seguro que desea eliminar la reservación? La acción no se puede deshacer", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title:"Cancelar", style: .cancel, handler: nil))
            alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {_ in
                // Delete the row from the data source
                self.reservations.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            self.present(alertView, animated: true, completion: nil)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
  */
    
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            reservations.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "Reservar"{
            // Pass the selected object to the new view controller.
            let nextScreen = segue.destination as! ReserveViewController

            nextScreen.resourceText = cellLabel
        }
    }
    */
}
