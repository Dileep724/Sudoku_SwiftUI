//
//  CalendarView.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 15/10/25.
//

import SwiftUI
import FSCalendar

// MARK: - Calendar View

struct CalendarView: UIViewRepresentable {
    
    // MARK: - Properties
    
    @Binding var selectedDate: Date?
    @Binding var currentMonth: Date

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.allowsSelection = true
        calendar.scope = .month
        calendar.scrollDirection = .horizontal
        
        calendar.placeholderType = .none
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.headerDateFormat = ""
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titlePlaceholderColor = .clear
        calendar.currentPage = currentMonth
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        if let date = selectedDate {
            uiView.select(date)
        }
        if uiView.currentPage != currentMonth {
            uiView.setCurrentPage(currentMonth, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: CalendarView
        init(_ parent: CalendarView) { self.parent = parent }

        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            let weekday = Calendar.current.component(.weekday, from: date)
            if weekday == 1 {
                return UIColor.red
            }
            return nil
        }
    }
}
