//
//  EditReservationsTableViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 02/10/22.
//

import UIKit

class EditReservationsTableViewController: UITableViewController {

    var reserva:Reservation?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nombreTextField: UITextField!
//    @IBOutlet weak var startDatePicker: UIDatePicker!
//    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    @IBOutlet weak var resourceIDTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    init?(coder: NSCoder, r: Reservation?) {
        self.reserva = r
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSaveButtonState() {
        let nombre = nombreTextField.text ?? ""

        let startDate = startDate.text ?? ""
        
        let endDate = endDate.text ?? ""
        
        let resourceID = resourceIDTextField.text ?? ""

        let status = statusTextField.text ?? ""
        saveButton.isEnabled = !nombre.isEmpty && !startDate.isEmpty && !endDate.isEmpty && !resourceID.isEmpty && !status.isEmpty
    }
    
    
    func createToolbarInitialDate() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedInitialDate))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    func createToolbarEndDate() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEndDate))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    func createInitialDatePicker() {
        startDatePicker.preferredDatePickerStyle = .wheels
//        InitialDatePicker.datePickerMode = .date
        
        startDate.textAlignment = .center
        startDate.inputView = startDatePicker
        startDate.inputAccessoryView = createToolbarInitialDate()
    }
    
    func createEndDatePicker() {
        endDatePicker.preferredDatePickerStyle = .wheels
//        endDatePicker.datePickerMode = .date
        
        endDate.textAlignment = .center
        endDate.inputView = endDatePicker
        endDate.inputAccessoryView = createToolbarEndDate()
    }
    
    @objc func donePressedInitialDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        self.startDate.text = dateFormatter.string(from: startDatePicker.date)
        self.view.endEditing(true)

    }
    
    @objc func donePressedEndDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        self.endDate.text = dateFormatter.string(from: endDatePicker.date)
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let reserva = reserva {
            nombreTextField.text = reserva.name
            
            startDate.text = reserva.startDate
            
            endDate.text = reserva.endDate
            
            createInitialDatePicker()
            createEndDatePicker()
           
            resourceIDTextField.text = String(reserva.resourceID)

            statusTextField.text = String(reserva.status)
            
            title = "Editar reserva"
        }
        else{
            title = "Insertar reserva"
        }
        //paso 3 invocar la función updateSaveButtonState()
        updateSaveButtonState()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard segue.identifier == "saveUnwind" else { return }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
        
        let nombre = nombreTextField.text ?? ""

        let startDate = startDate.text ?? ""
        
        let endDate = endDate.text ?? ""
        
        
        let resourceID = resourceIDTextField.text ?? ""

        let status = statusTextField.text ?? ""
        
        
        reserva = Reservation(name: nombre, startDate: startDate, endDate: endDate, resourceID: Int(resourceID)!, status: Int(status)!)
    }
}
