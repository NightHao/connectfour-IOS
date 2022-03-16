//
//  ContentView.swift
//  connect_four_00857125
//
//  Created by nighthao on 2022/3/12.
//

import SwiftUI
import AVFoundation
struct ContentView: View {
    let musicPlayer = AVPlayer()
    //分類圓圈顏色
    enum CircleColor{
        case white, red, yellow, purple
    }
    //分類玩家
    enum Player{
        case player1, player2, computer
    }
    //時間
    @State private var timeRemaining = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //返回前一頁
    @Binding var showContentView:Bool
    @Binding var nowmode:gamemode
    //是否顯示勝利
    @State var winner: Bool = false
    @State var tie: Bool = false
    @State var winnerColor: String = "White"
    @State var winnumber1: Int = 0
    @State var winnumber2: Int = 0
    //個別玩家所剩回合數
    @State var playRound1:Int = 21
    @State var playRound2:Int = 21
    //為空的點,由下而上
    @State var emptyspot: [Int] = Array(repeating: 5, count: 7)
    //圖片上的點
    @State var spots:[[CircleColor]] = Array(repeating: Array(repeating: .white, count: 7), count: 6)
    //現在是誰的回合
    @State var nowplay:Player = .player1
    //儲存連在一起的點
    @State var brightCircle = [[Int]]()
    //讓其陣列圓圈顏色填入圖中
    func RightColor(color:CircleColor)->Color{
        switch color {
        case .white:
            return Color.white
        case .red:
            return Color.red
        case .yellow:
            return Color.yellow
        case .purple:
            return Color.purple
        }
    }
    //初始化
    func intial(){
        spots = Array(repeating: Array(repeating: .white, count: 7), count: 6)
        nowplay = .player1
        emptyspot = Array(repeating: 5, count: 7)
        playRound1 = 21
        playRound2 = 21
        winnerColor = "White"
        winner = false
        tie = false
        brightCircle = [[Int]]()
        timeRemaining = 300
    }
    //判斷現在輪到誰
    @State var nowTurnColor:Int = 1
    
