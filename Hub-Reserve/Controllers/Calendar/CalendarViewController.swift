//
//  CalendarViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 22/09/22.
//

import UIKit

class CalendarViewController: UIViewController, UICalendarSelectionSingleDateDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        createCalendar()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
