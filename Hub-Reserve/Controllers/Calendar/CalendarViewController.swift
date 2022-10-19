//
//  CalendarViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 22/09/22.
//

import UIKit

fileprivate var aView : UIView?

class CalendarViewController: UIViewController, UICalendarSelectionSingleDateDelegate {
    
    var reservations = Reservas()
    
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
        Task{
            do{
                showSpinner()
                let reservas = try await WebService().getReservas(token: token)
                
                var newReservas = [Reserva]()
                
                for r in reservas {
                    if r.status != "Cancelada" && r.status != "Terminada" && r.status != "Cambiada" {
                        newReservas.append(r)
                    }
                }
                
//                print(newReservas)
//                updateUI(with: newReservas)
                reservations = newReservas
                removeSpinner()
            }catch{
                displayError(NetworkError.noData, title: "No se pudo acceder a las reservas")
                removeSpinner()
            }
        }
        createCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jwt") else {
            return
        }
        
        print("TOKEN")
        print(token)
        Task{
            do{
                let reservas = try await WebService().getReservas(token: token)
                
                var newReservas = [Reserva]()
                
                for r in reservas {
                    if r.status != "Cancelada" && r.status != "Terminada" && r.status != "Cambiada" {
                        newReservas.append(r)
                    }
                }
                
//                print(newReservas)
//                updateUI(with: newReservas)
                reservations = newReservas
                removeSpinner()
            }catch{
                displayError(NetworkError.noData, title: "No se pudo acceder a las reservas")
                removeSpinner()
            }
        }
    }
/*
    func updateUI(with reservas: Reservas){
        DispatchQueue.main.async {
            self.reservations = reservas
//            self.tableView.reloadData()
        }
    }
 */
    
    func displayError(_ error: Error, title: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func createCalendar() {
        if #available(iOS 16.0, *) {
            let calendarView = UICalendarView()
            calendarView.translatesAutoresizingMaskIntoConstraints = false
            
            calendarView.calendar = .current
            calendarView.locale = .current
            calendarView.fontDesign = .rounded
            calendarView.delegate = self
            
            view.addSubview(calendarView)
            NSLayoutConstraint.activate([
                calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                calendarView.heightAnchor.constraint(equalToConstant: 420),
                calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
            
            let selection = UICalendarSelectionSingleDate(delegate: self)
            calendarView.selectionBehavior = selection
            
            calendarView.delegate = self
            
                
        } else {
            // Fallback on earlier versions
        }
    }

    
    func changeDateFormat(dateString: String) -> String {
        let isoDate1 = dateString
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from:isoDate1)!
    
        let dateSFormatter = DateFormatter()
        dateSFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        return dateSFormatter.string(from: date)
    }

}




@available(iOS 16.0, *)
extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let day = dateComponents.day else {
            return nil
        }
        
        print("Reservations-----")
        print(reservations)

        if !day.isMultiple(of: 2) {
            return UICalendarView.Decoration.default(color: .systemGreen, size: .small)
        }

        
        return nil
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
//        print(dateComponents?.hour)
        print(dateComponents?.date)
//        let date = NSCalendar.current.date(from: (dateComponents)!)
//        let sDate = DateFormatter()
//        sDate.string(from: date!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let date = dateFormatter.string(from: (dateComponents?.date)!)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CalendarReserve") as? CalendarReservationViewController

        vc?.startDate = dateFormatter.string(from: (dateComponents?.date)!)
        navigationController?.pushViewController(vc!, animated: true)
        }
}
