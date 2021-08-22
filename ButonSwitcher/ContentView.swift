//
//  ContentView.swift
//  ButonSwitcher

import SwiftUI

class ActiveButton: ObservableObject {
    @Published var selectedBtn = BttnView(theLabel: "",
                                          highLight: false)
    var needInit = true
}

struct ContentView: View {
    @State var butnsPool:[String]
    @State var initialHilight:Int
    @StateObject var selectedBox = ActiveButton()
    
    func makeBttnView(_ butnStr: String) -> BttnView {
        let resultBtn:BttnView
        
        if butnsPool.firstIndex(of: butnStr) == initialHilight {
            resultBtn = BttnView(theLabel: butnStr, highLight: true)
            
            if selectedBox.needInit {
                selectedBox.selectedBtn = resultBtn
                selectedBox.needInit = false
            }
        } else {resultBtn = BttnView(theLabel: butnStr, highLight: false)}
        
        return resultBtn
    }
    
    var body: some View {
        ForEach(butnsPool, id: \.self) {
            btn in
            makeBttnView(btn)
                .environmentObject(selectedBox)
        }
    }
}


struct BttnView: View {
    var theLabel:String
    @State var highLight: Bool
    @EnvironmentObject var selectedBox: ActiveButton

    var body: some View {
        Button(action: {
            selectedBox.selectedBtn.highLight = false
            highLight = true
            selectedBox.selectedBtn = self
        })
        {
            BtnTxtView(theLabel: theLabel,
                       highLight: highLight)
        }
    }
}


struct BtnTxtView: View {
    var theLabel:String
    var highLight: Bool

    var body: some View {
        let crnrRad:CGFloat = 19.0
        Text(theLabel)
            .foregroundColor(.blue)
            .padding(.horizontal, 13)
            .padding(.vertical, 7)
            .font(.largeTitle)
            .if (highLight) { $0
                .background(Color.yellow)
                .cornerRadius(crnrRad)
                .overlay(RoundedRectangle(cornerRadius: crnrRad)
                            .stroke(Color.purple, lineWidth: 4.0))
            }
    }
}


extension View {
  @ViewBuilder
  func `if`<Transform: View>(
    _ condition: Bool,
    transform: (Self) -> Transform
  ) -> some View {
    if condition {transform(self)}
    else {self}
  }
}
