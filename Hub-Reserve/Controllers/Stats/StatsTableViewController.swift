//
//  StatsTableViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 27/09/22.
//

import UIKit

fileprivate var aView : UIView?

class StatsTableViewController: UITableViewController {

    var stats = Statistics()
    
    @IBOutlet weak var hardwareStatsLabel: UILabel!
    @IBOutlet weak var SoftwareStatsLabel: UILabel!
    @IBOutlet weak var roomStatsLabel: UILabel!
    @IBOutlet weak var timeStatsLabel: UILabel!
    @IBOutlet weak var mostUsedLabel: UILabel!
    
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            return
        }
        
        Task{
            do{
                showSpinner()
                let stats = try await WebService().getStats(token: token)
                
                guard let hardware = defaults.string(forKey: "last_hardware") else {
                    return
                }
                
                guard let software = defaults.string(forKey: "last_software") else {
                    return
                }
                
                guard let room = defaults.string(forKey: "last_room") else {
                    return
                }
                
                guard let timeUsed = defaults.string(forKey: "total_time") else {
                    return
                }
                
                guard let mostUsed = defaults.string(forKey: "most_used") else {
                    return
                }
                
                hardwareStatsLabel.text = hardware
                SoftwareStatsLabel.text = software
                roomStatsLabel.text = room
                timeStatsLabel.text = timeUsed
                mostUsedLabel.text = mostUsed
                
                self.removeSpinner()
                print("STATS")
            } catch {
                self.removeSpinner()
                self.displayError(NetworkError.noData, title: "Error al cargar nombre de usuario")
            }
        }
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return stats.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatsTableViewCell
//
//        // Configure the cell...
//        let index = indexPath.row
//        let stat = stats[index]
//        cell.update(s: stat)
//
//        return cell
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
        // Pass the selected object to the new view controller.
    }
    */

}
