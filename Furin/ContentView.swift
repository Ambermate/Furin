//
//  ContentView.swift
//  Furin
//
//  Created by Long Hai on 11/2/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("sendNoti") var notification = false
    var body: some View {
        CameraView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
