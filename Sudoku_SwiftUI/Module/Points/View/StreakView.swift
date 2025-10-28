//
//  StreakView.swift
//  Sudoku_SwiftUI
//
//  Created by Dileep Kumar on 15/10/25.
//

import SwiftUI

// MARK: - Streak View

struct StreakView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDate: Date? = nil
    @State private var currentMonth: Date = Date()
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color(UIColor.black.withAlphaComponent(0.5))
                .ignoresSafeArea()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 10)
                    .padding(.trailing, 10)
                }// HStack
                
                HStack {
                    Button(action: {
                        changeMonth(by: -1)
                    }) {
                        Image(systemName: "arrowtriangle.left.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        changeMonth(by: 1)
                    }) {
                        Image(systemName: "arrowtriangle.right.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }// HStack
                .padding()
                
                Divider()
                
                CalendarView(selectedDate: $selectedDate, currentMonth: $currentMonth)
                    .frame(height: 350)
                    .padding(.bottom, 10)
                
                if let date = selectedDate {
                    Text("Selected: \(date.formatted(.dateTime.month().day().year()))")
                        .padding(.bottom, 10)
                }
            }// VStack
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }// ZStack
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
}

// MARK: - Preview

#Preview {
    StreakView()
}
