//
//  EditReservationsTableViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 02/10/22.
//

import UIKit

class EditReservationsTableViewController: UITableViewController {

//    var reserva:Reservation?
    var reserva: Reserva?
    
    var idReserva = 0
    var resourceName = ""
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nombreTextField: UITextField!
    
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var comentariosTextField: UITextField!
    @IBOutlet weak var descripcionTextField: UITextField!
    
//    @IBOutlet weak var resourceIDTextField: UITextField!
//    @IBOutlet weak var statusTextField: UITextField!
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    init?(coder: NSCoder, r: Reserva?) {
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
        let comments = comentariosTextField.text ?? ""
        let description = descripcionTextField.text ?? ""
//        let resourceID = resourceIDTextField.text ?? ""
//        let status = statusTextField.text ?? ""
        saveButton.isEnabled = !startDate.isEmpty && !endDate.isEmpty && !comments.isEmpty && !description.isEmpty
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
    
//    func createInitialDatePicker() {
//        startDatePicker.preferredDatePickerStyle = .wheels
////        InitialDatePicker.datePickerMode = .date
//        startDatePicker.date =
//
//        startDate.textAlignment = .center
//        startDate.inputView = startDatePicker
//        startDate.inputAccessoryView = createToolbarInitialDate()
//
//    }
    
//    func createEndDatePicker() {
//        endDatePicker.preferredDatePickerStyle = .wheels
////        endDatePicker.datePickerMode = .date
//
//        endDate.textAlignment = .center
//        endDate.inputView = endDatePicker
//        endDate.inputAccessoryView = createToolbarEndDate()
//    }
    
    @objc func donePressedInitialDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//        dateFormatter.timeStyle = .short
        
        self.startDate.text = dateFormatter.string(from: startDatePicker.date)
        self.view.endEditing(true)

    }
    
    @objc func donePressedEndDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//        dateFormatter.timeStyle = .short
        
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
            nombreTextField.text = reserva.resource_name

            let isoDate1 = reserva.start
            let isoDate2 = reserva.finish
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let dateStart = dateFormatter.date(from:isoDate1)!
            
            let dateFinish = dateFormatter.date(from:isoDate2)!
        
            let dateSFormatter = DateFormatter()
            dateSFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    //        dateFormatter.timeStyle = .short
            
            startDate.text = dateSFormatter.string(from: dateStart)
            
//            startDate.text = reserva.start
            // CREATE INITIAL DATE PICKER
//            createInitialDatePicker()
            startDatePicker.preferredDatePickerStyle = .wheels
            startDatePicker.date = dateStart
            
            startDate.textAlignment = .center
            startDate.inputView = startDatePicker
            startDate.inputAccessoryView = createToolbarInitialDate()
            
            endDate.text = dateSFormatter.string(from: dateFinish)
            // CREATE END DATE PICKER
//            createEndDatePicker()
            endDatePicker.preferredDatePickerStyle = .wheels
            endDatePicker.date = dateFinish
            
            endDate.textAlignment = .center
            endDate.inputView = endDatePicker
            endDate.inputAccessoryView = createToolbarEndDate()
            
            comentariosTextField.text = reserva.comments
            
            descripcionTextField.text = reserva.description
           
            idReserva = reserva.id
            resourceName = reserva.resource_name
            
//            resourceIDTextField.text = String(reserva.resourceID)

//            statusTextField.text = String(reserva.status)
            
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
    
    func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard segue.identifier == "saveUnwind" else { return }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
        
//        let nombre = nombreTextField.text ?? ""
        let startDate = startDate.text ?? ""
        let endDate = endDate.text ?? ""
        let comments = comentariosTextField.text ?? ""
        let description = descripcionTextField.text ?? ""

        let isoDate1 = startDate
        let isoDate2 = endDate

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

        let dateStart = dateFormatter.date(from:isoDate1)!

        let dateFinish = dateFormatter.date(from:isoDate2)!

        let dateSFormatter = DateFormatter()
        dateSFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateSFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        
//        let resourceID = resourceIDTextField.text ?? ""

//        let status = statusTextField.text ?? ""
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            return
        }
        
        guard let userId = defaults.string(forKey: "userId") else {
            print("WRONG ID")
            return
        }
        print("ID")
        print(userId)
        
        print("TOKEN")
        print(token)
        
        Task{
            do{
                let recursos = try await WebService().editReserva(id: String(idReserva), token: token, start: startDate, finish: endDate, description: description, comments: comments)
            }catch{
                displayError(NetworkError.noData, title: "No se pudo editar el recurso")
            }
        }
        
        reserva = Reserva(resource_id: idReserva, resource_name: resourceName, start: dateSFormatter.string(from: dateStart), finish: dateSFormatter.string(from: dateFinish), comments: comments, description: description)
//        reserva = Reservation(name: nombre, startDate: startDate, endDate: endDate, resourceID: Int(resourceID)!, status: Int(status)!)
    }
}
