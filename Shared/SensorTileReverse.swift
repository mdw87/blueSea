//
//  SensorTileReverse.swift
//  BlueSea
//
//  Created by mike willard on 10/2/21.
//

import SwiftUI

struct SensorTileReverse: View {
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                .frame(width: 400.0, height: 400.0)
                .cornerRadius(16.0)
            VStack {
                HStack(alignment: .top) {
                    Text("Temperature").foregroundColor(.white)
                    Spacer()
                    Text(String(format:"%.0f%º", 75.0)).foregroundColor(.white).font(.largeTitle)
                }.frame(width: 360.0, height: 80.0)
                Spacer()
            }
            .frame(width: 300.0, height: 300.0)
        }
    }
}

struct SensorTileReverse_Previews: PreviewProvider {
    static var previews: some View {
        SensorTileReverse()
    }
}
