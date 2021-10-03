//
//  ContentView.swift
//  Shared
//
//  Created by mike willard on 9/30/21.
//

import SwiftUI

struct model {
    let temp: Int
    let humidity: Int
}

struct ProgressBar: View {
    var progress: Double
    let formatStr: String!
    let title: String!
    
    @ObservedObject var stocks = Stocks()
    
    private let gradient = AngularGradient(
        gradient: Gradient(colors: [Color(red: 0.8, green: 0.0, blue: 0.8), .blue]),
        center: .center,
        startAngle: .degrees(0),
        endAngle: .degrees(270))
    
    var body: some View {
        VStack {
            ZStack {
                
                Circle()
                    .trim(from: 0.0, to: 0.75)
                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .opacity(0.3)
                    .foregroundColor(Color.blue)
                    .rotationEffect(Angle(degrees: 135.0))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat((min(self.progress, 100.0) / 100)) * 0.75)
                    .stroke(gradient, style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.blue)
                    .rotationEffect(Angle(degrees: 135.0))
                    .animation(.linear)
                
                Circle()
                    .trim(from: (CGFloat((min(self.progress, 100.0) / 100)) * 0.75)-0.0005, to: (CGFloat((min(self.progress, 100.0) / 100)) * 0.75)+0.0005)
                    .stroke(style: StrokeStyle(lineWidth: 23.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.white)
                    .rotationEffect(Angle(degrees: 135.0))
                    .animation(.linear)
                    .background(Circle().fill(Color.clear))
                
                Text(String(format: formatStr, min(self.progress, 100.0)))
                    .font(.system(size: 84.0))
                    .bold()
            }
            Text(title).foregroundColor(.secondary)
        }
    }
}

struct ContentView: View {
    @ObservedObject var bleManager = BLEManager()
    
    @State var flipped = false // state variable used to update the card
    
    var body: some View {
        VStack {
            Text("blueSea")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.blue)
            Spacer()
            HStack {
                Spacer()
                ZStack(alignment: .top) {
                    Rectangle()
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                        .frame(width: 400.0, height: 400.0)
                        .cornerRadius(16.0)
                    if !self.flipped {
                        ProgressBar(progress: bleManager.temp, formatStr: "%.0f%º", title: "Temperature")
                            .frame(width: 300.0, height: 300.0)
                            .padding(40.0)
                    } else {
                        VStack {
                            HStack(alignment: .top) {
                                Text("Temperature")
                                Spacer()
                                Text(String(format:"%.0f%º", bleManager.temp)).font(.largeTitle)
                            }.frame(width: 360.0, height: 80.0)
                            Spacer()
                        }
                        .frame(width: 300.0, height: 300.0)
                        .rotation3DEffect(.degrees(180.0), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                .animation(.default)
                .onTapGesture { self.flipped.toggle() }
                Spacer()
                ZStack(alignment: .top) {
                    Rectangle()
                        .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                        .frame(width: 400.0, height: 400.0)
                        .cornerRadius(16.0)
                    if !self.flipped {
                        ProgressBar(progress: bleManager.humidity, formatStr: "%.0f%%", title: "Humidity")
                            .frame(width: 300.0, height: 300.0)
                            .padding(40.0)
                    } else {
                        VStack {
                            HStack(alignment: .top) {
                                Text("Humidity")
                                Spacer()
                                Text(String(format:"%.0f%%", bleManager.humidity)).font(.largeTitle)
                            }.frame(width: 360.0, height: 80.0)
                            Spacer()
                        }
                        .frame(width: 300.0, height: 300.0)
                        .rotation3DEffect(.degrees(180.0), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .rotation3DEffect(self.flipped ? Angle(degrees: 180): Angle(degrees: 0), axis: (x: CGFloat(0), y: CGFloat(10), z: CGFloat(0)))
                .animation(.default)
                .onTapGesture { self.flipped.toggle() }
                
                Spacer()
            }
            Spacer()
            if !bleManager.isSwitchedOn {
                Text("Bluetooth is NOT switched on")
                    .foregroundColor(.red)
            }
            HStack {
                Button(action: {
                    self.bleManager.startScanning()
                }) {
                    Text("Start")
                }
                Button(action: {
                    self.bleManager.stopScanning()
                }) {
                    Text("Stop")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
