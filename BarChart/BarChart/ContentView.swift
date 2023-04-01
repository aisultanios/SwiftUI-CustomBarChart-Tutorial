//
//  ContentView.swift
//  BarChart
//
//  Created by Aisultan Askarov on 1.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    let dummyData: [dummyDataStruct] = [.init(date: "Mar 26", value: "10"), .init(date: "Mar 27", value: "9"), .init(date: "Mar 28", value: "9"), .init(date: "Mar 29", value: "10"), .init(date: "Mar 30", value: "7"), .init(date: "Mar 31", value: "8"), .init(date: "Apr 1", value: "9")]
    
    @State var animate: Bool = false
    
    var body: some View {
        VStack {
            Text("Dummy Data")
                .font(.title)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 250)
                .foregroundColor(.gray.opacity(0.2))
                .overlay {
                    
                    VStack {
                        BarChart(updates: dummyData)
                            .frame(height: animate ? 200: 0)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.75)) {
                                    animate.toggle()
                                }
                            }
                            .padding([.top, .bottom])
                    }
                    
                }
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct dummyDataStruct: Identifiable {
    let id: String = UUID().uuidString
    var date: String
    var value: String
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
    
}