    func colorTurn()->Color{
        if nowTurnColor == 1{
            return Color.red
        }
        else{
            return Color.yellow
        }
    }
    //判斷是否獲勝
    func judge(x:Int, y:Int)->Bool{
        var len:Int = 1,tmpx:Int = x, tmpy:Int = y
        brightCircle = [[x,y]]
        while tmpy + 1 < 7{
            tmpy += 1
            if spots[x][y] == spots[tmpx][tmpy]{
                len += 1
                brightCircle.append([tmpx, tmpy])
            }
            else{
                break
            }
        }
        tmpy = y
        while tmpy - 1 >= 0{
            tmpy -= 1
            if spots[x][y] == spots[tmpx][tmpy]{
                len += 1
                brightCircle.append([tmpx,tmpy])
            }
            else{
                break
            }
        }
        tmpy = y
        if len >= 4{
            for b in brightCircle{
                spots[b[0]][b[1]] = .purple
            }
            return true
        }
        brightCircle = [[x,y]]
        len = 1
        while tmpx + 1 < 6{
            tmpx += 1
            if spots[x][y] == spots[tmpx][tmpy]{
                len += 1
                brightCircle.append([tmpx, tmpy])
            }
            else{
                break
            }
        }
        tmpx = x
        while tmpx - 1 >= 0{
            tmpx -= 1
            if spots[x][y] == spots[tmpx][tmpy]{
                len += 1
                brightCircle.append([tmpx, tmpy])
            }
            else{
                break
            }
        }
        tmpx = x
        if len >= 4{
            for b in brightCircle{
                spots[b[0]][b[1]] = .purple
            }
            return true
        }
        brightCircle = [[x,y]]
        len = 1
        while tmpx + 1 < 6 && tmpy + 1 < 7{
            tmpx += 1
            tmpy += 1
            if spots[x][y] == spots[tmpx][tmpy]{
                len += 1
                brightCircle.append([tmpx, tmpy])
            }
            else{
                break
            }
        }
        tmpx = x
        tmpy = y
        while tmpx - 1 >= 0 && tmpy - 1 >= 0{
            tmpx -= 1
            tmpy -= 1
            if spots[x][y] == spots[tmpx][tmpy]{
                len += 1
                brightCircle.append([tmpx, tmpy])
            }
            else{
                break
            }
        }
        if len >= 4{
            for b in brightCircle{
                spots[b[0]][b[1]] = .purple
            }
            return true
        }
        brightCircle = [[x,y]]
        tmpx = x
        tmpy = y
        len = 1
        while tmpx - 1 >= 0 && tmpy + 1 < 7{
            tmpx -= 1
            tmpy += 1
            if spots[x][y] == spots[tmpx][tmpy]{
                len += 1
                brightCircle.append([tmpx, tmpy])
            }
            else{
                break
            }
        }
        tmpx = x
        tmpy = y
        while tmpx + 1 < 6 && tmpy - 1 >= 0{
            tmpx += 1
            tmpy -= 1
            if spots[x][y] == spots[tmpx][tmpy]{
                len += 1
                brightCircle.append([tmpx, tmpy])
            }
            else{
                break
            }
        }
        if len >= 4{
            for b in brightCircle{
                spots[b[0]][b[1]] = .purple
            }
            return true
        }
        return false
    }
    @State var animateDone = 0
    func CircleAnimate(color:String, index:Int)->(){
        var cur = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if cur > 0{
                spots[cur - 1][index] = .white
            }
            if color == "red"{
                spots[cur][index] = .red
            }
            else if color == "yellow"{
                spots[cur][index] = .yellow
            }
            if cur == emptyspot[index]{
                emptyspot[index] -= 1
                timer.invalidate()
                animateDone = 1
            }
            cur += 1
        }
    }
    
    //判斷這格現在要填入什麼顏色
    func TapSpot(index:Int, mode:gamemode)->(){
        print(mode)
        if emptyspot[index] >= 0{
            AudioServicesPlaySystemSound(1026)
            if nowTurnColor == 1{
                nowTurnColor = 2
            }
            else{
                nowTurnColor = 1
            }
            //玩家對玩家
            if mode == .pvp{
                if nowplay == .player1{
                    spots[emptyspot[index]][index] = .red
                    playRound1 -= 1
                    if playRound1 < 18{
                        if judge(x: emptyspot[index], y: index) == true{
                            winnerColor = "Red"
                            winner = true
                            winnumber1 += 1
                        }
                    }
                    emptyspot[index] -= 1
                    nowplay = .player2
                }
                else{
                    spots[emptyspot[index]][index] = .yellow
                    playRound2 -= 1
                    if playRound2 < 18{
                        if judge(x: emptyspot[index], y: index) == true{
                            winnerColor = "Yellow"
                            winner = true
                            winnumber2 += 1
                        }
                    }
                    emptyspot[index] -= 1
                    nowplay = .player1
                }
            }
            //玩家對電腦
            else{
                spots[emptyspot[index]][index] = .red
                playRound1 -= 1
                if playRound1 < 18{
                    if judge(x: emptyspot[index], y: index) == true{
                        winnerColor = "Red"
                        winner = true
                        winnumber1 += 1
                    }
                }
                emptyspot[index] -= 1
                var number1 = Int.random(in: 0...6)
                while emptyspot[number1] < 0{
                    number1 = Int.random(in: 0...6)
                }
                spots[emptyspot[number1]][number1] = .yellow
                playRound2 -= 1
                if playRound2 < 18{
                    if judge(x: emptyspot[number1], y: number1) == true && winner == false{
                        winnerColor = "Yellow"
                        winner = true
                        winnumber2 += 1
                    }
                }
                emptyspot[number1] -= 1
            }
        }
        if playRound1 == 0 && playRound2 == 0{
            tie = true
        }
    }
    
    var body: some View {
        VStack(spacing: 2){
            Text("剩餘\(timeRemaining)秒")
                .onReceive(timer) { time in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    }
                    else{
                        tie = true
                    }
                }
            HStack(alignment: .bottom, spacing: 25){
                Image("Image")
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
                Text("\(winnumber1)")
                    .foregroundColor(.black)
                    .font(.title)
                Button{
                    intial()
                }label: {
                    Text("Return")
                }
                Text("\(winnumber2)")
                    .foregroundColor(.black)
                    .font(.title)
                Image("Image-2")
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
            }
            .padding(.top)
            HStack(spacing: 80){
                HStack{
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 45, height: 50)
                    Text("\(playRound1)")
                        .foregroundColor(.red)
                }
                VStack{
                Text("NowTurn")
                    Circle().foregroundColor(colorTurn())
                        .frame(width: 45, height: 50)
                }
                HStack{
                    Text("\(playRound2)")
                            .foregroundColor(.yellow)
                    Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 45, height: 50)
                }
            }
            ZStack{
                Text("Hello World").onAppear{
                let fileUrl = Bundle.main.url(forResource: "music", withExtension: "mp4")!
                                let playerItem = AVPlayerItem(url: fileUrl)
                                self.musicPlayer.replaceCurrentItem(with: playerItem)
                                self.musicPlayer.play()
                }
            Color.blue
                .frame(width: 385, height: 520)
                VStack(alignment: .center) {
                    ForEach(0..<6) { i in
                        HStack {
                            ForEach(0..<7) { j in
                                Circle()
                                    .frame(width: 45, height: 50)
                                    .foregroundColor(RightColor(color: spots[i][j]))
                                    .onTapGesture {
                                        if winner == false{
                                        TapSpot(index: j, mode: nowmode)
                                        }
                                    }
                            }
                        }
                    }
                }
                VStack{
                    if winner == true{
                        Text("\(winnerColor) Win!")
                            .padding(.top)
                            .font(.largeTitle)
                        Button{
                            intial()
                        }label: {
                            Text("Next Round")
                                .padding()
                                .foregroundColor(.mint)
                                .font(.largeTitle)
                        }
                        Button{
                            intial()
                            winnumber1 = 0
                            winnumber2 = 0
                            showContentView = false
                        }label: {
                            Text("Home")
                                .padding()
                                .foregroundColor(.mint)
                                .font(.largeTitle)
                        }
                    }
                    if tie == true{
                        Text("Tie!")
                            .padding(.top)
                            .font(.largeTitle)
                        Button{
                            intial()
                        }label: {
                            Text("Next Round")
                                .padding()
                                .foregroundColor(.mint)
                                .font(.largeTitle)
                        }
                        Button{
                            intial()
                            winnumber1 = 0
                            winnumber2 = 0
                            showContentView = false
                        }label: {
                            Text("Home")
                                .padding()
                                .foregroundColor(.mint)
                                .font(.largeTitle)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showContentView: .constant(true), nowmode: .constant(.pvp))
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}

