//
//  CalendarViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 22/09/22.
//

import UIKit

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createCalendar()
    }
    
    func createCalendar() {
        if #available(iOS 16.0, *) {
            let calendar = UICalendarView()
            calendar.translatesAutoresizingMaskIntoConstraints = false
            
            calendar.calendar = .current
            calendar.locale = .current
            calendar.fontDesign = .rounded
            calendar.delegate = self
            
            view.addSubview(calendar)
            NSLayoutConstraint.activate([
                calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                calendar.heightAnchor.constraint(equalToConstant: 400),
                calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
                
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
}
