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
                calendarView.heightAnchor.constraint(equalToConstant: 400),
                calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
            
            let selection = UICalendarSelectionSingleDate(delegate: self)
            calendarView.selectionBehavior = selection
            
                
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

}


@available(iOS 16.0, *)
extension CalendarViewController: UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print(dateComponents?.hour)
        print(dateComponents?.date)
        }
}
