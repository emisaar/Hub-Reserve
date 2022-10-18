//
//  RoomsViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 29/09/22.
//

import UIKit

fileprivate var aView : UIView?

class ReserveViewController: UIViewController {
    
    var reservations = Reservation.reservationList()
    
    var dateDB = ""

    @IBOutlet weak var resourceTextField: UITextField!
//    @IBOutlet weak var idResourceTextField: UITextField!
    @IBOutlet weak var InitialDateTextField: UITextField!
    @IBOutlet weak var EndDateTextField: UITextField!
    @IBOutlet weak var comentariosTextField: UITextField!
    @IBOutlet weak var descripcionTextField: UITextField!
    
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
    
    @IBAction func reserveBtn(_ sender: Any) {
//        addReserve()
        let defaults = UserDefaults.standard
        
        guard let token = defaults.string(forKey: "jwt") else {
            return
        }
        
        print("TOKEN")
        print(token)
        
        // Insertar la nueva reserva en el servidor
        showSpinner()
        Task{
            do{
                try await WebService().addReserva(token: token, resource: idResourceText, start: convertTimeCurr2DB(date: InitialDatePicker.date), finish: convertTimeCurr2DB(date: EndDatePicker.date) , description: descripcionTextField.text ?? "", comments: comentariosTextField.text ?? "", id_before_update: 0, changed_by_admin: false, changed_by_user: false)
                // self.updateUI()
                removeSpinner()
                showAlertReservationDone()
                } catch {
                    removeSpinner()
                    displayError(NetworkError.noData, title: "No se puede insertar la reserva")
            }
        }
    }
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var reservar: UIButton!
    
//    let salas = ["Sala 1", "Sala 2", "Sala 3", "Sala 4", "Sala 5"]
    
    var resourceText = ""
    var idResourceText = 0
    
//    var roomsPickerView = UIPickerView()
    
    let InitialDatePicker = UIDatePicker()
    let EndDatePicker = UIDatePicker()
    
    var commentsText = ""
    var descriptionText = ""

    
    @IBAction func textFieldDoneEditing(sender:UITextField){
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        resourceTextField.inputView = roomsPickerView
        resourceTextField.text = resourceText
        resourceTextField.placeholder = "Seleccionar..."
        resourceTextField.textAlignment = .center
//
//        idResourceTextField.text = idResourceText
//        idResourceTextField.placeholder = "Seleccionar..."
//        idResourceTextField.textAlignment = .center
        
        InitialDateTextField.placeholder = "Seleccionar..."
        InitialDateTextField.textAlignment = .center
        
        EndDateTextField.placeholder = "Seleccionar..."
        EndDateTextField.textAlignment = .center
        
//        roomsPickerView.delegate = self
//        roomsPickerView.dataSource = self
        
        createInitialDatePicker()
        createEndDatePicker()
        
        comentariosTextField.text = commentsText
        comentariosTextField.placeholder = "Comentarios..."
        comentariosTextField.textAlignment = .center
        
        descripcionTextField.text = descriptionText
        descripcionTextField.placeholder = "Sobre la reserva..."
        descripcionTextField.textAlignment = .center
        
        
        // Actualizar botón
        updateSaveButtonState()
    }

    func updateSaveButtonState() {
//        let nombre = resourceTextField.text ?? ""

        let startDate = InitialDateTextField.text ?? ""
        
        let endDate = EndDateTextField.text ?? ""
        
        let description = descripcionTextField.text ?? ""
        
        let comment = comentariosTextField.text ?? ""
        
        reservar.isEnabled = !startDate.isEmpty && !endDate.isEmpty && !description.isEmpty && !comment.isEmpty
    }
    
//    func addReserve() {
////        let nombre = resourceTextField.text ?? ""
////
//        let startDate = InitialDateTextField.text ?? ""
//
//        let endDate = EndDateTextField.text ?? ""
//
//        let description = descripcionTextField.text ?? ""
//
//        let comment = comentariosTextField.text ?? ""
////
//        let reserva = Reserva(resource: idResourceText, start: startDate, finish: endDate, description: description, comments: comment, id_before_update: 1, changed_by_admin: false, changed_by_user: false)
////
//        reservations.append(reserva)
//    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
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
        InitialDatePicker.preferredDatePickerStyle = .wheels
//        InitialDatePicker.datePickerMode = .date
        
        InitialDateTextField.textAlignment = .center
        InitialDateTextField.inputView = InitialDatePicker
        InitialDateTextField.inputAccessoryView = createToolbarInitialDate()
    }
    
    func createEndDatePicker() {
        EndDatePicker.preferredDatePickerStyle = .wheels
//        EndDatePicker.datePickerMode = .date
        
        EndDateTextField.textAlignment = .center
        EndDateTextField.inputView = EndDatePicker
        EndDateTextField.inputAccessoryView = createToolbarEndDate()
    }
    
    @objc func donePressedInitialDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.timeStyle = .short
        
        self.InitialDateTextField.text = dateFormatter.string(from: InitialDatePicker.date)
        self.view.endEditing(true)
        print(dateFormatter)
    }
    
    @objc func donePressedEndDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.timeStyle = .short
        
        self.EndDateTextField.text = dateFormatter.string(from: EndDatePicker.date)
        self.view.endEditing(true)
    }
    
    func convertTimeCurr2DB(date: Date) -> String {
        let dF = DateFormatter()
        dF.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dF.timeZone = TimeZone(abbreviation: "UTC")
        
        dateDB = dF.string(from: date)
        return dateDB
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showAlertReservationDone(){
        // Create Alert View
        let alertView = UIAlertController(title: "Registro exitoso", message: "Su reservación ha sido registrada exitosamente", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title:"Aceptar", style: .default, handler: {(_) in self.changeScreen()}))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func changeScreen(){
        let nextScreen = storyboard! .instantiateViewController(withIdentifier: "main") as! UITabBarController
        nextScreen.modalPresentationStyle = .fullScreen
        self.present(nextScreen, animated: true, completion: nil)
    }


}

/*
 extension ReserveViewController: UIPickerViewDataSource, UIPickerViewDelegate {
 func numberOfComponents(in pickerView: UIPickerView) -> Int {
 return 1
 }
 
 func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
 return salas.count
 }
 
 func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
 return salas[row]
 }
 
 func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
 resourceTextField.text = salas[row]
 resourceTextField.resignFirstResponder()
 }
 
 }
 */
