//
//  ContentView.swift
//  ButonSwitcher

import SwiftUI

class ActiveButton: ObservableObject {
    @Published var title = ""
}

struct ContentView: View {
    var butnsPool:[String], initialHilight:Int
    @StateObject var selectedBox = ActiveButton()
    
    var body: some View {
        ForEach(butnsPool, id: \.self) {
            btn in
            BttnView(theLabel: btn,
                     highLight: false,
                     selectedBox: selectedBox)
        }.onAppear {
            selectedBox.title = butnsPool[initialHilight]
        }
    }
}


struct BttnView: View {
    var theLabel:String
    @State var highLight: Bool
    @ObservedObject var selectedBox: ActiveButton

    var body: some View {
        Button(action: {
            selectedBox.title = theLabel
        })
        {
            BtnTxtView(theLabel: theLabel,
                       highLight: (theLabel == selectedBox.title))
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
