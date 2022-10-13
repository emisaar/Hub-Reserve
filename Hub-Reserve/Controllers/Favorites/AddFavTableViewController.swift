//
//  AddFavTableViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 02/10/22.
//

import UIKit

class AddFavTableViewController: UITableViewController, UIPickerViewDelegate,  UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        <#code#>
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        <#code#>
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        <#code#>
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        <#code#>
//    }

    
    var favorito: Favorites?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var recursoTextField: UITextField!
    @IBOutlet weak var categoriaTextField: UITextField!
    
    let categorias = ["Salas", "Licencias", "Equipos"]
    let salas = ["Sala 1", "Sala 2", "Sala 3", "Sala 4", "Sala 5", "Sala 6"]
    let licencias = ["Adobe Photoshop", "Norton Antivirus", "Cisco Packet Tracer v2", "WebAssign", "Adobe Illustrator", "Microsoft Office 365"]
    let equipos = ["Macbook Pro M2", "Asus TUF Gaming 15", "Lenovo", "Huawei Notebook 15", "iPad Pro 11", "Cisco Router"]
    var cat = 0
    
    var categPickerView = UIPickerView()
    var recPickerView = UIPickerView()
    
    init?(coder: NSCoder, f: Favorites?) {
        self.favorito = f
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSaveButtonState() {
        let recurso = recursoTextField.text ?? ""
        
        let categoria = categoriaTextField.text ?? ""

        saveButton.isEnabled = !recurso.isEmpty && !categoria.isEmpty
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        categoriaTextField.inputView = categPickerView
        categoriaTextField.placeholder = "Selecciona una categoría"
        categoriaTextField.textAlignment = .center
        categPickerView.delegate = self
        categPickerView.dataSource = self
        categPickerView.tag = 1
        
        recursoTextField.inputView = recPickerView
        recursoTextField.placeholder = "Selecciona un recurso"
        recursoTextField.textAlignment = .center
        recPickerView.delegate = self
        recPickerView.dataSource = self
        recPickerView.tag = 2
        
        if let favorito = favorito {
//            recursoTextField.text = favorito.name
//            categoriaTextField.text = String(favorito.resourceID)
            
            
             
            title = "Editar favorito"
        }
        else{
            title = "Insertar favorito"
        }
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
        
        let recurso = recursoTextField.text ?? ""
        
        let categoria = categoriaTextField.text ?? ""
        
        if (categoria == "Salas") {
            cat = 1
        }
        
        if (categoria == "Licencias") {
            cat = 2
        }
        
        if (categoria == "Equipos") {
            cat = 3
        }
        
        
//        favorito = Favorites(name: recurso, resourceID: cat)
    }

}

extension AddFavTableViewController{
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int{
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
            switch pickerView.tag{
            case 1:
                return categorias.count
                
            case 2:
                if (categoriaTextField.text == "Salas"){
                    return salas.count
                }
                
                if (categoriaTextField.text == "Licencias"){
                    return licencias.count
                }
                
                else{
                    return equipos.count
                }
                
            default:
                return 1
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
            switch pickerView.tag{
            case 1:
                return categorias[row]
                
            case 2:
                if (categoriaTextField.text == "Salas"){
                    return salas[row]
                }
                
                if (categoriaTextField.text == "Licencias"){
                    return licencias[row]
                }
                
                else{
                    return equipos[row]
                }
            default:
                return "Data not found."
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
            switch pickerView.tag {
            case 1:
                categoriaTextField.text = categorias[row]
                categoriaTextField.resignFirstResponder()
                recursoTextField.text = ""
                recursoTextField.resignFirstResponder()
            
            case 2:
                if (categoriaTextField.text == "Salas"){
                    recursoTextField.text = salas[row]
                    recursoTextField.resignFirstResponder()
                }
                
                if (categoriaTextField.text == "Licencias"){
                    recursoTextField.text = licencias[row]
                    recursoTextField.resignFirstResponder()
                }
                
                if (categoriaTextField.text == "Equipos"){
                    recursoTextField.text = equipos[row]
                    recursoTextField.resignFirstResponder()
                }
            default:
                return
            }
        }
        
    }
