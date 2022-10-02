//
//  RoomsViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 29/09/22.
//

import UIKit

class RoomsViewController: UIViewController {

    @IBOutlet weak var resourceTextField: UITextField!
    @IBOutlet weak var InitialDateTextField: UITextField!
    @IBOutlet weak var EndDateTextField: UITextField!
    
    let salas = ["Sala 1", "Sala 2", "Sala 3", "Sala 4", "Sala 5"]
    
    var roomsPickerView = UIPickerView()
    
    let InitialDatePicker = UIDatePicker()
    let EndDatePicker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        resourceTextField.inputView = roomsPickerView
        resourceTextField.placeholder = "Seleccione sala"
        resourceTextField.textAlignment = .center
        
        InitialDateTextField.placeholder = "Seleccione fecha y hora inicio"
        InitialDateTextField.textAlignment = .center
        
        EndDateTextField.placeholder = "Seleccione fecha y hora fin"
        EndDateTextField.textAlignment = .center
        
        roomsPickerView.delegate = self
        roomsPickerView.dataSource = self
        
        createInitialDatePicker()
        createEndDatePicker()
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
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        self.InitialDateTextField.text = dateFormatter.string(from: InitialDatePicker.date)
        self.view.endEditing(true)

    }
    
    @objc func donePressedEndDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        self.EndDateTextField.text = dateFormatter.string(from: EndDatePicker.date)
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RoomsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
