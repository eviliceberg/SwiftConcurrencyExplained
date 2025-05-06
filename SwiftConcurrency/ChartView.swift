//
//  ChartView.swift
//  SwiftConcurrency
//
//  Created by Artem Golovchenko on 2025-05-06.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @State private var selectedDate: Date?
    
    var selectedMonth: ViewMonth? {
        guard let selectedDate else { return nil }
        return ViewMonth.mockData.first {
            Calendar.current.isDate(selectedDate, equalTo: $0.date, toGranularity: .month)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("YouTube Views")
                    .bold()
                    .padding(.top)
                
                Text("Total: \(ViewMonth.mockData.reduce(0, { $0 + $1.viewCount }))")
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    
                
                Chart {
                    
                    if let selectedMonth {
                        RuleMark(x: .value("Some tille", selectedMonth.date, unit: .month))
                            .foregroundStyle(.secondary.opacity(0.3))
                            .annotation(overflowResolution: .init(x: .fit, y: .disabled)) {
                                VStack {
                                    Text(selectedMonth.date, format: .dateTime.month(.wide))
                                        .bold()
                                    
                                    Text("\(selectedMonth.viewCount)")
                                        .font(.title3)
                                        .bold()
                                }
                                .frame(width: 130)
                                .padding(.vertical, 8)
                                .background(.pink.gradient)
                                .clipShape(.rect(cornerRadius: 12))
                            }
                    }
                    
                    ForEach(ViewMonth.mockData) { data in
                        BarMark(
                            x: .value("Month", data.date, unit: .month),
                            y: .value("Views", data.viewCount)
                        )
                        .foregroundStyle(.pink.gradient)
                        .opacity(selectedDate == nil || selectedMonth?.date == data.date ? 1.0 : 0.3)
                    }
                }
                .frame(height: 200)
                .chartXSelection(value: $selectedDate.animation(.easeInOut))
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    ChartView()
}

struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let viewCount: Int
    
    static let mockData: [ViewMonth] = [
        .init(date: Date.from(year: 2024, month: 1, day: 1), viewCount: 55000),
        .init(date: Date.from(year: 2024, month: 2, day: 1), viewCount: 65000),
        .init(date: Date.from(year: 2024, month: 3, day: 1), viewCount: 75000),
        .init(date: Date.from(year: 2024, month: 4, day: 1), viewCount: 85000),
        .init(date: Date.from(year: 2024, month: 5, day: 1), viewCount: 95000),
        .init(date: Date.from(year: 2024, month: 6, day: 1), viewCount: 105000),
        .init(date: Date.from(year: 2024, month: 7, day: 1), viewCount: 115000),
        .init(date: Date.from(year: 2024, month: 8, day: 1), viewCount: 125000),
        .init(date: Date.from(year: 2024, month: 9, day: 1), viewCount: 135000),
        .init(date: Date.from(year: 2024, month: 10, day: 1), viewCount: 145000),
        .init(date: Date.from(year: 2024, month: 11, day: 1), viewCount: 155000),
        .init(date: Date.from(year: 2024, month: 12, day: 1), viewCount: 165000)
    ]
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
