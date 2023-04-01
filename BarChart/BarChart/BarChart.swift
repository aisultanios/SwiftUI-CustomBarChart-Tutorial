//
//  BarChart.swift
//  BarChart
//
//  Created by Aisultan Askarov on 1.04.2023.
//

import SwiftUI

struct BarChart: View {
    
    var updates: [dummyDataStruct] = []

    //Gesture Properties
    @GestureState var isDragging: Bool = false
    @State var offset: CGFloat = 0.0
    
    //Current Update
    @State private var currentUpdateID: String = ""
    
    var body: some View {
        
        VStack(alignment: .center) {
            GeometryReader { proxy in
                HStack(alignment: .bottom, spacing: 5) {
                    
                    ForEach(0..<updates.count, id: \.self) { i in
                        
                        VStack(alignment: .center) {
                            
                            if i > 0 {
                                self.displayBar(proxy: proxy, previousUpdate: updates[i - 1], update: updates[i])
                            } else {
                                self.displayBar(proxy: proxy, previousUpdate: nil, update: updates[i])
                            }
                            
                            Text(updates[i].date)
                                .foregroundColor(.black.opacity(0.75))
                                .font(.system(size: 9.0, weight: .regular, design: .rounded))
                                .multilineTextAlignment(.center)
                            
                        }
                    }
                }//: HSTACK
                .frame(width: proxy.size.width - 50, alignment: .center)
                .frame(maxWidth: proxy.size.width, alignment: .center)
                .animation(.easeOut, value: isDragging)
                .gesture(
                    DragGesture()
                        .updating($isDragging, body: { _, out, _ in
                            out = true
                        })
                        .onChanged({ value in
                            offset = isDragging ? value.location.x - 50 : 0
                            
                            //Dragging Space
                            
                            //Each bar
                            let eachBlock = CGFloat((proxy.size.width - 110) / Double(self.updates.count))
                            
                            //getting index
                            let temp = Int(offset / eachBlock)
                            
                            //safe wrapping index
                            let index = max(min(temp, updates.count - 1), 0)
                            
                            self.currentUpdateID = updates[index].id
                            
                        })
                        .onEnded({ value in
                            withAnimation {
                                offset = .zero
                                currentUpdateID = ""
                            }
                        })
                )
            }//: GEOMETRYREADER
        }//: VSTACK
    }
    
    func displayBar(proxy: GeometryProxy, previousUpdate: dummyDataStruct?, update: dummyDataStruct?) -> some View {
        
        
        return VStack(alignment: .center) {
            
            Text(update?.value ?? "")
                    .foregroundColor(.white)
                    .font(.system(size: 18.0, weight: .semibold, design: .rounded))
                    .minimumScaleFactor(0.8)
                    .shadow(color: .white.opacity(0.5), radius: 2.5)
                    .multilineTextAlignment(.center)
                    .opacity(isDragging ? (currentUpdateID == update?.id ? 1 : 0.35) : 1)
                
                // Set a Bar if there is an update
                Rectangle()
                    .cornerRadius(3.5)
                    .foregroundColor(self.getColor(previousUpdate: previousUpdate, update: update))
                    .frame(width: CGFloat((proxy.size.width - 110) / Double(self.updates.count)))
                    .frame(height:(CGFloat(Int(update?.value ?? "5")!) / 10) * (proxy.size.height - 50))
                    .opacity(isDragging ? (currentUpdateID == update?.id ? 1 : 0.35) : 1)
                    
                
        }
    }
    
    func getColor(previousUpdate: dummyDataStruct?, update: dummyDataStruct?) -> Color {
        
        let followers = update?.value ?? "0"
        var color: Color = .clear
        if let prev = previousUpdate, update != nil {
            
            let followersInPreviousUpdate = prev.value
            
            if followers > followersInPreviousUpdate {
                color = Color.green
            } else if followers < followersInPreviousUpdate {
                color = Color.red
            } else {
                color = Color.gray
            }
        } else if previousUpdate == nil, update != nil {
            // handle the case where previousUpdate is nil
            let followersInPreviousUpdate = previousUpdate?.value ?? "0"
            
            if followers > followersInPreviousUpdate {
                color = Color.green
            } else if followers < followersInPreviousUpdate {
                color = Color.red
            } else {
                color = Color.gray
            }
        } else if update == nil {
            color = Color.clear
        }
        
        return color
    }
    
}//: BARCHART
