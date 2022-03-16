//
//  MainScreenView.swift
//  connect_four_00857125
//
//  Created by nighthao on 2022/3/16.
//

import SwiftUI

struct MainScreenView: View {
    @State private var showContentView = false
    @State private var nowmode:gamemode = .pvp
    @State private var moveDistance: Double = 50
    @State private var opacity: Double = 1
    var body: some View {
        VStack(spacing: 20){
            Button("神奇按鈕") {
                moveDistance += 100
                opacity -= 0.3
            }
                .font(.title)
                HStack {
                    Image("Image-1")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .offset(x: moveDistance, y: 0)
                        .opacity(opacity)
                    Spacer()
            }
            Button("PVP"){
                showContentView = true
                nowmode = .pvp
            }.fullScreenCover(isPresented: $showContentView, content:{ContentView(showContentView: $showContentView, nowmode: $nowmode)})
                
            Button("PVE"){
                showContentView = true
                nowmode = .pve
            }.fullScreenCover(isPresented: $showContentView, content:{ContentView(showContentView: $showContentView, nowmode: $nowmode)})
            }
        }
    }

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}

